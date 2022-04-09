import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class VideoPreferences {
  static Future<dynamic> getVideos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic videos = prefs.getString('videos');
    return videos == null ? null : json.decode(videos);
  }

  static Future<void> saveVideos(dynamic videos) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('videos', jsonEncode(videos));
  }
}
