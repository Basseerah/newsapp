import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/vintage_components.dart';

class NewsDataScreen extends StatefulWidget {
  final String title;
  final String img;
  final String source;
  final String description;

  const NewsDataScreen({
    super.key,
    required this.img,
    required this.title,
    required this.source,
    required this.description,
  });

  @override
  State<NewsDataScreen> createState() => _NewsDataScreenState();
}

class _NewsDataScreenState extends State<NewsDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VintageColors.detailBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black26, width: 1.5),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF111111),
                size: 18,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Headline
                Text(
                  widget.title,
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF111111),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 16),

                // Author Metadata Row
                ArticleMetadata(
                  author: widget.source,
                  date: "1 mins ago",
                  category: "Detail",
                ),
                const SizedBox(height: 20),

                // Headline Summary / Description
                Text(
                  widget.description.isNotEmpty
                      ? widget.description
                      : "No further dispatch description available at this moment.",
                  style: GoogleFonts.outfit(
                    color: Colors.black87,
                    fontSize: 16,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 24),

                // Main Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: widget.img.isNotEmpty && widget.img != "null"
                      ? CachedNetworkImage(
                          imageUrl: widget.img,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const SizedBox(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(color: Colors.black),
                            ),
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/news-2.jpg",
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          "assets/images/news-2.jpg",
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 100), // extra scrolling room for floating buttons
              ],
            ),
          ),

          // Floating overlay action bar in the bottom right corner
          Positioned(
            bottom: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.grey[900],
                          duration: const Duration(seconds: 1),
                          content: Text(
                            "Article Liked",
                            style: GoogleFonts.outfit(color: Colors.white),
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.thumb_up_outlined, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 14),
                  BookmarkButton(
                    title: widget.title,
                    description: widget.description,
                    urlToImage: widget.img,
                    author: widget.source,
                    publishedAt: "now",
                    category: "Saved",
                    isDarkOnLight: false,
                  ),
                  const SizedBox(width: 14),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.grey[900],
                          duration: const Duration(seconds: 1),
                          content: Text(
                            "Link Shared",
                            style: GoogleFonts.outfit(color: Colors.white),
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
