import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/route_manager.dart';
// import 'package:vendoora_mart/features/user/profile/screen/profile_screen.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await HelperFirebase.userInstance.doc(userId).get();

      if (userDoc.exists) {
        _emailController.text = userDoc['email'] ?? '';
        _usernameController.text = userDoc['fullName'] ?? '';
        _phoneController.text = userDoc['phone'] ?? '';
        _cityController.text = userDoc['city'] ?? '';
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final userId = FirebaseAuth.instance.currentUser!.uid;

        await HelperFirebase.userInstance.doc(userId).update({
          'fullName': _usernameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'city': _cityController.text.trim(),
          // You usually don't let user change email directly here
        });

        Get.snackbar("Success", "Profile updated successfully!");
        Get.back(); // Navigate back after saving
      } catch (e) {
        Get.snackbar('Error', 'Failed to update profile');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: TColors.primary,
            centerTitle: true,
            title: Text(
              "Edit Profile",
              style: TextStyle(color: TColors.primaryBackground),
            ),
          ),
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: Get.height / 20),

                        // Email (Read-only field)
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _emailController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),

                        // Username
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              hintText: "Username",
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter your username";
                              }
                              return null;
                            },
                          ),
                        ),

                        // Phone
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: "Phone",
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.length < 10) {
                                return "Enter a valid phone number";
                              }
                              return null;
                            },
                          ),
                        ),

                        // City
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              hintText: "City",
                              prefixIcon: Icon(Icons.location_pin),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter your city";
                              }
                              return null;
                            },
                          ),
                        ),

                        SizedBox(height: Get.height / 20),

                        // Save Changes Button
                        Material(
                          child: Container(
                            width: Get.width / 2,
                            height: Get.height / 18,
                            decoration: BoxDecoration(
                              color: TColors.textSeaonaary,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextButton(
                              onPressed: updateProfile,
                              child: Text(
                                "SAVE CHANGES",
                                style: TextStyle(color: TColors.textPrimary),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height / 20),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
