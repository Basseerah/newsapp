import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/news_data_model.dart';
import '../model/top_headlines_news_model.dart';
import '../repository/news_repository.dart';
import '../view/categories_screen.dart';
import '../view/news_data.dart';

enum filterList { bbcNews, aryNews, independent, reuters, cnn, alJazeera }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsRepository newsRepository = NewsRepository();
  filterList? selectedItem;
  String name = "bbc-news";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("News",
            style: GoogleFonts.lato(color: Colors.white, fontSize: 35)),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoriesScreen()));
          },
          child: const Icon(
            Icons.category,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
        actions: [
          PopupMenuButton<filterList>(
            icon: Icon(
              Icons.more_vert_sharp,
              color: Colors.white,
            ),
            onSelected: (filterList item) {
              setState(() {
                if (filterList.bbcNews == item) {
                  name = 'bbc-news';
                }
                if (filterList.aryNews == item) {
                  name = 'ary-news';
                }

                if (filterList.alJazeera == item) {
                  name = 'al-jazeera-english';
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<filterList>>[
              const PopupMenuItem<filterList>(
                child: Text("BBC News"),
                value: filterList.bbcNews,
              ),
              const PopupMenuItem<filterList>(
                value: filterList.aryNews,
                child: Text('Ary News'),
              ),
              const PopupMenuItem<filterList>(
                value: filterList.alJazeera,
                child: Text('Al-Jazeera News'),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
              height: height * .55,
              child: FutureBuilder<TopHeadlinesNewsModel>(
                  future: newsRepository.fetchNews(name),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitFadingCircle(
                          size: 40,
                          color: Colors.cyan,
                        ),
                      );
                    } else {
                      return ListView.builder(
                          //physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data?.articles?.length ?? 0,
                          itemBuilder: (context, index) {
                            var article = snapshot.data!.articles![index];
                            var publishAtstr = article.publishedAt;
                            var publishAt = DateTime.parse(publishAtstr!);
                            var formattedDate =
                                DateFormat('yyyy-MM-dd').format(publishAt);
                            return GestureDetector(
                              onTap: () {
                                var title = snapshot
                                    .data!.articles![index].title
                                    .toString();
                                var img = snapshot
                                    .data!.articles![index].urlToImage
                                    .toString();
                                var source = snapshot
                                    .data!.articles![index].author
                                    .toString();
                                var description = snapshot
                                    .data!.articles![index].description
                                    .toString();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsDataScreen(
                                              description: description,
                                              title: title,
                                              source: source,
                                              img: img,
                                            )));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: height * 0.55,
                                    width: width * .9,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            const SpinKitCubeGrid(
                                          size: 30,
                                          color: Colors.cyan,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: height * .35,
                                    left: width * .1,
                                    child: Container(
                                      height: height * .18,
                                      width: width * .7,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snapshot
                                                  .data!.articles![index].title
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.aladin(
                                                  fontSize: 24,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(snapshot.data!
                                                    .articles![index].author
                                                    .toString()),
                                                Text(formattedDate)
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    }
                  })),
          Container(
            height: height * .3,
            child: FutureBuilder<newsDataModel>(
                future: newsRepository.fetchNewsData(),
                builder: (context, state) {
                  if (state.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitDualRing(
                        size: 20,
                        color: Colors.cyan,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: state.data?.articles?.length ?? 0,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              var title =
                                  state.data!.articles![index].title.toString();
                              var img = state.data!.articles![index].urlToImage
                                  .toString();
                              var source = state.data!.articles![index].author
                                  .toString();
                              var description = state
                                  .data!.articles![index].description
                                  .toString();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsDataScreen(
                                            description: description,
                                            title: title,
                                            source: source,
                                            img: img,
                                          )));
                            },
                            child: Container(
                              height: height * .25,
                              width: width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: height * .2,
                                    width: width * .25,
                                    child: state.data!.articles![index]
                                                .urlToImage.toString !=
                                            null
                                        ? CachedNetworkImage(
                                            imageUrl: state.data!
                                                .articles![index].urlToImage
                                                .toString(),
                                            fit: BoxFit.fill,
                                          )
                                        : const Image(
                                            image:
                                                AssetImage('image/news-2.jpg'),
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                  Container(
                                    height: height * .2,
                                    width: width * .7,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            state.data!.articles![index].title
                                                .toString(),
                                            maxLines: 2,
                                            style: GoogleFonts.laila(
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Text(
                                          state.data!.articles![index].author
                                              .toString(),
                                          style: GoogleFonts.laila(
                                              fontSize: 18,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }),
          )
        ],
      ),
    );
  }
}
