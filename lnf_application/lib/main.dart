import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';

void main() async {
  // Đảm bảo các dịch vụ native của Flutter được nạp đầy đủ
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase kết nối với cấu hình tự động
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lost & Found',
      debugShowCheckedModeBanner: false, // Tắt chữ "DEBUG" xấu xí góc phải
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const LoginScreen(), // Gọi màn hình đăng nhập ra đây!
    );
  }
}