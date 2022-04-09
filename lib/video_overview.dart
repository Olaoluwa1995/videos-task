import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:videos/comment.dart';
import 'package:videos/widgets/item_card.dart';

class VideOverviewScreen extends StatefulWidget {
  const VideOverviewScreen(
      {Key? key, required this.video, required this.videos})
      : super(key: key);

  final dynamic video;
  final List<dynamic> videos;

  @override
  State<VideOverviewScreen> createState() => _VideOverviewScreenState();
}

class _VideOverviewScreenState extends State<VideOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final List<dynamic> videos = widget.videos
        .where(((element) =>
            element['snippet']['title'] != widget.video['snippet']['title']))
        .take(3)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video['snippet']['title']),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        margin: const EdgeInsets.only(top: 20),
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          children: [
            Image.network(
              widget.video['snippet']['thumbnails']['default']['url'],
              width: double.maxFinite,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * 0.5,
                    child: Text(
                      widget.video['snippet']['channelTitle'],
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd hh:mm:ss')
                        .parse(DateTime.parse(
                                widget.video['snippet']['publishedAt'])
                            .toString())
                        .toString(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                widget.video['snippet']['description'],
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CommentScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Leave Comment..',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: Text(
                    'Related Videos',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.3,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: videos.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = videos[index];
                      return Container(
                        height: 150,
                        width: 168,
                        margin: const EdgeInsets.only(right: 10),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
