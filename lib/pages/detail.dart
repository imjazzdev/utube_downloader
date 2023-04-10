import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:utube_downloader/models/detail_shimmer.dart';
import 'package:utube_downloader/utils/var_global.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../utils/ads_manager.dart';

class DetailPage extends StatefulWidget {
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final txtCon = TextEditingController();
  String videoTitle = '';
  String videoPublishDate = '';
  String videoId = '';
  String thumbnail = '';
  String author = '';
  int viewCount = 0;
  int? likeCount = 0;
  bool _downloading = false;
  double isProgress = 2;

  @override
  void initState() {
    UnityAds.init(
      gameId: AdsManager.appid,
    );
    UnityAds.load(placementId: AdsManager.interAdPlacementId);
    print(VarGlobal.linkUrl.text);
    txtCon == VarGlobal.linkUrl;
    setState(() {
      getVideoInfo(VarGlobal.linkUrl.text);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        viewCount == 0
            ? DetailShimmer()
            : Stack(
                children: [
                  Expanded(
                      flex: 2,
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                          color: Colors.red,
                          strokeWidth: 5,
                        )),
                        imageUrl: thumbnail,
                        height: MediaQuery.of(context).size.height * 0.65,
                        fit: BoxFit.cover,
                      )),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              videoTitle,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900),
                            ),
                          ),
                          Divider(color: Colors.grey.shade600),
                          Expanded(
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/img/play.png',
                                  height: 40,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(author,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/img/view.png',
                                  height: 40,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  NumberFormat.compact()
                                          .format(viewCount.abs()) +
                                      ' views',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/img/heart.png',
                                  height: 40,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  NumberFormat.compact()
                                          .format(likeCount!.abs()) +
                                      ' likes',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(10),
                                    shadowColor: MaterialStateProperty.all(
                                        Colors.red.shade300),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                  ),
                                  onPressed: () {
                                    UnityAds.showVideoAd(
                                      placementId:
                                          AdsManager.interAdPlacementId,
                                      onComplete: (placementId) =>
                                          print("berhasil menampilkan iklan"),
                                    );
                                    downloadVideo(videoId);
                                  },
                                  child: Text('DOWNLOAD')),
                            ),
                          ),
                          _downloading
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: LinearProgressIndicator(
                                    value: isProgress,
                                    backgroundColor: Colors.red.shade100,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.red),
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Container(
              padding: EdgeInsets.only(left: 13, right: 10),
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.shade300.withOpacity(0.7)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Paste link',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontStyle: FontStyle.italic)),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(38),
                      ],
                      controller: VarGlobal.linkUrl,
                      // onSubmitted: (value) {
                      //   getVideoInfo(value);
                      // },
                      onChanged: (value) {
                        getVideoInfo(value);
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        VarGlobal.linkUrl.clear();
                        VarGlobal.linkUrl.dispose();
                      },
                      icon: Icon(
                        Icons.cancel_rounded,
                        color: Colors.white,
                        size: 28,
                      ))
                ],
              ),
            ),
          ),
        )
      ],
    ));
  }

  Future<void> getVideoInfo(url) async {
    var ytInfo = YoutubeExplode();
    var video = await ytInfo.videos.get(url);
    setState(() {
      videoTitle = video.title;
      videoPublishDate = video.publishDate.toString();
      videoId = video.id.toString();
      thumbnail = video.thumbnails.highResUrl;
      viewCount = video.engagement.viewCount;
      likeCount = video.engagement.likeCount;
      author = video.author;
    });
  }

  Future<void> downloadVideo(id) async {
    var permission = await Permission.storage.request();
    if (permission.isGranted) {
      if (txtCon != '') {
        _downloading = true;
        setState(() {
          isProgress = 0;
        });
        var dateTime = DateTime.now();
        var ytExplode = YoutubeExplode();
        var video = await ytExplode.videos.get(id);
        var manifest = await ytExplode.videos.streamsClient.getManifest(id);
        var streams = manifest.muxed.withHighestBitrate();
        var audio = streams;
        var audioStreams = ytExplode.videos.streamsClient.get(audio);
        Directory? appDocdir = await getExternalStorageDirectory();
        String appDocPath = appDocdir!.path;
        var file = File('$appDocPath/${dateTime}.mp4');

        if (file.existsSync()) {
          file.deleteSync();
        }
        var output = file.openWrite(mode: FileMode.writeOnlyAppend);
        var size = audio.size.totalBytes;
        var count = 0;

        await for (final data in audioStreams) {
          count += data.length;
          double val = ((count / size));

          var msg = '$appDocPath/${dateTime}';
          for (val; val == 1.0; val++) {
            alertDownload(msg);
          }
          setState(() {
            isProgress = val;
          });
          output.add(data);
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('add video url first')));
        setState(() {
          _downloading = false;
        });
      }
    } else {
      await Permission.storage.request();
    }
  }

  alertDownload(msg) {
    AlertDialog alert = AlertDialog(
      title: Text(
        "Video saved to",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      actions: [
        OutlinedButton(
            style: OutlinedButton.styleFrom(
                primary: Colors.red,
                side: BorderSide(color: Colors.red.shade50, width: 1.5)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.w900),
            ))
      ],
    );

    showDialog(context: context, builder: (context) => alert);
    return;
  }
}
