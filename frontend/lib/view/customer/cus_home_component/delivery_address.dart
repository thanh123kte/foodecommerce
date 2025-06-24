import 'package:flutter/material.dart';
import 'package:foodecommerce/view/customer/add_delivery_address.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final List<AddressModel> savedAddresses = [
    AddressModel(
      id: '1',
      title: 'Nhà',
      address: '8 kiet 116 Nguyễn Lộ Trạch tổ 14, Xuân Phú, Thành phố Huế, Thừa Thiên Huế, Việt Nam',
      contactName: 'Minh Trang',
      phoneNumber: '0915353514',
      icon: Icons.home,
      isHome: true,
    ),
    AddressModel(
      id: '2',
      title: 'Gần nhà mayd may công nghiệp tung ng...',
      address: 'Đường Chùa Đất Tên, Hòa Quý, Ngũ Hành Sơn, Đà Nẵng, Việt Nam',
      contactName: 'Đào Trung Thành',
      phoneNumber: '0946814775',
      icon: Icons.bookmark,
      isHome: false,
    ),
    AddressModel(
      id: '3',
      title: '52 Bà Huyện Thanh Quan',
      address: '52 Bà Huyện Thanh Quan, Bắc Mỹ An, Ngũ Hành Sơn, Đà Nẵng 550000, Việt Nam',
      contactName: 'Đào Trung Thành',
      phoneNumber: '0946814775',
      icon: Icons.bookmark,
      isHome: false,
    ),
    AddressModel(
      id: '4',
      title: '20 kiet 92 Dương Văn An tổ 12',
      address: '20 kiet 92 Dương Văn An tổ 12, Xuân Phú, Thành phố Huế, Thừa Thiên Huế, Việt Nam',
      contactName: 'Minh Trang',
      phoneNumber: '0915353514',
      icon: Icons.bookmark,
      isHome: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Status Bar and Header
          Container(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                children: [
                  
                  // Header with back button and title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.orange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Địa chỉ giao hàng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // Saved Addresses Section
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Địa chỉ đã lưu',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Add Company Address
                  Container(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        // Handle add company address
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.business_center_outlined,
                              color: Colors.black87,
                              size: 24,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'Thêm địa chỉ Công ty',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Address List
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: savedAddresses.map((address) {
                        return _buildAddressItem(address);
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom Add New Address Button
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const AddAddressScreen(),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5722),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Thêm địa chỉ mới',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Home indicator
              Container(
                width: 134,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressItem(AddressModel address) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                address.icon,
                color: Colors.black87,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  address.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle edit address
                  _showEditAddressDialog(address);
                },
                child: const Text(
                  'Sửa',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.address,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  '${address.contactName}  ${address.phoneNumber}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditAddressDialog(AddressModel address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa địa chỉ'),
        content: Text('Sửa địa chỉ: ${address.title}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}

class AddressModel {
  final String id;
  final String title;
  final String address;
  final String contactName;
  final String phoneNumber;
  final IconData icon;
  final bool isHome;

  AddressModel({
    required this.id,
    required this.title,
    required this.address,
    required this.contactName,
    required this.phoneNumber,
    required this.icon,
    required this.isHome,
  });
}
