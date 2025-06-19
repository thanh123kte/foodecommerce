import 'package:flutter/material.dart';
import 'package:foodecommerce/controller/category_controller.dart';
import 'package:foodecommerce/controller/food_controller.dart';
import 'package:foodecommerce/controller/seller_controller.dart';
import 'package:foodecommerce/model/category.dart';
import 'package:foodecommerce/model/food.dart';
import 'package:foodecommerce/view/customer/cus_home_component/banner_slider.dart';
import 'package:foodecommerce/view/customer/cus_home_component/category_slidable.dart';
import 'package:foodecommerce/view/customer/food_horizontal_list.dart';
import 'package:foodecommerce/view/customer/shop_list.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Load categories when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }
  Future<void> _loadData() async {
    await Future.wait([
      _loadCategories(),
      _loadPopularFoods(),
      _loadShops()
    ]);
  } 

  Future<void> _loadShops() async {
    final shopController = Provider.of<ShopController>(context, listen: false);
    
    bool success = await shopController.fetchShops();
    
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(shopController.errorMessage ?? 'Failed to load shops'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Future<void> _loadCategories() async {
    final categoryController = Provider.of<CategoryController>(context, listen: false);
    
    bool success = await categoryController.fetchCategories();
    
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(categoryController.errorMessage ?? 'Failed to load categories'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: _loadCategories,
          ),
        ),
      );
    }
  }

  Future<void> _loadPopularFoods() async {
    final foodController = Provider.of<FoodController>(context, listen: false);
    
    bool success = await foodController.fetchPopularFoods();
    
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(foodController.errorMessage ?? 'Failed to load popular foods'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> bannerImages = [
      'images/banner1.jpg',
      'images/banner2.jpg', 
      'images/banner3.jpg',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Food Delivery',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadCategories();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // Image Slider
              BannerSlider(
                images: bannerImages,
                height: 200,
                autoPlayDuration: const Duration(seconds: 4),
                borderRadius: BorderRadius.circular(15),
              ),
              
              const SizedBox(height: 24),
              
              // Categories Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/categories');
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFF9C27B0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Category Slider with Controller
              Consumer<CategoryController>(
                builder: (context, categoryController, child) {
                  if (categoryController.isLoading) {
                    return Container(
                      height: 240,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Color(0xFF9C27B0),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Loading categories...',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (categoryController.errorMessage != null) {
                    return Container(
                      height: 240,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              categoryController.errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadCategories,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9C27B0),
                              ),
                              child: const Text(
                                'Retry',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return CategorySlider(
                    categories: categoryController.categories,
                    onCategoryTap: (category) {
                      _handleCategoryTap(context, category);
                    },
                    itemWidth: 85,
                    itemHeight: 95,
                  );
                },
              ),
              
              const SizedBox(height: 24),
              // Popular Items Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Popular Items',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/foods');
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFF9C27B0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Popular Foods List
              Consumer<FoodController>(
                builder: (context, foodController, child) {
                  return PopularFoodsList(
                    foods: foodController.popularFoods,
                    isLoading: foodController.isLoading,
                    onFoodTap: (food) {
                      _handleFoodTap(context, food);
                    },
                  );
                },
              ),
              
              const SizedBox(height: 20),

              // Shop list section

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quán ăn gần bạn',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/shops');
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          color: Color(0xFF9C27B0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Shop List
              Consumer<ShopController>(
                builder: (context, shopController, child) {
                  return ShopListSection(
                    shops: shopController.featuredShops,
                    isLoading: shopController.isLoading,
                    onShopTap: (shop) {
                      print("shopId: ${shop.shopId} - shopName: ${shop.shopName}");
                      Navigator.pushNamed(
                        context,
                        '/shop-detail',
                        arguments: {
                          'shopId': shop.shopId,
                          'shop': shop,
                        },
                      );
                    },
                    onSeeAllTap: () {
                      Navigator.pushNamed(context, '/shops');
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              
            ],
          ),
        ),
      ),
    );
  }

  void _handleCategoryTap(BuildContext context, Category category) {
    print('Selected category: ${category.categoryName} (ID: ${category.categoryId})');
    
    Navigator.pushNamed(
      context, 
      '/category-foods',
      arguments: {
        'categoryId': category.categoryId,
        'categoryName': category.categoryName,
      },
    );
  }

  void _handleFoodTap(BuildContext context, Food food) {
    print('Selected food: ${food.foodName} (ID: ${food.foodId})');
    Navigator.pushNamed(
      context,
      '/food-detail',
      arguments: {
        'foodId': food.foodId,
        'food': food,
      },
    );
  }
}