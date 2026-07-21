import 'package:flutter/material.dart';

class BookmarkArticle {
  final String title;
  final String description;
  final String urlToImage;
  final String author;
  final String publishedAt;
  final String category;

  BookmarkArticle({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.author,
    required this.publishedAt,
    required this.category,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkArticle &&
          runtimeType == other.runtimeType &&
          title == other.title;

  @override
  int get hashCode => title.hashCode;
}

class BookmarkManager {
  static final BookmarkManager _instance = BookmarkManager._internal();
  factory BookmarkManager() => _instance;
  BookmarkManager._internal();

  final ValueNotifier<List<BookmarkArticle>> bookmarks = ValueNotifier<List<BookmarkArticle>>([]);

  void toggleBookmark({
    required String title,
    required String description,
    required String urlToImage,
    required String author,
    required String publishedAt,
    required String category,
  }) {
    final list = List<BookmarkArticle>.from(bookmarks.value);
    final exists = list.any((item) => item.title == title);
    if (exists) {
      list.removeWhere((item) => item.title == title);
    } else {
      list.add(BookmarkArticle(
        title: title,
        description: description,
        urlToImage: urlToImage,
        author: author,
        publishedAt: publishedAt,
        category: category,
      ));
    }
    bookmarks.value = list;
  }

  bool isBookmarked(String title) {
    return bookmarks.value.any((item) => item.title == title);
  }
}
