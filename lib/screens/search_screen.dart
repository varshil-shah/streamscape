import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
            onChanged: (query) {
              if (query.isNotEmpty) {
                setState(() {
                  isSearching = true;
                });
              } else {
                setState(() {
                  isSearching = false;
                });
              }
            },
          ),
        ),
        actions: [
          if (isSearching)
            IconButton(
              onPressed: () {
                searchController.clear();
              },
              icon: const Icon(Icons.close),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
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
        ),
      ),
    );
  }
}
