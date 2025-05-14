import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendoora_mart/features/auth/screens/registration.dart';
import 'package:vendoora_mart/features/user/home/screens/home_screen.dart';
import 'package:vendoora_mart/features/vendor/home/screens/vendor_home_Screen.dart';
import 'package:vendoora_mart/helper/enum.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _validateAndLogin() {
    if (_formKey.currentState!.validate()) {
      // String username = _usernameController.text;
      // String password = _passwordController.text;

      try {
        AuthService.loginUserWithEmailAndPassword(
            context, _usernameController, _passwordController);
      } catch (e) {
        HelperFunctions.showToast('Network Issue');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!kReleaseMode) {
      _usernameController.text = "nomanali@gmail.com";
      _passwordController.text = "nomanali";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _validateAndLogin,
                child: Text('Login'),
              ),
              TextButton(
                  onPressed: () {
                    HelperFunctions.navigateToScreen(
                        context: context, screen: RegistrationScreen());
                  },
                  child: Text('Register'))
            ],
          ),
        ),
      ),
    );
  }
}
