import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../repository/news_repository.dart';
import 'news_data.dart';
import 'vintage_components.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final NewsRepository _newsRepository = NewsRepository();

  List<dynamic> _allArticles = [];
  List<dynamic> _filteredArticles = [];
  bool _isLoading = true;
  String _currentQuery = "";

  final List<String> _filters = [
    "London",
    "World",
    "Business",
    "Culture",
    "Politics",
    "Science",
    "Technology",
    "Sports",
    "History",
    "Opinion"
  ];

  @override
  void initState() {
    super.initState();
    _loadSearchPool();
    _searchController.addListener(_onSearchTextChanged);
  }

  void _loadSearchPool() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Load top headlines from standard sources and general news in parallel
      final results = await Future.wait([
        _newsRepository.fetchNewsData(),
        _newsRepository.fetchNews("bbc-news"),
        _newsRepository.fetchNews("al-jazeera-english"),
      ]);

      final Set<String> uniqueTitles = {};
      final List<dynamic> combined = [];

      for (dynamic model in results) {
        if (model.articles != null) {
          for (var article in model.articles!) {
            final title = article.title;
            if (title != null && title.isNotEmpty && uniqueTitles.add(title)) {
              combined.add(article);
            }
          }
        }
      }

      setState(() {
        _allArticles = combined;
        _filteredArticles = combined;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchTextChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _currentQuery = "";
        _filteredArticles = _allArticles;
      });
      return;
    }

    final lowerQuery = query.toLowerCase();
    setState(() {
      _currentQuery = query;
      _filteredArticles = _allArticles.where((article) {
        final title = (article.title ?? "").toLowerCase();
        final desc = (article.description ?? "").toLowerCase();
        final content = (article.content ?? "").toLowerCase();
        final sourceName = (article.source?.name ?? "").toLowerCase();
        final author = (article.author ?? "").toLowerCase();

        return title.contains(lowerQuery) ||
            desc.contains(lowerQuery) ||
            content.contains(lowerQuery) ||
            sourceName.contains(lowerQuery) ||
            author.contains(lowerQuery);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VintageColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Search Bar
              VintageSearchBar(
                controller: _searchController,
                onChanged: (val) {
                  // Listeners handle updates in real time
                },
                onClear: () {
                  _searchController.clear();
                },
              ),
              const SizedBox(height: 8),
              // Filter Chips
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isActive = _currentQuery.toLowerCase() == filter.toLowerCase();
                    return CategoryChip(
                      label: filter,
                      isActive: isActive,
                      onTap: () {
                        _searchController.text = filter;
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              const SectionHeader(title: "Search Results"),
              // Results List
              Expanded(
                child: _isLoading
                    ? ListView.builder(
                        itemCount: 4,
                        itemBuilder: (context, index) => const NewspaperCardSkeleton(),
                      )
                    : _filteredArticles.isEmpty
                        ? _buildEmptyState()
                        : ResponsiveEditorialGrid(
                            itemCount: _filteredArticles.length,
                            itemBuilder: (context, index) {
                              final article = _filteredArticles[index];
                              final title = article.title ?? "Untitled";
                              final desc = article.description ?? "";
                              final img = article.urlToImage ?? "";
                              final author = article.author ?? "Unknown Reporter";
                              final date = article.publishedAt != null
                                  ? article.publishedAt!.split('T')[0]
                                  : "1926-07-15";
                              return NewspaperCard(
                                title: title,
                                description: desc,
                                imageUrl: img,
                                author: author,
                                date: date,
                                category: "Search Result",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDataScreen(
                                        title: title,
                                        img: img,
                                        source: author,
                                        description: desc.isNotEmpty ? desc : "No details available.",
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: PaperContainer(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          doubleBorder: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.find_in_page_outlined,
                size: 64,
                color: VintageColors.accent.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                "No articles found.",
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "No dispatches match the entered keyword. Verify query spelling or adjust the category filters.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              EditorialButton(
                label: "Clear Search Query",
                isFilled: true,
                onPressed: () {
                  _searchController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
