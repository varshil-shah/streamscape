import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as http;
import 'package:streamscape/services/storage_service.dart';
import '../models/video_model.dart';
import '../constants.dart';

class VideoService {
  Future<List<VideoModel>> getVideos() async {
    final StorageService storageService = StorageService();
    final token = await storageService.get(jwtKey);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/videos?progress=completed'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('API Response Status: ${response.statusCode}');
        debugPrint('API Response Body: ${response.body}');

        final Map<String, dynamic> responseData = json.decode(response.body);
        debugPrint('Decoded Response Data: $responseData');

        if (responseData['status'] == 'success' &&
            responseData['data'] != null &&
            responseData['data']['videos'] != null) {
          final List<dynamic> videos = responseData['data']['videos'];
          debugPrint('Videos data: $videos');

          return videos.map((video) {
            try {
              return VideoModel.fromJson(video);
            } catch (e, stackTrace) {
              debugPrint('Error parsing individual video: $e');
              debugPrint('Stack trace: $stackTrace');
              debugPrint('Video data: $video');
              rethrow;
            }
          }).toList();
        } else {
          throw Exception('Invalid API response structure: $responseData');
        }
      } else {
        throw Exception('Failed to load videos: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error in getVideos: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<List<VideoModel>> getMyVideos() async {
    final StorageService storageService = StorageService();
    final token = await storageService.get(jwtKey);

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/videos/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('API Response Status: ${response.statusCode}');
        debugPrint('API Response Body: ${response.body}');

        final Map<String, dynamic> responseData = json.decode(response.body);
        debugPrint('Decoded Response Data: $responseData');

        if (responseData['status'] == 'success' &&
            responseData['data'] != null &&
            responseData['data']['videos'] != null) {
          final List<dynamic> videos = responseData['data']['videos'];
          debugPrint('Videos data: $videos');

          return videos.map((video) {
            try {
              return VideoModel.fromJson(video);
            } catch (e, stackTrace) {
              debugPrint('Error parsing individual video: $e');
              debugPrint('Stack trace: $stackTrace');
              debugPrint('Video data: $video');
              rethrow;
            }
          }).toList();
        } else {
          throw Exception('Invalid API response structure: $responseData');
        }
      } else {
        throw Exception('Failed to load videos: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      debugPrint('Error in getVideos: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<String> generateAISummary(
      String description, String subtitleUrl) async {
    final gemini = Gemini.instance;
    String subtitleContent = "";
    if (subtitleUrl.isNotEmpty) {
      final response = await http.get(Uri.parse(subtitleUrl));
      if (response.statusCode == 200) {
        subtitleContent = response.body;
      }
    }

    String prompt = '''
      Please provide a concise summary of this video content. Here are the details:

      Video Description:
      $description

      ${subtitleContent.isNotEmpty ? 'Video Subtitles:\n$subtitleContent' : ''}

      Please generate a clear, informative summary that captures the main points and key takeaways.
      ''';

    final response = await gemini.text(prompt);
    if (response?.content != null) {
      return response!.content!.parts!.first.text.toString();
    } else {
      throw Exception('Failed to generate AI summary');
    }
  }

  Future<Map<String, dynamic>> getUploadUrl({
    required String fileName,
    required String title,
    required String description,
  }) async {
    final StorageService storageService = StorageService();
    final token = await storageService.get(jwtKey);

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/videos/upload'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'fileName': fileName,
          'title': title,
          'description': description,
          'contentType': 'video/mp4',
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return {
          'status': responseData['status'],
          'url': responseData['url'],
        };
      } else {
        throw Exception('Failed to get upload URL: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in getUploadUrl: $e');
      rethrow;
    }
  }

  Future<void> uploadVideoToS3({
    required String uploadUrl,
    required File videoFile,
    required Function(double) onProgress,
  }) async {
    try {
      final fileLength = await videoFile.length();
      debugPrint('Starting upload to URL: $uploadUrl');
      debugPrint('File size: $fileLength bytes');

      // Read file as bytes
      final bytes = await videoFile.readAsBytes();
      debugPrint('File read into memory, starting upload...');

      // Create PUT request
      final uri = Uri.parse(uploadUrl);
      final request = await HttpClient().putUrl(uri);

      // Set headers
      request.headers.set('Content-Type', 'video/mp4');
      request.headers.set('Content-Length', bytes.length.toString());

      // Add data to request
      request.add(bytes);

      // Send the request and get response
      debugPrint('Sending request...');
      final response = await request.close();

      // Read response
      final responseBody = await response.transform(utf8.decoder).join();
      debugPrint('Upload response status: ${response.statusCode}');
      debugPrint('Upload response body: $responseBody');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('Upload completed successfully');
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }

      // Simulate progress (since we're sending all at once)
      onProgress(1.0);
    } catch (e, stackTrace) {
      debugPrint('Error in uploadVideoToS3: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }
}
