import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodecommerce/controller/firebase_auth_controller.dart';
import 'package:foodecommerce/model/user.dart';
import 'package:foodecommerce/view/customer/cus_home_component/delivery_address.dart';
import 'package:foodecommerce/view/customer/edit_profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User?> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = loadUserFromPrefs();
  }

  Future<User?> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_data');
    print("Đang tải user_data từ prefs: $jsonString");
    if (jsonString == null) return null;

    try {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      print("Đã tải user_data từ prefs: $jsonMap");
      return User.fromJson(jsonMap);
    } catch (e) {
      print("Lỗi parse user_data từ prefs: $e");
      return null;
    }
  }

  Future<void> _handleLogout(BuildContext context) async {
    final auth = Provider.of<FirebaseAuthController>(context, listen: false);

    bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Đăng xuất', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?', style: TextStyle(fontSize: 16, color: Colors.grey)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        await auth.logout();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Đăng xuất thành công"), backgroundColor: Colors.green),
          );
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Lỗi đăng xuất: ${e.toString()}"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthController>(context);

    return FutureBuilder<User?>(
      future: _futureUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final user = snapshot.data;
        if (user == null) {
          return const Scaffold(body: Center(child: Text("Không tìm thấy thông tin người dùng")));
        }
        print("UID: ${user.userId}");
        print("Email: ${user.email}");
        print("Display Name: ${user.fullName}");
        print("Photo URL: ${user.avatarUrl}");


        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Column(
            children: [
              // Header
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF7043), Color(0xFFFF5722)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: ClipOval(
                                child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                                    ? Container(
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                          size: 40,
                                        ),
                                      )
                                    : Image.network(
                                        user.avatarUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.person,
                                              color: Colors.grey,
                                              size: 40,
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              user.fullName ?? 'Người dùng chưa đặt tên',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // Menu items
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      _buildMenuItem(
                        icon: Icons.favorite_outline,
                        iconColor: Colors.red,
                        title: 'Quán yêu thích',
                        onTap: () {
                          print('Tapped Quán yêu thích');
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),

                      _buildMenuItem(
                        icon: Icons.location_on_outlined,
                        iconColor: Colors.green,
                        title: 'Địa chỉ',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DeliveryAddressScreen()),
                          );
                        },
                      ),
                      const Divider(height: 1, color: Color(0xFFE0E0E0)),

                      _buildMenuItem(
                        icon: Icons.manage_accounts_outlined,
                        iconColor: Colors.grey,
                        title: 'Hồ sơ của tôi',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
                          );
                        },
                      ),

                      const Spacer(),

                      // Logout
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B6B), Color(0xFFE53E3E)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: auth.isLoading ? null : () => _handleLogout(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: auth.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.logout, color: Colors.white, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Đăng xuất',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
          ],
        ),
      ),
    );
  }

}
