import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/news_data_model.dart';
import '../repository/news_repository.dart';
import '../view/news_data.dart';
import 'vintage_components.dart';

enum filterList { bbcNews, aryNews, alJazeera }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsRepository newsRepository = NewsRepository();
  filterList? selectedItem;
  String name = "bbc-news";
  String _selectedCategory = "Trending";

  final List<String> _categories = ["Trending", "Health", "Sports", "Finance"];
  final PageController _pageController = PageController(viewportFraction: 0.85);

  Future<dynamic> _fetchTopNews() {
    if (_selectedCategory == "Trending") {
      return newsRepository.fetchNews(name);
    } else {
      String cat = _selectedCategory.toLowerCase();
      if (cat == "finance") cat = "business";
      return newsRepository.fetchCategoryNews(cat);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: VintageColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // 1. Premium Custom Header Row (e News logo & Circular Popup Menu)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "e",
                            style: GoogleFonts.outfit(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "News",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1.5),
                      ),
                      child: PopupMenuButton<filterList>(
                        icon: const Icon(
                          Icons.grid_view_rounded,
                          color: Colors.white,
                          size: 20,
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
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<filterList>>[
                              const PopupMenuItem<filterList>(
                                value: filterList.bbcNews,
                                child: Text("BBC News"),
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
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Category Tabs Row
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          cat,
                          style: GoogleFonts.outfit(
                            color: isSelected ? Colors.white : Colors.white38,
                            fontSize: isSelected ? 22 : 16,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // 3. Horizontal Carousel Top Headlines PageView (FutureBuilder)
              SizedBox(
                height: height * 0.52,
                child: FutureBuilder<dynamic>(
                  future: _fetchTopNews(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitFadingCircle(
                          size: 40,
                          color: Colors.white24,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Failed to load dispatches",
                          style: GoogleFonts.outfit(color: Colors.white30),
                        ),
                      );
                    } else {
                      final articles = snapshot.data?.articles ?? [];
                      if (articles.isEmpty) {
                        return Center(
                          child: Text(
                            "No articles found",
                            style: GoogleFonts.outfit(color: Colors.white30),
                          ),
                        );
                      }
                      return PageView.builder(
                        controller: _pageController,
                        itemCount: articles.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final article = articles[index];
                          final publishAtstr = article.publishedAt;
                          String formattedDate = "";
                          if (publishAtstr != null) {
                            try {
                              var publishAt = DateTime.parse(publishAtstr);
                              formattedDate = DateFormat(
                                'yyyy-MM-dd',
                              ).format(publishAt);
                            } catch (_) {}
                          }

                          final cardBg =
                              VintageColors.pastelPalette[index %
                                  VintageColors.pastelPalette.length];

                          return PremiumNewsCard(
                            title: article.title ?? "Untitled Dispatch",
                            description:
                                article.description ??
                                "No summary details supplied.",
                            imageUrl: article.urlToImage ?? "",
                            author: article.author ?? "Unknown Reporter",
                            date: formattedDate,
                            category: article.source?.name ?? "General",
                            backgroundColor: cardBg,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDataScreen(
                                    description: article.description ?? "",
                                    title: article.title ?? "",
                                    source:
                                        article.author ?? "Unknown Reporter",
                                    img: article.urlToImage ?? "",
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),

              // 4. Section Header
              const SectionHeader(title: "Latest Dispatch"),

              // 5. Vertical Latest News List View (FutureBuilder)
              FutureBuilder<newsDataModel>(
                future: newsRepository.fetchNewsData(),
                builder: (context, state) {
                  if (state.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) =>
                          const NewspaperCardSkeleton(),
                    );
                  } else if (state.hasError) {
                    return Center(
                      child: Text(
                        "Error loading latest dispatch items.",
                        style: GoogleFonts.outfit(color: Colors.white30),
                      ),
                    );
                  } else {
                    final articles = state.data?.articles ?? [];
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return NewspaperCard(
                          title: article.title ?? "Untitled",
                          description: article.description ?? "",
                          imageUrl: article.urlToImage ?? "",
                          author: article.author ?? "Unknown",
                          date: article.publishedAt ?? "",
                          category: "News",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsDataScreen(
                                  description: article.description ?? "",
                                  title: article.title ?? "",
                                  source: article.author ?? "Unknown",
                                  img: article.urlToImage ?? "",
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
