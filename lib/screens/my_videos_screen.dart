import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamscape/screens/video_screen.dart';
import '../providers/video_provider.dart';
import '../models/video_model.dart';
import 'package:shimmer/shimmer.dart';

class MyVideosScreen extends StatefulWidget {
  const MyVideosScreen({super.key});

  @override
  State<MyVideosScreen> createState() => _MyVideosScreenState();
}

class _MyVideosScreenState extends State<MyVideosScreen> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.microtask(() =>
          Provider.of<VideoProvider>(context, listen: false).fetchMyVideos());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<VideoProvider>(context, listen: false)
              .fetchMyVideos();
        },
        child: Consumer<VideoProvider>(
          builder: (context, videoProvider, child) {
            if (videoProvider.isLoading) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 5,
                itemBuilder: (context, index) => const VideoCardShimmer(),
              );
            }

            if (videoProvider.error != null) {
              return ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Text(
                        'Error: ${videoProvider.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              );
            }

            if (videoProvider.videos.isEmpty) {
              return ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: const Center(
                      child: Text('No videos found'),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: videoProvider.videos.length,
              itemBuilder: (context, index) {
                final video = videoProvider.videos[index];
                return VideoCard(video: video);
              },
            );
          },
        ),
      ),
    );
  }
}

class VideoCardShimmer extends StatelessWidget {
  const VideoCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
        highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 120,
                  height: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 16,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 14,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final VideoModel video;

  const VideoCard({
    super.key,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoScreen(
                video: video,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Hero(
                tag: 'video-thumbnail-${video.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 120,
                    height: 80,
                    child: video.thumbnailUrl.isNotEmpty
                        ? Image.network(
                            video.thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                                child: Icon(
                                  Icons.video_library,
                                  color: isDarkMode
                                      ? Colors.grey[600]
                                      : Colors.grey[400],
                                ),
                              );
                            },
                          )
                        : Container(
                            color: isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[200],
                            child: Icon(
                              Icons.video_library,
                              color: isDarkMode
                                  ? Colors.grey[600]
                                  : Colors.grey[400],
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            height: 1.2,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: 14,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatViews(video.views),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.grey[600]
                                : Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          _formatDate(video.createdAt),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        const Spacer(),
                        _buildStatusDot(video.progress),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M views';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K views';
    }
    return '$views views';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    }
    return '${(difference.inDays / 365).floor()} years ago';
  }

  Widget _buildStatusDot(String progress) {
    Color dotColor;
    bool shouldSparkle = false;

    switch (progress.toLowerCase()) {
      case 'completed':
        dotColor = Colors.green;
        shouldSparkle = true;
        break;
      case 'processing':
        dotColor = Colors.amber;
        break;
      case 'failed':
        dotColor = Colors.red;
        break;
      case 'queued':
        dotColor = Colors.blue;
        break;
      default:
        dotColor = Colors.grey;
    }

    return shouldSparkle
        ? _SparklingDot(color: dotColor)
        : Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          );
  }
}

class _SparklingDot extends StatefulWidget {
  final Color color;

  const _SparklingDot({required this.color});

  @override
  State<_SparklingDot> createState() => _SparklingDotState();
}

class _SparklingDotState extends State<_SparklingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color
                    .withOpacity(_animation.value * (isDarkMode ? 0.3 : 0.5)),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
