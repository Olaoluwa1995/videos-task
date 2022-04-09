import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:videos/local_db/videos_preference.dart';
import 'package:videos/video_overview.dart';
import 'package:videos/widgets/item_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  List<dynamic> videos = [];

  @override
  void initState() {
    getYoutubeVideos();
    super.initState();
  }

  Future<void> getYoutubeVideos() async {
    setState(() {
      loading = true;
    });
    dynamic persistedVideos = await VideoPreferences.getVideos();
    if (persistedVideos != null) {
      videos = persistedVideos;
    } else {
      http.Response response = await http.get(
        Uri.parse(
            'https://www.googleapis.com/youtube/v3/search?key=AIzaSyBXMmxLVIK1jm1j0my0W3ymwbJ9RR1EHpc&part=snippet,id&maxResults=20'),
        headers: {'Content-Type': 'application/json'},
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      videos = responseData['items'];
      await VideoPreferences.saveVideos(videos);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Youtube Videos'),
      ),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Container(
                height: size.height,
                width: size.width,
                margin: const EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 50),
                  itemCount: videos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4 / 5.5,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final item = videos[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                VideOverviewScreen(video: item, videos: videos),
                          ),
                        );
                      },
                      child: ItemCard(
                          image: item['snippet']['thumbnails']['default']
                              ['url'],
                          name: item['snippet']['title'],
                          channelTitle: item['snippet']['channelTitle'],
                          date: item['snippet']['publishedAt']),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
