import 'package:flutter/material.dart';
import 'topbooks_screen.dart';

void main() {
  runApp(const ReadscapeApp());
}

class ReadscapeApp extends StatelessWidget {
  const ReadscapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Readscape',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Georgia',
        scaffoldBackgroundColor: const Color(0xFFF9E8A2), 
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7A1F2B),
          primary: const Color(0xFF7A1F2B),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

// ============================================================
// COLORS
// ============================================================

const Color background = Color(0xFFF9E8A2);
const Color maroon = Color(0xFF7A1F2B);
const Color darkMaroon = Color(0xFF5C1720);
const Color lightCream = Color(0xFFFFF9E8);
const Color mutedText = Color(0xFF806F65);
const Color border = Color(0xFFD9CBBE);

// ============================================================
// WELCOME SCREEN
// ============================================================

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 65),

            // LOGO AND BUTTONS
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 320,
                    height: 320,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 20),

                  // SIGN UP
                  SizedBox(
                    width: 220,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SignUpScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: maroon,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // LOG IN
                  SizedBox(
                    width: 220,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LoginScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: maroon,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            const Padding(
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
                bottom: 20,
              ),
              child: Text(
                '“Escape into stories, one page at a time.”',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: mutedText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// AUTH TOP
// ============================================================

class AuthTop extends StatelessWidget {
  const AuthTop({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            top: 35,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: maroon,
                size: 28,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          Positioned(
            top: 0,
            child: Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) {
                return const Icon(
                  Icons.menu_book_rounded,
                  color: maroon,
                  size: 50,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// LOG IN SCREEN
// ============================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your email and password.',
          ),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const TopBooksScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const AuthTop(),

              const Center(
                child: Text(
                  'Enter the Readscape',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: maroon,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Image.asset(
                  'assets/images/book.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              _inputLabel('Email'),

              const SizedBox(height: 8),

              TextField(
                controller: emailController,
                keyboardType:
                    TextInputType.emailAddress,
                decoration: _inputDecoration(
                  hintText: 'Enter your email',
                  icon: Icons.email_outlined,
                ),
              ),

              const SizedBox(height: 18),

              _inputLabel('Password'),

              const SizedBox(height: 8),

              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: _inputDecoration(
                  hintText: 'Enter your password',
                  icon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: maroon,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword =
                            !obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Forgot password selected.',
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: maroon,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maroon,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _login,
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: maroon,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: mutedText,
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        color: maroon,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: lightCream,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(28),
        borderSide: const BorderSide(
          color: border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(28),
        borderSide: const BorderSide(
          color: border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(28),
        borderSide: const BorderSide(
          color: maroon,
          width: 2,
        ),
      ),
    );
  }
}

// ============================================================
// SIGN UP SCREEN
// ============================================================

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool obscurePassword = true;

  final TextEditingController usernameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    if (usernameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill in all required fields.',
          ),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const TopBooksScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const AuthTop(),

              const Center(
                child: Text(
                  'Enter the Readscape',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: maroon,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: Image.asset(
                  'assets/images/book.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              _inputLabel('Username'),

              const SizedBox(height: 8),

              TextField(
                controller: usernameController,
                decoration: _inputDecoration(
                  hintText: 'Enter your username',
                  icon: Icons.person_outline,
                ),
              ),

              const SizedBox(height: 18),

              _inputLabel('Email'),

              const SizedBox(height: 8),

              TextField(
                controller: emailController,
                keyboardType:
                    TextInputType.emailAddress,
                decoration: _inputDecoration(
                  hintText: 'Enter your email',
                  icon: Icons.email_outlined,
                ),
              ),

              const SizedBox(height: 18),

              _inputLabel('Password'),

              const SizedBox(height: 8),

              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: _inputDecoration(
                  hintText: 'Create a password',
                  icon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: maroon,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword =
                            !obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  'or sign up using',
                  style: TextStyle(
                    color: mutedText,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(
                        style:
                            OutlinedButton.styleFrom(
                          foregroundColor: maroon,
                          side: const BorderSide(
                            color: maroon,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    28),
                          ),
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Facebook sign up selected.',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.facebook,
                          color: maroon,
                          size: 20,
                        ),
                        label: const Text(
                          'Facebook',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton.icon(
                        style:
                            OutlinedButton.styleFrom(
                          foregroundColor: maroon,
                          side: const BorderSide(
                            color: maroon,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    28),
                          ),
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Google sign up selected.',
                              ),
                            ),
                          );
                        },
                        icon: const Text(
                          'G',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                Color(0xFF4285F4),
                          ),
                        ),
                        label: const Text(
                          'Google',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maroon,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _createAccount,
                  child: const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: maroon,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: mutedText,
        fontSize: 14,
      ),
      prefixIcon: Icon(
        icon,
        color: maroon,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: lightCream,
      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(28),
        borderSide: const BorderSide(
          color: border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(28),
        borderSide: const BorderSide(
          color: border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(28),
        borderSide: const BorderSide(
          color: maroon,
          width: 2,
        ),
      ),
    );
  }
}

