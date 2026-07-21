import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bookmark_manager.dart';
import 'news_data_screen.dart';
import '../widgets/vintage_components.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _sortBy = "Newest"; // Newest, Oldest, Category, Author
  String _selectedCategoryFilter = "All";

  // Pre-populated default historical articles to avoid blank screen
  final List<BookmarkArticle> _historicalCollection = [
    BookmarkArticle(
      title: "The Great Strike of London Ends in Historic Agreement",
      description: "After weeks of negotiations, union leaders and transit authorities reach an accord. Streetcars and underground rails resume operations under new wage scales.",
      urlToImage: "",
      author: "Arthur Pendelton",
      publishedAt: "1926-05-12",
      category: "History",
    ),
    BookmarkArticle(
      title: "Archaeologists Unearth Secret Chambers in Giza Plateau",
      description: "Expeditions led by the British Museum discover previously undocumented chambers containing gilded relics and hieroglyphic scrolls dating back to the Old Kingdom.",
      urlToImage: "",
      author: "Dr. Evelyn Carnahan",
      publishedAt: "1925-11-04",
      category: "History",
    ),
    BookmarkArticle(
      title: "Steamship Majestic Claims Blue Riband on Transatlantic Crossing",
      description: "The white star liner docks in New York Harbor, shattering the previous speed record by clocking a crossing of just four days and twelve hours.",
      urlToImage: "",
      author: "H. G. Wells",
      publishedAt: "1926-07-02",
      category: "World",
    ),
  ];

  final List<BookmarkArticle> _editorsPicks = [
    BookmarkArticle(
      title: "Editorial: The Shifting Currents of Modern Science",
      description: "An inquiry into the revolutionary theories of relativity and quantum mechanics that are reshaping our understanding of the universe.",
      urlToImage: "",
      author: "Editorial Board",
      publishedAt: "1926-06-15",
      category: "Editorial",
    ),
    BookmarkArticle(
      title: "A Survey of the London Theatre: The Rise of the New Dramatists",
      description: "An analytical review of the winter season at West End, exploring the themes of realism and satire in contemporary British plays.",
      urlToImage: "",
      author: "George Bernard Shaw",
      publishedAt: "1926-02-28",
      category: "Culture",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BookmarkArticle> _processList(List<BookmarkArticle> rawList) {
    // 1. Filter by Search Query
    var list = rawList.where((item) {
      final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.author.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategoryFilter == "All" ||
          item.category.toLowerCase() == _selectedCategoryFilter.toLowerCase();
      return matchesSearch && matchesCategory;
    }).toList();

    // 2. Sort
    if (_sortBy == "Newest") {
      list.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    } else if (_sortBy == "Oldest") {
      list.sort((a, b) => a.publishedAt.compareTo(b.publishedAt));
    } else if (_sortBy == "Category") {
      list.sort((a, b) => a.category.compareTo(b.category));
    } else if (_sortBy == "Author") {
      list.sort((a, b) => a.author.compareTo(b.author));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkManager = BookmarkManager();

    return Scaffold(
      backgroundColor: VintageColors.background,
      body: SafeArea(
        child: ValueListenableBuilder<List<BookmarkArticle>>(
          valueListenable: bookmarkManager.bookmarks,
          builder: (context, userBookmarks, child) {
            // Get all unique categories for filter
            final allCategories = {"All"};
            for (var item in userBookmarks) {
              allCategories.add(item.category);
            }
            for (var item in _historicalCollection) {
              allCategories.add(item.category);
            }
            for (var item in _editorsPicks) {
              allCategories.add(item.category);
            }

            final processedSaved = _processList(userBookmarks);
            final processedHistorical = _processList(_historicalCollection);
            final processedPicks = _processList(_editorsPicks);

            // Combine list to show overlapping cards in a single stacked scroll list
            final List<BookmarkArticle> combinedList = [];
            combinedList.addAll(processedSaved);
            combinedList.addAll(processedHistorical);
            combinedList.addAll(processedPicks);

            return SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // 1. Saved News Header with a back button and center title
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Standard action for back: pop or go back to main screen index
                          Navigator.maybePop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: VintageColors.backgroundDark,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Saved News",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 36), // Balanced alignment spacing
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 2. Custom Pill Search Bar
                  CustomPillSearchBar(
                    controller: _searchController,
                    hintText: "Search news",
                  ),
                  const SizedBox(height: 12),

                  // 3. Sorting & Filtering Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Sort: ",
                            style: GoogleFonts.outfit(fontSize: 12, color: Colors.white54),
                          ),
                          DropdownButton<String>(
                            value: _sortBy,
                            dropdownColor: VintageColors.backgroundDark,
                            iconEnabledColor: Colors.white70,
                            underline: Container(height: 1, color: Colors.white24),
                            style: GoogleFonts.outfit(fontSize: 13, color: Colors.white),
                            items: ["Newest", "Oldest", "Category", "Author"].map((sortOpt) {
                              return DropdownMenuItem<String>(
                                value: sortOpt,
                                child: Text(sortOpt),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _sortBy = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Category: ",
                            style: GoogleFonts.outfit(fontSize: 12, color: Colors.white54),
                          ),
                          DropdownButton<String>(
                            value: _selectedCategoryFilter,
                            dropdownColor: VintageColors.backgroundDark,
                            iconEnabledColor: Colors.white70,
                            underline: Container(height: 1, color: Colors.white24),
                            style: GoogleFonts.outfit(fontSize: 13, color: Colors.white),
                            items: allCategories.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat,
                                child: Text(cat),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedCategoryFilter = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 4. Overlapping stacked pastel cards
                  if (combinedList.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: combinedList.length,
                      itemBuilder: (context, index) {
                        final article = combinedList[index];
                        final cardBg = VintageColors.pastelPalette[index % VintageColors.pastelPalette.length];
                        final isLast = index == combinedList.length - 1;

                        // Align with heightFactor creates the stacked overlapping cards effect
                        return Align(
                          heightFactor: isLast ? 1.0 : 0.7,
                          alignment: Alignment.topCenter,
                          child: ArchiveCard(
                            article: article,
                            backgroundColor: cardBg,
                            onTap: () => _navigateToDetail(context, article),
                          ),
                        );
                      },
                    )
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: Column(
                          children: [
                            const Icon(Icons.bookmark_outline, size: 60, color: Colors.white24),
                            const SizedBox(height: 16),
                            Text(
                              "No saved news found",
                              style: GoogleFonts.outfit(color: Colors.white38, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, BookmarkArticle article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDataScreen(
          title: article.title,
          img: article.urlToImage,
          source: article.author,
          description: article.description,
        ),
      ),
    );
  }
}
