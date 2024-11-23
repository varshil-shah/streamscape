class VideoModel {
  final VideoResolutions videoResolutions;
  final String id;
  final String title;
  final String description;
  final String fileName;
  final String objectKey;
  final String type;
  final UserModel owner;
  final String progress;
  final int views;
  final bool isPublished;
  final DateTime createdAt;
  final String subtitleUrl;
  final String thumbnailUrl;

  VideoModel({
    required this.videoResolutions,
    required this.id,
    required this.title,
    required this.description,
    required this.fileName,
    required this.objectKey,
    required this.type,
    required this.owner,
    required this.progress,
    required this.views,
    required this.isPublished,
    required this.createdAt,
    required this.subtitleUrl,
    required this.thumbnailUrl,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    try {
      return VideoModel(
        videoResolutions:
            VideoResolutions.fromJson(json['videoResolutions'] ?? {}),
        id: json['_id'] ?? '',
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        fileName: json['fileName'] ?? '',
        objectKey: json['objectKey'] ?? '',
        type: json['type'] ?? '',
        owner: UserModel.fromJson(json['owner'] ?? {}),
        progress: json['progress'] ?? '',
        views: json['views'] ?? 0,
        isPublished: json['isPublished'] ?? false,
        createdAt: DateTime.parse(
            json['createdAt'] ?? DateTime.now().toIso8601String()),
        subtitleUrl: json['subtitleUrl'] ?? '',
        thumbnailUrl: json['thumbnailUrl'] ?? '',
      );
    } catch (e, stackTrace) {
      print('Error parsing VideoModel: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }
}

class VideoResolutions {
  final String r360p;
  final String r480p;
  final String r720p;
  final String r1080p;
  final String playlist;

  VideoResolutions({
    required this.r360p,
    required this.r480p,
    required this.r720p,
    required this.r1080p,
    required this.playlist,
  });

  factory VideoResolutions.fromJson(Map<String, dynamic> json) {
    try {
      return VideoResolutions(
        r360p: json['360p'] ?? '',
        r480p: json['480p'] ?? '',
        r720p: json['720p'] ?? '',
        r1080p: json['1080p'] ?? '',
        playlist: json['playlist'] ?? '',
      );
    } catch (e, stackTrace) {
      print('Error parsing VideoResolutions: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }
}

class UserModel {
  final String id;
  final String displayName;
  final String email;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      return UserModel(
        id: json['_id'] ?? '',
        displayName: json['displayName'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? '',
        createdAt: DateTime.parse(
            json['createdAt'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(
            json['updatedAt'] ?? DateTime.now().toIso8601String()),
      );
    } catch (e, stackTrace) {
      print('Error parsing UserModel: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }
}
