import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/category_news_model.dart';
import '../../repositories/news_repository.dart';
import 'news_data_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String name="general";
  NewsRepository newsRepository= NewsRepository();
  @override
  Widget build(BuildContext context) {
    final height =MediaQuery.sizeOf(context).height*1;
    final width =MediaQuery.sizeOf(context).width*1;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            height: height*.06,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: false,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      name="general";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.cyan)),
                  child: Text(
                    "general",
                    style: GoogleFonts.badScript(color: Colors.white,
                    fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      name="business";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.cyan)),
                  child: Text(
                    "business",
                    style: GoogleFonts.badScript(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      name="entertainment";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.cyan)),
                  child: Text(
                    "entertainment",
                    style: GoogleFonts.badScript(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    setState(() {
                      name="health";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.cyan)),
                  child: Text(
                    "health",
                    style: GoogleFonts.badScript(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      name="science";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.cyan)),
                  child: Text(
                    "science",
                    style: GoogleFonts.badScript(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      name="sports";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.cyan)),
                  child: Text(
                    "sports",
                    style: GoogleFonts.badScript(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      name="technology";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.cyan)),
                  child: Text(
                    "technology",
                    style: GoogleFonts.badScript(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder<CategoryNewsModel>(
              future: newsRepository.fetchCategoryNews(name),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitDoubleBounce(
                      color: Colors.cyan,
                      size: 50,
                    ),
                  );
                } else if (snapshot.hasError || snapshot.data?.articles == null) {
                  return Center(
                    child: Text(
                      "Failed to load dispatches",
                      style: GoogleFonts.outfit(color: Colors.white30),
                    ),
                  );
                } else {
                  final articles = snapshot.data!.articles!;
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: articles.length,
                    itemBuilder: (BuildContext context, index) {
                      final article = articles[index];
                      final title = article.title ?? "Untitled";
                      final img = article.urlToImage ?? "";
                      final source = article.author ?? "Unknown";
                      final description = article.description ?? "";

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDataScreen(
                                  description: description,
                                  title: title,
                                  source: source,
                                  img: img,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: Container(
                              height: height * 0.1,
                              width: width * 0.2,
                              child: CachedNetworkImage(
                                imageUrl: img,
                                placeholder: (context, value) {
                                  return const SpinKitFoldingCube(
                                    color: Colors.cyan,
                                  );
                                },
                                errorWidget: (context, value, error) {
                                  return const Icon(
                                    Icons.newspaper,
                                    color: Colors.redAccent,
                                  );
                                },
                              ),
                            ),
                            title: Text(title),
                            subtitle: Text(source),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
