import 'package:flutter/material.dart';
import 'package:lost_and_found/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Hai cái này dùng để lấy dữ liệu người dùng gõ vào
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // Biến lưu trạng thái ẩn/ hiện mật khẩu
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea( // Giúp nội dung không bị lẹm vào tai thỏ/camera
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0), // Căn lề 2 bên
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa màn hình
            crossAxisAlignment: CrossAxisAlignment.stretch, // Kéo dãn các nút bấm tràn viền
            children: [
              // Tiêu đề App
              const Text(
                'Lost & Found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 8), // Khoảng trắng
              const Text(
                'Fast - Safe - Smart',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              const SizedBox(height: 48),

              // Ô nhập Email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Bo góc cho đẹp
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Ô nhập Mật khẩu
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Ẩn chữ thành dấu chấm đen
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    }
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Nút Đăng nhập
              ElevatedButton(
                onPressed: () {
                  // Sau này mình sẽ viết code kết nối Firebase vào đây
                  print('User try lo login with Email: ${_emailController.text}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Màu nền nút
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Dòng chữ chuyển sang Đăng ký
              TextButton(
                onPressed: () {
                  //Nhảy sang màn hình Đăng Ký
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text(
                  'Sign up now!',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}