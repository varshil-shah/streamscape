import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:streamscape/screens/video_screen.dart';
import 'dart:async';
import '../providers/video_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    setState(() {
      isSearching = query.isNotEmpty;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<VideoProvider>().searchVideos(query);
      } else {
        context.read<VideoProvider>().clearSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final videoProvider = context.watch<VideoProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Material(
          color: Colors.transparent,
          child: TextField(
            controller: searchController,
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
            ),
            onChanged: _onSearchChanged,
          ),
        ),
        actions: [
          if (isSearching)
            IconButton(
              onPressed: () {
                searchController.clear();
                context.read<VideoProvider>().clearSearch();
                setState(() {
                  isSearching = false;
                });
              },
              icon: const Icon(Icons.close),
            ),
        ],
      ),
      body: SafeArea(
        child: videoProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : !isSearching
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/search.svg',
                          height: size.height * 0.4,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Type to search...",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  )
                : videoProvider.searchResults.isEmpty
                    ? const Center(
                        child: Text('No results found'),
                      )
                    : ListView.builder(
                        itemCount: videoProvider.searchResults.length,
                        itemBuilder: (context, index) {
                          final video = videoProvider.searchResults[index];
                          return ListTile(
                            leading: Image.network(
                              video.thumbnailUrl,
                              width: 100,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 100,
                                height: 56,
                                color: Colors.grey,
                                child: const Icon(Icons.error),
                              ),
                            ),
                            title: Text(video.title),
                            subtitle: Text(
                              video.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              // Update selected video
                              videoProvider.setSelectedVideo(video);

                              // Navigate to video player screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VideoScreen(video: video),
                                ),
                              );
                            },
                          );
                        },
                      ),
      ),
    );
  }
}
