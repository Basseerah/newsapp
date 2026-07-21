import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../repositories/news_repository.dart';
import 'news_data_screen.dart';
import '../widgets/vintage_components.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final NewsRepository _newsRepository = NewsRepository();

  List<dynamic> _allInitialArticles = [];
  List<dynamic> _displayedArticles = [];
  bool _isLoading = true;
  String _currentQuery = "";
  Timer? _debounceTimer;

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
    _loadInitialPool();
    _searchController.addListener(_onSearchInputChanged);
  }

  // Initial load of headlines for quick default display
  Future<void> _loadInitialPool() async {
    setState(() {
      _isLoading = true;
    });
    try {
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

      if (mounted) {
        setState(() {
          _allInitialArticles = combined;
          _displayedArticles = combined;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Handle typing input with debouncing to avoid API spam
  void _onSearchInputChanged() {
    final query = _searchController.text.trim();
    if (query == _currentQuery) return;

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    if (query.isEmpty) {
      setState(() {
        _currentQuery = "";
        _displayedArticles = _allInitialArticles;
        _isLoading = false;
      });
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query);
    });
  }

  // Perform live API search or category query
  Future<void> _performSearch(String query) async {
    if (!mounted) return;
    setState(() {
      _currentQuery = query;
      _isLoading = true;
    });

    try {
      // Fetch live query from API
      final categoryModel = await _newsRepository.fetchCategoryNews(query.toLowerCase());
      List<dynamic> results = categoryModel.articles ?? [];

      // If live API returns articles, use them
      if (results.isNotEmpty) {
        if (mounted) {
          setState(() {
            _displayedArticles = results;
            _isLoading = false;
          });
        }
        return;
      }
    } catch (_) {
      // Fallback to local filter if network error occurs
    }

    // Fallback: local substring search on initial articles pool
    final lowerQuery = query.toLowerCase();
    final fallbackList = _allInitialArticles.where((article) {
      final title = (article.title ?? "").toLowerCase();
      final desc = (article.description ?? "").toLowerCase();
      final author = (article.author ?? "").toLowerCase();

      return title.contains(lowerQuery) ||
          desc.contains(lowerQuery) ||
          author.contains(lowerQuery);
    }).toList();

    if (mounted) {
      setState(() {
        _displayedArticles = fallbackList;
        _isLoading = false;
      });
    }
  }

  // Trigger search immediately when tapping a category chip
  void _onCategoryChipTapped(String filter) {
    _searchController.text = filter;
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: filter.length),
    );
    _performSearch(filter);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchInputChanged);
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
              // Search Input Field
              VintageSearchBar(
                controller: _searchController,
                onChanged: (val) {
                  // Handled by controller listener
                },
                onClear: () {
                  _searchController.clear();
                  setState(() {
                    _currentQuery = "";
                    _displayedArticles = _allInitialArticles;
                  });
                },
              ),
              const SizedBox(height: 8),
              // Interactive Category Filter Chips
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
                      onTap: () => _onCategoryChipTapped(filter),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              // Section Header
              SectionHeader(
                title: _currentQuery.isNotEmpty
                    ? "Results for '$_currentQuery'"
                    : "Top Dispatches",
              ),
              // Results List View
              Expanded(
                child: _isLoading
                    ? ListView.builder(
                        itemCount: 4,
                        itemBuilder: (context, index) => const NewspaperCardSkeleton(),
                      )
                    : _displayedArticles.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 100),
                            physics: const BouncingScrollPhysics(),
                            itemCount: _displayedArticles.length,
                            itemBuilder: (context, index) {
                              final article = _displayedArticles[index];
                              final title = article.title ?? "Untitled Dispatch";
                              final desc = article.description ?? "";
                              final img = article.urlToImage ?? "";
                              final author = article.author ?? "Unknown Reporter";
                              final date = article.publishedAt != null
                                  ? article.publishedAt!.split('T')[0]
                                  : "Today";
                              return NewspaperCard(
                                title: title,
                                description: desc,
                                imageUrl: img,
                                author: author,
                                date: date,
                                category: _currentQuery.isNotEmpty
                                    ? _currentQuery.toUpperCase()
                                    : "General",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDataScreen(
                                        title: title,
                                        img: img,
                                        source: author,
                                        description: desc.isNotEmpty
                                            ? desc
                                            : "No details available for this dispatch.",
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
                "No dispatches match '${_currentQuery}'. Check query spelling or select a category tag above.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              EditorialButton(
                label: "Clear Search",
                isFilled: true,
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _currentQuery = "";
                    _displayedArticles = _allInitialArticles;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

