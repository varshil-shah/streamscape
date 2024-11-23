import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:streamscape/constants.dart';
import 'package:streamscape/models/video_model.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/services.dart';

class VideoScreen extends StatefulWidget {
  final VideoModel video;
  const VideoScreen({super.key, required this.video});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  bool _hasError = false;
  BetterPlayerController? _betterPlayerController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializePlayer();
  }

  void _initializePlayer() {
    try {
      const betterPlayerConfiguration = BetterPlayerConfiguration(
        aspectRatio: 16 / 9,
        fit: BoxFit.contain,
        autoPlay: true,
        looping: false,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        deviceOrientationsOnFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enablePlayPause: true,
          enableFullscreen: true,
          enableMute: true,
          enableProgressBar: true,
          enableProgressText: true,
          enableSkips: true,
          loadingWidget: Center(child: CircularProgressIndicator()),
        ),
        placeholder: Center(child: CircularProgressIndicator()),
        showPlaceholderUntilPlay: true,
        subtitlesConfiguration: BetterPlayerSubtitlesConfiguration(
          fontSize: 16,
          fontColor: Colors.white,
          backgroundColor: Colors.black54,
          outlineColor: Colors.black,
          outlineSize: 2.0,
        ),
      );

      final List<BetterPlayerSubtitlesSource> subtitles =
          widget.video.subtitleUrl.isNotEmpty
              ? [
                  BetterPlayerSubtitlesSource(
                    type: BetterPlayerSubtitlesSourceType.network,
                    name: "Default Subtitle",
                    urls: [widget.video.subtitleUrl],
                  ),
                ]
              : [];

      final betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.video.videoResolutions.playlist,
        videoFormat: BetterPlayerVideoFormat.hls,
        subtitles: subtitles,
        cacheConfiguration: const BetterPlayerCacheConfiguration(
          useCache: true,
          maxCacheSize: 10 * 1024 * 1024,
          maxCacheFileSize: 10 * 1024 * 1024,
        ),
      );

      _betterPlayerController =
          BetterPlayerController(betterPlayerConfiguration);
      _betterPlayerController!.setupDataSource(betterPlayerDataSource);

      _betterPlayerController!.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
          setState(() => isLoading = false);
          debugPrint("Player initialized with subtitles: ${subtitles.length}");
        } else if (event.betterPlayerEventType ==
            BetterPlayerEventType.exception) {
          setState(() {
            _hasError = true;
            isLoading = false;
          });
          debugPrint("Video player exception: ${event.parameters}");
        }
      });
    } catch (error) {
      setState(() {
        _hasError = true;
        isLoading = false;
      });
      debugPrint("Error initializing player: $error");
    }
  }

  @override
  void dispose() {
    _betterPlayerController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildVideoPlayer() {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(color: Colors.white),
        ),
      );
    }

    if (_hasError) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 50),
              const SizedBox(height: 16),
              const Text(
                "Error playing video",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    isLoading = true;
                    _initializePlayer();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(controller: _betterPlayerController!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player
            Container(
              color: Colors.black,
              child: _buildVideoPlayer(),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )
                          : Text(
                              widget.video.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),

                      const SizedBox(height: 20),

                      // Channel Info Row
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              widget.video.owner.displayName[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.video.owner.displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 8),

                      // Tabs with modern styling
                      Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  height: 46,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                            : TabBar(
                                controller: _tabController,
                                indicatorColor: primaryColor,
                                labelColor: primaryColor,
                                unselectedLabelColor: Colors.grey,
                                indicatorWeight: 3,
                                labelStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                unselectedLabelStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                tabs: const [
                                  Tab(text: "Description"),
                                  Tab(text: "AI Summary"),
                                ],
                              ),
                      ),

                      const SizedBox(height: 16),

                      // Tab Content with Shimmer
                      SizedBox(
                        height: 200, // Fixed height for content
                        child: isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 16,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 16,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : TabBarView(
                                controller: _tabController,
                                children: [
                                  SingleChildScrollView(
                                    child: Text(
                                      widget.video.description,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    child: Text(
                                      widget.video.description,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
