import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bookmark_manager.dart';
import 'news_data.dart';
import 'vintage_components.dart';

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

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Header
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "THE ARCHIVES",
                          style: GoogleFonts.oldStandardTt(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: VintageColors.text,
                          ),
                        ),
                        Text(
                          "PRESERVED EDITIONS & DISPATCHES",
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 10,
                            letterSpacing: 1.5,
                            color: VintageColors.accent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 80,
                          height: 2,
                          color: VintageColors.accent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Archive Search & Sort Controls
                  VintageSearchBar(
                    controller: _searchController,
                    onClear: () {
                      _searchController.clear();
                    },
                  ),
                  const SizedBox(height: 10),

                  // Sort & Filter Controls Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Sort dropdown
                      Row(
                        children: [
                          Text(
                            "Sort: ",
                            style: GoogleFonts.libreBaskerville(fontSize: 11, color: VintageColors.muted),
                          ),
                          DropdownButton<String>(
                            value: _sortBy,
                            dropdownColor: VintageColors.cardBg,
                            iconEnabledColor: VintageColors.accent,
                            underline: Container(height: 1, color: VintageColors.border),
                            style: GoogleFonts.ebGaramond(fontSize: 13, color: VintageColors.text),
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
                      // Filter dropdown
                      Row(
                        children: [
                          Text(
                            "Category: ",
                            style: GoogleFonts.libreBaskerville(fontSize: 11, color: VintageColors.muted),
                          ),
                          DropdownButton<String>(
                            value: _selectedCategoryFilter,
                            dropdownColor: VintageColors.cardBg,
                            iconEnabledColor: VintageColors.accent,
                            underline: Container(height: 1, color: VintageColors.border),
                            style: GoogleFonts.ebGaramond(fontSize: 13, color: VintageColors.text),
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
                  const SizedBox(height: 10),

                  // Section 1: Recently Saved (User bookmarks)
                  if (processedSaved.isNotEmpty) ...[
                    const SectionHeader(title: "Recently Saved"),
                    ArchiveGrid(
                      articles: processedSaved,
                      onCardTap: (article) => _navigateToDetail(context, article),
                    ),
                  ] else if (_searchQuery.isEmpty && _selectedCategoryFilter == "All") ...[
                    const SectionHeader(title: "Recently Saved"),
                    PaperContainer(
                      padding: const EdgeInsets.all(16),
                      doubleBorder: true,
                      child: Center(
                        child: Text(
                          "No dispatches saved in current session. Bookmark articles from the Front page or Details screen.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ebGaramond(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: VintageColors.muted,
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Section 2: Today's Dispatch
                  if (processedSaved.isNotEmpty) ...[
                    const SectionHeader(title: "Today's Dispatch"),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: processedSaved.length > 2 ? 2 : processedSaved.length,
                      itemBuilder: (context, index) {
                        final article = processedSaved[index];
                        return NewspaperCard(
                          title: article.title,
                          description: article.description,
                          imageUrl: article.urlToImage,
                          author: article.author,
                          date: article.publishedAt,
                          category: article.category,
                          onTap: () => _navigateToDetail(context, article),
                        );
                      },
                    ),
                  ],

                  // Section 3: Historical Collection (Always visible, filtered)
                  if (processedHistorical.isNotEmpty) ...[
                    const SectionHeader(title: "Historical Collection"),
                    ArchiveGrid(
                      articles: processedHistorical,
                      onCardTap: (article) => _navigateToDetail(context, article),
                    ),
                  ],

                  // Section 4: Editor's Picks
                  if (processedPicks.isNotEmpty) ...[
                    const SectionHeader(title: "Editor's Picks"),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: processedPicks.length,
                      itemBuilder: (context, index) {
                        final article = processedPicks[index];
                        return NewspaperCard(
                          title: article.title,
                          description: article.description,
                          imageUrl: article.urlToImage,
                          author: article.author,
                          date: article.publishedAt,
                          category: article.category,
                          onTap: () => _navigateToDetail(context, article),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 20),
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
