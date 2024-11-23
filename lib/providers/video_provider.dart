import 'package:flutter/material.dart';
import '../models/video_model.dart';
import '../services/video_service.dart';

class VideoProvider extends ChangeNotifier {
  final VideoService _videoService = VideoService();
  List<VideoModel> _videos = [];
  VideoModel? _selectedVideo;
  bool _isLoading = true;
  String? _error;

  List<VideoModel> get videos => _videos;
  VideoModel? get selectedVideo => _selectedVideo;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setSelectedVideo(VideoModel video) {
    _selectedVideo = video;
    notifyListeners();
  }

  Future<void> fetchVideos() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final videos = await _videoService.getVideos();
      _videos = videos;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      _videos = [];
      notifyListeners();
    }
  }
}
