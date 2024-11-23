import 'dart:convert';
import 'package:flutter/material.dart';
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
}
