import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/ui/view/mapView.dart';
import 'package:client/utils/net/model/article.dart';
import 'package:client/utils/net/requester.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with AutomaticKeepAliveClientMixin {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();

    // var formattedDate = DateFormat('EEE, d MMM').format(now);
    // var timezoneString = now.timeZoneOffset.toString().split('.').first;
    // var offsetSign = '';
    // if (!timezoneString.startsWith('-')) offsetSign = '+';

    return Center(
      child: FutureBuilder(
        future: getArticleByPos("37.123", "127.123"),
        builder: (context, snapshot) {
          List<Article>? data = snapshot.data as List<Article>?;
          if (snapshot.hasData == false) {
            return const CircularProgressIndicator(); // CircularProgressIndicator : 로딩 에니메이션
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // 에러명을 텍스트에 뿌려줌
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data?.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      DateTime time = DateTime.parse(data![index].date!);
                      String timeParsed =
                          "${time.year}년 ${time.month}월 ${time.day}일";

                      return Container(
                        color: Colors.black,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => MyMapView(
                                  url:
                                      "https://www.google.com/maps/search/${data[index].latitude!},${data[index].longitude!}",
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("작성자: ${data[index].email!}"),
                                    ],
                                  ),
                                  CachedNetworkImage(
                                    imageUrl: getImageUrl(
                                      data[index]
                                          .images!
                                          .split(' ')[0]
                                          .trim()
                                          .replaceAll("[", "")
                                          .replaceAll("]", ""),
                                    ),
                                  ),
                                  Text(data[index].body!),
                                  Text("작성일: $timeParsed"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
