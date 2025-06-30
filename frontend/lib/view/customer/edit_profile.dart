import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodecommerce/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  Future<User?>? _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = loadUserFromPrefs();
  }

  Future<User?> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('user_data');
    if (jsonString == null) return null;
    try {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return User.fromJson(jsonMap);
    } catch (e) {
      print("Lỗi parse user_data từ prefs: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
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

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF7043), Color(0xFFFF5722)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                          ),
                          const Text(
                            'Lưu',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: ClipOval(
                            child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                                ? Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.person, color: Colors.grey, size: 40),
                                  )
                                : Image.network(
                                    user.avatarUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(Icons.person, color: Colors.grey, size: 40),
                                      );
                                    },
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Sửa',
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Body
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildProfileField(
                        label: 'Tên',
                        value: user.fullName ?? '',
                        onTap: () {},
                      ),
                      _buildProfileField(
                        label: 'Giới tính',
                        value: 'Chưa cập nhật',
                        onTap: () {},
                      ),
                      _buildProfileField(
                        label: 'Ngày sinh',
                        value: user.dayOfBirth != null
                            ? '${user.dayOfBirth!.day}/${user.dayOfBirth!.month}/${user.dayOfBirth!.year}'
                            : 'Chưa cập nhật',
                        onTap: () {},
                      ),
                      _buildProfileField(
                        label: 'Điện thoại',
                        value: user.phone ?? '',
                        onTap: () {},
                      ),
                      _buildProfileField(
                        label: 'Email',
                        value: user.email ?? '',
                        onTap: () {},
                      ),
                      _buildProfileField(
                        label: 'Đổi mật khẩu',
                        value: '',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                color: Colors.white,
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileField({
    required String label,
    required String value,
    Color? valueColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (value.isNotEmpty)
                    Flexible(
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 16,
                          color: valueColor ?? Colors.black87,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
