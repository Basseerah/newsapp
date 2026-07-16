import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bookmark_manager.dart';

// Color Palette Constants
class VintageColors {
  static const Color background = Color(0xFFF8F3EA);
  static const Color backgroundDark = Color(0xFFEEE7D9);
  static const Color cardBg = Color(0xFFFCFAF5);
  static const Color border = Color(0xFFD4C4AA);
  static const Color text = Color(0xFF3A2B20);
  static const Color accent = Color(0xFFA5652A);
  static const Color muted = Color(0xFF8E7D67);
}

// 1. PaperContainer
class PaperContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final bool doubleBorder;

  const PaperContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.doubleBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: doubleBorder ? const EdgeInsets.all(3) : padding,
      decoration: BoxDecoration(
        color: VintageColors.cardBg,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: VintageColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: VintageColors.text.withOpacity(0.04),
            blurRadius: 3,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: doubleBorder
          ? Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: VintageColors.border.withOpacity(0.5), width: 1),
              ),
              child: child,
            )
          : child,
    );
  }
}

// 2. CategoryChip
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
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? VintageColors.accent : VintageColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? VintageColors.accent : VintageColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.libreBaskerville(
            color: isActive ? VintageColors.cardBg : VintageColors.text,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

// 3. BookmarkButton
class BookmarkButton extends StatelessWidget {
  final String title;
  final String description;
  final String urlToImage;
  final String author;
  final String publishedAt;
  final String category;

  const BookmarkButton({
    super.key,
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.author,
    required this.publishedAt,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final bookmarkManager = BookmarkManager();
    return ValueListenableBuilder<List<BookmarkArticle>>(
      valueListenable: bookmarkManager.bookmarks,
      builder: (context, bookmarkList, child) {
        final isSaved = bookmarkManager.isBookmarked(title);
        return IconButton(
          icon: Icon(
            isSaved ? Icons.bookmark : Icons.bookmark_border,
            color: VintageColors.accent,
          ),
          onPressed: () {
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
                backgroundColor: VintageColors.text,
                duration: const Duration(seconds: 1),
                content: Text(
                  isSaved ? "Edition removed from Archives" : "Edition preserved in Archives",
                  style: GoogleFonts.ebGaramond(color: VintageColors.background),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// 4. NewspaperCard
class NewspaperCard extends StatefulWidget {
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
  State<NewspaperCard> createState() => _NewspaperCardState();
}

class _NewspaperCardState extends State<NewspaperCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered
            ? (Matrix4.identity()..translate(0, -4, 0))
            : Matrix4.identity(),
        child: GestureDetector(
          onTap: widget.onTap,
          child: PaperContainer(
            doubleBorder: true,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.all(12),
            height: 440, // Consistent height avoids uneven card sizes
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Image at the top (with AspectRatio and BoxFit.contain to prevent stretching/cropping)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: VintageColors.backgroundDark.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: VintageColors.border, width: 1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: AspectRatio(
                      aspectRatio: 1.6,
                      child: widget.imageUrl.isNotEmpty && widget.imageUrl != "null"
                          ? CachedNetworkImage(
                              imageUrl: widget.imageUrl,
                              fit: BoxFit.contain,
                              placeholder: (context, url) => const Center(
                                child: SpinKitFadingCircle(
                                  color: VintageColors.accent,
                                  size: 30,
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                'image/news-2.jpg',
                                fit: BoxFit.contain,
                              ),
                            )
                          : Image.asset(
                              'image/news-2.jpg',
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // 2. Category badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: VintageColors.accent, width: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    widget.category.toUpperCase(),
                    style: GoogleFonts.libreBaskerville(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: VintageColors.accent,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 3. Large serif headline
                Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.15,
                    color: VintageColors.text,
                  ),
                ),
                const Divider(color: VintageColors.border, thickness: 0.5, height: 16),

                // 4. Short description
                Text(
                  widget.description.isNotEmpty && widget.description != "null"
                      ? widget.description
                      : "No description available for this dispatch.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.ebGaramond(
                    fontSize: 13,
                    height: 1.25,
                    color: VintageColors.text.withOpacity(0.85),
                  ),
                ),
                const Spacer(),

                // 5. Source and publication date, and 6. Bookmark button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.author.isNotEmpty && widget.author != "null"
                                ? "By ${widget.author}"
                                : "By Anonymous Correspondent",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: VintageColors.muted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.date,
                            style: GoogleFonts.ebGaramond(
                              fontSize: 11,
                              color: VintageColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    BookmarkButton(
                      title: widget.title,
                      description: widget.description,
                      urlToImage: widget.imageUrl,
                      author: widget.author,
                      publishedAt: widget.date,
                      category: widget.category,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 5. ArchiveCard
class ArchiveCard extends StatelessWidget {
  final BookmarkArticle article;
  final VoidCallback onTap;

  const ArchiveCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: PaperContainer(
        doubleBorder: false,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    article.category.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.libreBaskerville(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: VintageColors.accent,
                    ),
                  ),
                ),
                BookmarkButton(
                  title: article.title,
                  description: article.description,
                  urlToImage: article.urlToImage,
                  author: article.author,
                  publishedAt: article.publishedAt,
                  category: article.category,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Expanded(
              child: Text(
                article.title,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  height: 1.15,
                  color: VintageColors.text,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              article.publishedAt,
              style: GoogleFonts.ebGaramond(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: VintageColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 6. EditorialButton
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
        backgroundColor: isFilled ? VintageColors.accent : Colors.transparent,
        side: const BorderSide(color: VintageColors.accent, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.libreBaskerville(
          color: isFilled ? VintageColors.cardBg : VintageColors.accent,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

// 7. VintageSearchBar
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
    return Container(
      decoration: BoxDecoration(
        color: VintageColors.cardBg,
        border: Border.all(color: VintageColors.border, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.ebGaramond(color: VintageColors.text, fontSize: 16),
        decoration: InputDecoration(
          hintText: "Search historical dispatches...",
          hintStyle: GoogleFonts.ebGaramond(color: VintageColors.muted, fontStyle: FontStyle.italic),
          prefixIcon: const Icon(Icons.search, color: VintageColors.muted),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: VintageColors.muted),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}

// 8. SectionHeader
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        children: [
          const Expanded(child: Divider(color: VintageColors.border, thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title.toUpperCase(),
              style: GoogleFonts.cormorantGaramond(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: VintageColors.accent,
              ),
            ),
          ),
          const Expanded(child: Divider(color: VintageColors.border, thickness: 1)),
        ],
      ),
    );
  }
}

// 9. ArticleMetadata
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: VintageColors.border, width: 1),
          bottom: BorderSide(color: VintageColors.border, width: 1),
        ),
      ),
      child: Column(
        children: [
          Text(
            "DISPATCH BY PROMINENT CORRESPONDENT: $author",
            textAlign: TextAlign.center,
            style: GoogleFonts.libreBaskerville(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: VintageColors.text,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "EDITION: ${category.toUpperCase()}",
                style: GoogleFonts.libreBaskerville(
                  fontSize: 9,
                  color: VintageColors.accent,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "•",
                style: TextStyle(color: VintageColors.border),
              ),
              const SizedBox(width: 12),
              Text(
                "DATE: $date",
                style: GoogleFonts.libreBaskerville(
                  fontSize: 9,
                  color: VintageColors.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 10. ReadingProgress
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
      backgroundColor: VintageColors.border.withOpacity(0.3),
      valueColor: const AlwaysStoppedAnimation<Color>(VintageColors.accent),
      minHeight: 3,
    );
  }
}

// 11. ArchiveGrid
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
    final width = MediaQuery.sizeOf(context).width;
    // Desktop/tablet gets 2 columns, mobile gets 2 columns too but smaller height, or 1 column if extremely narrow
    final crossAxisCount = width > 600 ? 3 : 2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.85,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return ArchiveCard(
          article: articles[index],
          onTap: () => onCardTap(articles[index]),
        );
      },
    );
  }
}

// 12. EditorialTabs
class EditorialTabs extends StatelessWidget {
  final List<String> tabs;
  final String activeTab;
  final ValueChanged<String> onTabChanged;

  const EditorialTabs({
    super.key,
    required this.tabs,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: VintageColors.border, width: 1),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isActive = tab.toLowerCase() == activeTab.toLowerCase();
          return GestureDetector(
            onTap: () => onTabChanged(tab),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? VintageColors.accent : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                tab.toUpperCase(),
                style: GoogleFonts.libreBaskerville(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? VintageColors.accent : VintageColors.text,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 13. PulsingSkeleton
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
    _animation = Tween<double>(begin: 0.25, end: 0.65).animate(_controller);
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
              color: VintageColors.border,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(4),
            ),
          ),
        );
      },
    );
  }
}

// 14. NewspaperCardSkeleton
class NewspaperCardSkeleton extends StatelessWidget {
  const NewspaperCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return PaperContainer(
      doubleBorder: true,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              PulsingSkeleton(width: 80, height: 14),
              PulsingSkeleton(width: 24, height: 24),
            ],
          ),
          const SizedBox(height: 8),
          const PulsingSkeleton(width: double.infinity, height: 180),
          const SizedBox(height: 10),
          const PulsingSkeleton(width: double.infinity, height: 20),
          const SizedBox(height: 6),
          const PulsingSkeleton(width: 180, height: 20),
          const Divider(color: VintageColors.border, thickness: 0.5, height: 16),
          const PulsingSkeleton(width: double.infinity, height: 14),
          const SizedBox(height: 6),
          const PulsingSkeleton(width: 250, height: 14),
          const SizedBox(height: 10),
          const PulsingSkeleton(width: 120, height: 12),
        ],
      ),
    );
  }
}

// 15. ResponsiveEditorialGrid
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

    if (width > 900) {
      // Desktop / Web: 3 columns
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );
    } else if (width > 600) {
      // Tablet: 2 columns
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.72,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );
    } else {
      // Mobile: 1 column list
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );
    }
  }
}


