// import 'package:flutter/material.dart';
// import 'package:foodecommerce/model/food.dart';
// class FoodDetailsScreen extends StatefulWidget {
//   final Food food;
  
//   const FoodDetailsScreen({
//     super.key,
//     required this.food,
//   });

//   @override
//   State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
// }

// class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
//   int currentImageIndex = 0;
//   int quantity = 1;
//   bool isFavorite = false;

//   final List<ReviewModel> reviews = [
//     ReviewModel(
//       userName: 'Nguyễn Văn A',
//       rating: 5,
//       comment: 'Món ăn rất ngon, phục vụ tốt. Sẽ quay lại lần sau!',
//       date: '2 ngày trước',
//       avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=50&h=50&fit=crop&crop=face',
//     ),
//     ReviewModel(
//       userName: 'Trần Thị B',
//       rating: 4,
//       comment: 'Đồ ăn tươi ngon, giá cả hợp lý. Chỉ có điều giao hàng hơi chậm.',
//       date: '1 tuần trước',
//       avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=50&h=50&fit=crop&crop=face',
//     ),
//     ReviewModel(
//       userName: 'Lê Minh C',
//       rating: 5,
//       comment: 'Tuyệt vời! Đây là món ăn yêu thích của tôi.',
//       date: '2 tuần trước',
//       avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=50&h=50&fit=crop&crop=face',
//     ),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     isFavorite = widget.food.isFavorite;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           // Top Bar
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: const Icon(
//                         Icons.arrow_back,
//                         color: Colors.black87,
//                         size: 24,
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         isFavorite = !isFavorite;
//                       });
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         isFavorite ? Icons.favorite : Icons.favorite_border,
//                         color: isFavorite ? Colors.red : Colors.black87,
//                         size: 24,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Content
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Food Images
//                   SizedBox(
//                     height: 250,
//                     child: Stack(
//                       children: [
//                         PageView.builder(
//                           itemCount: widget.food.images.isNotEmpty ? widget.food.images.length : 1,
//                           onPageChanged: (index) {
//                             setState(() {
//                               currentImageIndex = index;
//                             });
//                           },
//                           itemBuilder: (context, index) {
//                             final imageUrl = widget.food.images.isNotEmpty 
//                                 ? widget.food.images[index]
//                                 : 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop';
                            
//                             return Container(
//                               margin: const EdgeInsets.symmetric(horizontal: 16),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.1),
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.network(
//                                   imageUrl,
//                                   fit: BoxFit.cover,
//                                   errorBuilder: (context, error, stackTrace) {
//                                     return Container(
//                                       color: Colors.grey[200],
//                                       child: const Icon(
//                                         Icons.fastfood,
//                                         size: 60,
//                                         color: Colors.grey,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
                        
//                         // Image indicators
//                         if (widget.food.images.length > 1)
//                           Positioned(
//                             bottom: 16,
//                             left: 0,
//                             right: 0,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: widget.food.images.asMap().entries.map((entry) {
//                                 return Container(
//                                   width: 8,
//                                   height: 8,
//                                   margin: const EdgeInsets.symmetric(horizontal: 4),
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: currentImageIndex == entry.key
//                                         ? Colors.white
//                                         : Colors.white.withOpacity(0.5),
//                                   ),
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Food Information
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Food Name
//                         Text(
//                           widget.food.name,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),

//                         const SizedBox(height: 12),

//                         // Stats Row
//                         Row(
//                           children: [
//                             _buildStatItem(Icons.shopping_cart, '${_formatNumber(widget.food.soldCount)} đã bán'),
//                             const SizedBox(width: 20),
//                             _buildStatItem(Icons.favorite, '${_formatNumber(widget.food.likeCount)} lượt thích'),
//                             const SizedBox(width: 20),
//                             _buildStatItem(Icons.star, '${widget.food.rating} (${widget.food.reviewCount} đánh giá)'),
//                           ],
//                         ),

//                         const SizedBox(height: 16),

//                         // Description
//                         const Text(
//                           'Mô tả',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           widget.food.description.isNotEmpty 
//                               ? widget.food.description
//                               : 'Món ăn ngon với hương vị đặc trưng, được chế biến từ những nguyên liệu tươi ngon nhất.',
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey,
//                             height: 1.5,
//                           ),
//                         ),

//                         const SizedBox(height: 20),

//                         // Price and Add Button Row
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text(
//                                     'Giá',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         '${_formatPrice(widget.food.price)}đ',
//                                         style: const TextStyle(
//                                           fontSize: 24,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.orange,
//                                         ),
//                                       ),
//                                       if (widget.food.originalPrice > widget.food.price) ...[
//                                         const SizedBox(width: 8),
//                                         Text(
//                                           '${_formatPrice(widget.food.originalPrice)}đ',
//                                           style: TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.grey,
//                                             decoration: TextDecoration.lineThrough,
//                                           ),
//                                         ),
//                                       ],
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
                            
//                             // Quantity and Add Button
//                             Row(
//                               children: [
//                                 // Quantity Selector
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     border: Border.all(color: Colors.grey[300]!),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       GestureDetector(
//                                         onTap: () {
//                                           if (quantity > 1) {
//                                             setState(() {
//                                               quantity--;
//                                             });
//                                           }
//                                         },
//                                         child: Container(
//                                           padding: const EdgeInsets.all(8),
//                                           child: const Icon(
//                                             Icons.remove,
//                                             size: 16,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                         child: Text(
//                                           quantity.toString(),
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                         ),
//                                       ),
//                                       GestureDetector(
//                                         onTap: () {
//                                           setState(() {
//                                             quantity++;
//                                           });
//                                         },
//                                         child: Container(
//                                           padding: const EdgeInsets.all(8),
//                                           child: const Icon(
//                                             Icons.add,
//                                             size: 16,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
                                
//                                 const SizedBox(width: 12),
                                
//                                 // Add Button
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     _addToCart();
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.orange,
//                                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   child: const Text(
//                                     'Thêm',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 30),

//                         // Reviews Section
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Đánh giá',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 // Show all reviews
//                               },
//                               child: const Text(
//                                 'Xem tất cả',
//                                 style: TextStyle(
//                                   color: Colors.orange,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 12),

//                         // Reviews List
//                         ...reviews.map((review) => _buildReviewItem(review)).toList(),

//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(
//           icon,
//           size: 16,
//           color: Colors.grey,
//         ),
//         const SizedBox(width: 4),
//         Text(
//           text,
//           style: const TextStyle(
//             fontSize: 12,
//             color: Colors.grey,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildReviewItem(ReviewModel review) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.grey[50],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 16,
//                 backgroundImage: NetworkImage(review.avatar),
//                 onBackgroundImageError: (exception, stackTrace) {},
//                 child: review.avatar.isEmpty
//                     ? const Icon(Icons.person, size: 16)
//                     : null,
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       review.userName,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         ...List.generate(5, (index) {
//                           return Icon(
//                             index < review.rating ? Icons.star : Icons.star_border,
//                             size: 12,
//                             color: Colors.orange,
//                           );
//                         }),
//                         const SizedBox(width: 8),
//                         Text(
//                           review.date,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             review.comment,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Colors.black87,
//               height: 1.4,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatNumber(int number) {
//     if (number >= 1000) {
//       return '${(number / 1000).toStringAsFixed(1)}k';
//     }
//     return number.toString();
//   }

//   String _formatPrice(double price) {
//     return price.toStringAsFixed(0).replaceAllMapped(
//       RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
//       (Match m) => '${m[1]},',
//     );
//   }

//   void _addToCart() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Thêm vào giỏ hàng'),
//         content: Text('Đã thêm $quantity x ${widget.food.name} vào giỏ hàng!'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ReviewModel {
//   final String userName;
//   final int rating;
//   final String comment;
//   final String date;
//   final String avatar;

//   ReviewModel({
//     required this.userName,
//     required this.rating,
//     required this.comment,
//     required this.date,
//     required this.avatar,
//   });
// }
