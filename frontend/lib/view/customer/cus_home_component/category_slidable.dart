import 'package:flutter/material.dart';
import 'package:foodecommerce/model/category.dart';

class CategorySlider extends StatefulWidget {
  final List<Category> categories;
  final Function(Category)? onCategoryTap;
  final double itemWidth;
  final double itemHeight;

  const CategorySlider({
    super.key,
    required this.categories,
    this.onCategoryTap,
    this.itemWidth = 80,
    this.itemHeight = 100,
  });

  @override
  State<CategorySlider> createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  late ScrollController _scrollController;
  double _scrollProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateScrollProgress);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollProgress);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollProgress() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      
      setState(() {
        _scrollProgress = maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.0, 1.0) : 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categories.isEmpty) {
      return Container(
        height: widget.itemHeight * 2 + 40, // Height for 2 rows + spacing + container padding
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'No categories available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    // Calculate how many items per column (2 rows)
    final int itemsPerColumn = 2;
    final int totalColumns = (widget.categories.length / itemsPerColumn).ceil();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Categories content
          Container(
            height: widget.itemHeight * 2 + 32, // Height for 2 rows + spacing between rows
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: totalColumns,
              itemBuilder: (context, columnIndex) {
                return Container(
                  width: widget.itemWidth + 16, // Item width + spacing
                  margin: const EdgeInsets.only(right: 8),
                  child: Column(
                    children: [
                      // First row item
                      if (columnIndex * itemsPerColumn < widget.categories.length)
                        _buildCategoryItem(
                          widget.categories[columnIndex * itemsPerColumn],
                          context,
                        ),
                      
                      const SizedBox(height: 8), // Spacing between rows
                      
                      // Second row item
                      if (columnIndex * itemsPerColumn + 1 < widget.categories.length)
                        _buildCategoryItem(
                          widget.categories[columnIndex * itemsPerColumn + 1],
                          context,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Progress indicator
          // Replace the progress indicator section with this:
      if (totalColumns > 3) // Only show if there are more items than can fit on screen
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress bar
              Container(
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(1),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _scrollProgress == 0.0 ? 0.3 : _scrollProgress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB39DDB), Color(0xFF9C27B0)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 4),
              
              // Progress text
              Text(
                'Swipe to see more categories',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Category category, BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onCategoryTap?.call(category),
      child: Container(
        width: widget.itemWidth,
        height: widget.itemHeight,
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA), // Lighter background color
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.15),
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category Icon from URL
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  category.categoryIconUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[50],
                      child: Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: const Color(0xFF9C27B0),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[50],
                      child: Icon(
                        Icons.restaurant,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            
            // Category Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                category.categoryName,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}