import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bookmark_manager.dart';

// Premium Theme Colors
class VintageColors {
  static const Color background = Color(0xFF111111); // Main deep dark background
  static const Color backgroundDark = Color(0xFF1E1E1E); // Secondary dark surface
  static const Color border = Color(0xFF2C2C2C); // Dark divider/border lines
  static const Color text = Colors.white; // Active white text
  static const Color accent = Color(0xFFFF2525); // Vibrant red for live/accents
  static const Color muted = Color(0xFF8E8E93); // Soft grey text
  static const Color cardBg = Color(0xFFFDF4D4); // Default cream card color

  // Pastel Color Palette for Rotating Cards
  static const List<Color> pastelPalette = [
    Color(0xFFFDF4D4), // Soft Cream
    Color(0xFFFDE7E7), // Soft Pink
    Color(0xFFE7F3FD), // Soft Blue
    Color(0xFFF3E7FD), // Soft Purple
  ];

  // Detail Page Background
  static const Color detailBackground = Color(0xFFFFF9E6);
}

// 1. PaperContainer (Supports custom background color and large rounded corners)
class PaperContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final double borderRadius;
  final bool doubleBorder;

  const PaperContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderRadius = 28,
    this.doubleBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? VintageColors.cardBg,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// 2. CategoryChip (Updated to match premium list styles)
class CategoryChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : VintageColors.backgroundDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Colors.white : VintageColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            color: isActive ? Colors.black : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// 3. BookmarkButton (Styled as a circular action button)
class BookmarkButton extends StatelessWidget {
  final String title;
  final String description;
  final String urlToImage;
  final String author;
  final String publishedAt;
  final String category;
  final bool isDarkOnLight;

  const BookmarkButton({
    super.key,
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.author,
    required this.publishedAt,
    required this.category,
    this.isDarkOnLight = true,
  });

  @override
  Widget build(BuildContext context) {
    final bookmarkManager = BookmarkManager();
    return ValueListenableBuilder<List<BookmarkArticle>>(
      valueListenable: bookmarkManager.bookmarks,
      builder: (context, bookmarkList, child) {
        final isSaved = bookmarkManager.isBookmarked(title);
        final activeColor = isSaved ? VintageColors.accent : (isDarkOnLight ? Colors.black54 : Colors.white70);

        return GestureDetector(
          onTap: () {
            bookmarkManager.toggleBookmark(
              title: title,
              description: description,
              urlToImage: urlToImage,
              author: author,
              publishedAt: publishedAt,
              category: category,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: isSaved ? VintageColors.accent : Colors.grey[900],
                duration: const Duration(seconds: 1),
                content: Text(
                  isSaved ? "Article removed from Saved News" : "Article added to Saved News",
                  style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDarkOnLight ? Colors.black26 : Colors.white30,
                width: 1,
              ),
            ),
            child: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: activeColor,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}

// 4. PremiumNewsCard (Horizontal carousel view component for Phone 1 mockup)
class PremiumNewsCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String author;
  final String date;
  final String category;
  final Color backgroundColor;
  final VoidCallback onTap;

  const PremiumNewsCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.date,
    required this.category,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PaperContainer(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.all(22),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live badge row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: VintageColors.accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "LIVE",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Large Title
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.25,
                color: const Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 6),

            // Updated time indicator
            Text(
              "Updated just now",
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 14),

            // Publisher Row
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blueAccent.shade100,
                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Published by",
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          color: Colors.black45,
                        ),
                      ),
                      Text(
                        author.isNotEmpty && author != "null" ? author : "Anonymous",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF111111),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Follow",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Short description
            Expanded(
              child: Text(
                description.isNotEmpty && description != "null"
                    ? description
                    : "No further dispatch description available at this moment.",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 13.5,
                  height: 1.3,
                  color: Colors.black87,
                ),
              ),
            ),

            // Actions row (Thumbs-up, Bookmark, Share)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _circularAction(Icons.thumb_up_outlined),
                const SizedBox(width: 10),
                BookmarkButton(
                  title: title,
                  description: description,
                  urlToImage: imageUrl,
                  author: author,
                  publishedAt: date,
                  category: category,
                ),
                const SizedBox(width: 10),
                _circularAction(Icons.share_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _circularAction(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black26, width: 1),
      ),
      child: Icon(
        icon,
        color: Colors.black54,
        size: 18,
      ),
    );
  }
}

// 5. NewspaperCard (Fallback wrapper styled like standard news items on Home/Categories)
class NewspaperCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String author;
  final String date;
  final String category;
  final VoidCallback onTap;

  const NewspaperCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.date,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: VintageColors.backgroundDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: VintageColors.border, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 90,
                height: 90,
                child: imageUrl.isNotEmpty && imageUrl != "null"
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: SpinKitFadingCircle(
                            color: Colors.white30,
                            size: 20,
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/news-2.jpg',
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/images/news-2.jpg',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    author.isNotEmpty && author != "null" ? author : "Anonymous",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 6. ArchiveCard (Saved News stacked items mockup screen 2)
class ArchiveCard extends StatelessWidget {
  final BookmarkArticle article;
  final Color backgroundColor;
  final VoidCallback onTap;

  const ArchiveCard({
    super.key,
    required this.article,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PaperContainer(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        borderRadius: 24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Headline
            Text(
              article.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: const Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 6),

            // Description short
            Text(
              article.description.isNotEmpty && article.description != "null"
                  ? article.description
                  : "No details available.",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 7. EditorialButton (Pill Button)
class EditorialButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isFilled;

  const EditorialButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: isFilled ? Colors.white : Colors.transparent,
        side: const BorderSide(color: Colors.white, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.outfit(
          color: isFilled ? Colors.black : Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// 8. CustomPillSearchBar (Premium dark search input matching Saved News top bar)
class CustomPillSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final String hintText;

  const CustomPillSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
    this.hintText = "Search news",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: VintageColors.backgroundDark,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: GoogleFonts.outfit(color: Colors.white, fontSize: 15),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.outfit(color: Colors.white38),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.black45,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }
}

// Fallback search bar class to satisfy any old usage
class VintageSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const VintageSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPillSearchBar(
      controller: controller,
      onChanged: onChanged,
      onClear: onClear,
      hintText: "Search news...",
    );
  }
}

// 9. SectionHeader
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: Colors.white60,
        ),
      ),
    );
  }
}

// 10. ArticleMetadata
class ArticleMetadata extends StatelessWidget {
  final String author;
  final String date;
  final String category;

  const ArticleMetadata({
    super.key,
    required this.author,
    required this.date,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blueAccent.shade100,
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Published by",
                    style: GoogleFonts.outfit(fontSize: 10, color: Colors.black54),
                  ),
                  Text(
                    author.isNotEmpty && author != "null" ? author : "Wade Warren",
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF111111),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Follow",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          "Updated $date",
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: Colors.black54,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

// 11. ReadingProgress
class ReadingProgress extends StatelessWidget {
  final double progress;

  const ReadingProgress({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: progress,
      backgroundColor: Colors.black12,
      valueColor: const AlwaysStoppedAnimation<Color>(VintageColors.accent),
      minHeight: 3,
    );
  }
}

// 12. FloatingDock (Bottom navigation dock layout for screens)
class FloatingDock extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingDock({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 64,
        margin: const EdgeInsets.only(left: 48, right: 48, bottom: 20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.85),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildItem(0, Icons.home_filled),
            _buildItem(1, Icons.search),
            _buildItem(2, Icons.bookmark),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int index, IconData icon) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.black : Colors.white60,
          size: 22,
        ),
      ),
    );
  }
}

// 13. ArchiveGrid
class ArchiveGrid extends StatelessWidget {
  final List<BookmarkArticle> articles;
  final void Function(BookmarkArticle) onCardTap;

  const ArchiveGrid({
    super.key,
    required this.articles,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final cardBg = VintageColors.pastelPalette[index % VintageColors.pastelPalette.length];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ArchiveCard(
            article: articles[index],
            backgroundColor: cardBg,
            onTap: () => onCardTap(articles[index]),
          ),
        );
      },
    );
  }
}

// 14. PulsingSkeleton (Updated for dark theme loader)
class PulsingSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const PulsingSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<PulsingSkeleton> createState() => _PulsingSkeletonState();
}

class _PulsingSkeletonState extends State<PulsingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.15, end: 0.35).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}

// 15. NewspaperCardSkeleton
class NewspaperCardSkeleton extends StatelessWidget {
  const NewspaperCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: VintageColors.backgroundDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const PulsingSkeleton(width: 80, height: 80),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                PulsingSkeleton(width: 60, height: 12),
                SizedBox(height: 8),
                PulsingSkeleton(width: double.infinity, height: 16),
                SizedBox(height: 6),
                PulsingSkeleton(width: 150, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 16. ResponsiveEditorialGrid
class ResponsiveEditorialGrid extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const ResponsiveEditorialGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width > 600) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );
    }
  }
}
