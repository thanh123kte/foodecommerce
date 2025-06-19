import 'package:flutter/material.dart';
import 'package:foodecommerce/controller/seller_controller.dart';
import 'package:foodecommerce/model/seller.dart';
import 'package:provider/provider.dart';

class ShopListSection extends StatelessWidget {
  final List<Shop> shops;
  final Function(Shop)? onShopTap;
  final VoidCallback? onSeeAllTap;
  final bool isLoading;

  const ShopListSection({
    Key? key,
    required this.shops,
    this.onShopTap,
    this.onSeeAllTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 200,
        child: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF9C27B0),
          ),
        ),
      );
    }

    if (shops.isEmpty) {
      return Container(
        height: 200,
        child: const Center(
          child: Text(
            'No shops available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: shops.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final shop = shops[index];
            return Consumer<ShopController>(
              builder: (context, shopController, child) {
                final distance = shopController.getShopDistance(shop);
                final deliveryTime = shopController.getShopDeliveryTime(shop);
                return _buildShopItem(shop, context, distance, deliveryTime);
              },
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        if (onSeeAllTap != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: onSeeAllTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF9C27B0),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Xem thêm ${shops.length > 5 ? shops.length - 5 : 0} Quán',
                    style: const TextStyle(
                      color: Color(0xFF9C27B0),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildShopItem(Shop shop, BuildContext context, double distance, int deliveryTime) {
    
    return GestureDetector(
      onTap: () => onShopTap?.call(shop),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shop Image
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[100],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        shop.shopImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.store,
                              color: Colors.grey,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  
                  if (shop.isFavorite)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Yêu thích',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(width: 12),
              
              // Shop Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop Name with Verified Badge
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 4),
                          child: const Icon(
                            Icons.verified,
                            color: Colors.orange,
                            size: 16,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            shop.shopName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Rating, Distance, Time (calculated)
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          shop.rating.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${distance}km',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${deliveryTime}phút',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}