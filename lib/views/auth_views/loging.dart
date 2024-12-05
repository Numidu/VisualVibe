import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:socially/service/auth/auth_srvice.dart';
import 'package:socially/views/responsive/utilits/constant/colors.dart';
import 'package:socially/widgets/reusable/custombuttom.dart';
import 'package:socially/widgets/reusable/custominput.dart';

class Loging extends StatelessWidget {
  Loging({super.key});
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      // Sign in with email and password
      await AuthService().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      GoRouter.of(context).go("/mainscreen");
    } catch (e) {
      print('Error signing in with Google: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Error signing in with Google: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // Sign in with Google
      await AuthService().signInWithGoogle();

      GoRouter.of(context).go('/mainscreen');
    } catch (e) {
      print('Error signing in with Google: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Error signing in with Google: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Custominput(
                    controller: _emailController,
                    labeltext: "Email",
                    icon: Icons.email,
                    obscuretext: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Custominput(
                    controller: _passwordController,
                    labeltext: "Password",
                    icon: Icons.password,
                    obscuretext: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Custombuttom(
                text: "Login",
                width: MediaQuery.of(context).size.width,
                onpressed: () async {
                  if (_formkey.currentState?.validate() ?? false) {
                    await _signInWithEmailAndPassword(context);
                  }
                }),
            const SizedBox(height: 30),
            Text(
              "Sign in with Google to access the app's features",
              style: TextStyle(
                fontSize: 13,
                color: mainWhiteColor.withOpacity(0.6),
              ),
            ),

            const SizedBox(height: 10),
            // Google Sign-In Button
            Custombuttom(
              text: 'Sign in with Google',
              width: MediaQuery.of(context).size.width,
              onpressed: () => _signInWithGoogle(context),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigate to signup screen
                GoRouter.of(context).go('/register');
              },
              child: const Text(
                'Don\'t have an account? Sign up',
                style: TextStyle(
                  color: mainWhiteColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
