import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Tạo 4 bộ điều khiển để lấy dữ liệu từ 4 ô nhập liệu
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _confirmPasswordError;

  // Biến kiểm soát trạng thái xoay xoay khi đang tạo tài khoản
  bool _isLoading = false;
  // Hàm xử lý đăng ký tài khoản gửi lên Firebase
  void _register() async {
    setState(() {
      _isLoading = true; // Bật vòng xoay loading
    });

    try {
      // Lệnh thần thánh của Firebase để tạo tài khoản bằng Email & Password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Nếu thành công, hiện thông báo màu xanh
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký tài khoản thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        // Quay trở lại màn hình Đăng nhập
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      // Nếu Firebase trả về lỗi, mình sẽ bắt lỗi và dịch sang tiếng Việt cho user dễ hiểu
      String message = 'Đã có lỗi xảy ra. Vui lòng thử lại!';
      if (e.code == 'weak-password') {
        message = 'Mật khẩu quá yếu (phải từ 6 ký tự trở lên)!';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email này đã được đăng ký bởi một sinh viên khác!';
      } else if (e.code == 'invalid-email') {
        message = 'Định dạng email không hợp lệ!';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      // Bắt các lỗi hệ thống khác nếu có
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Tắt vòng xoay loading dù thành công hay thất bại
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    bool isFormValid = _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _confirmPasswordError == null;

    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar tạo ra nút "Quay lại" tự động ở góc trái
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: SafeArea(
        // SingleChildScrollView giúp màn hình cuộn được (tránh lỗi vàng đen khi bàn phím hiện lên)
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create an account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Join now and start finding lost items',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // 1. Ô nhập Họ và Tên
                TextField(
                  controller: _nameController,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Full name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // 2. Ô nhập Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Student Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Ô nhập Mật khẩu
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  onChanged: (value) {
                    // Chỉ kiểm tra khi ô "Xác nhận mật khẩu" đã có chữ
                    if (_confirmPasswordController.text.isNotEmpty) {
                      setState(() {
                        if (value != _confirmPasswordController.text) {
                          _confirmPasswordError = 'Password do not match!';
                        } else {
                          _confirmPasswordError = null; // Khớp thì xóa lỗi
                        }
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                // 4. Ô nhập Xác nhận mật khẩu
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  onChanged: (value) {
                    setState(() {
                      // Gõ tới đâu, so sánh tới đó
                      if (value != _passwordController.text) {
                        _confirmPasswordError = 'Password do not match!';
                      } else {
                        _confirmPasswordError = null; // Khớp thì xóa chữ đỏ ngay
                      }
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    errorText: _confirmPasswordError,
                    prefixIcon: const Icon(Icons.lock_reset),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 32),

                // Nút bấm Đăng ký
            ElevatedButton(
              // Nếu đang loading thì chặn bấm (truyền null), ngược lại form hợp lệ thì cho bấm
              onPressed: _isLoading ? null : (isFormValid ? _register : null),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade500,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              // Nếu đang loading thì hiện vòng tròn xoay, ngược lại hiện chữ ĐĂNG KÝ NGAY
              child: _isLoading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
                  : const Text(
                'SIGN UP',
                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )],
            ),
          ),
        ),
      ),
    );
  }
}