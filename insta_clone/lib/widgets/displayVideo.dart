import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class DisplayVideo extends StatefulWidget {
  final snap;
  const DisplayVideo({Key? key, required this.snap}) : super(key: key);

  @override
  DisplayVideoState createState() => DisplayVideoState();
}

class DisplayVideoState extends State<DisplayVideo> {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;

  void getVideoFromCache() async {
    final file =
        await DefaultCacheManager().getFileFromCache(widget.snap['postUrl']);
    if (file == null || file.file == null) {
      print("not in cache");
      DefaultCacheManager().downloadFile(widget.snap['postUrl']);
      setState(() {
        _videoController = VideoPlayerController.file(widget.snap['postUrl']);
      });
    } else {
      print("already in cache");
      setState(() {
        _videoController = VideoPlayerController.file(file.file);
      });
    }
    print(_videoController.dataSourceType);
    setState(() {
      _chewieController = new ChewieController(
          videoPlayerController: _videoController,
          autoPlay: true,
          showControls: false,
          looping: true);
    });
  }

  @override
  void initState() {
    getVideoFromCache();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 16 / 9, child: Chewie(controller: _chewieController));
  }
}
