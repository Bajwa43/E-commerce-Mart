import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vendoora_mart/features/auth/controllers/registerControler.dart';
import 'package:vendoora_mart/features/auth/domain/models/user_model.dart';
import 'package:vendoora_mart/helper/enum.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vendoora_mart/utiles/constants/text_string.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isUser = true;
  bool isVendor = false;
  // File? _image;
  // File? _shopImage;
  // File? _logoImage;

  // Controllers for text fields
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();

  // For Dropdown Button (Tag Registration)
  String? _selectedTax;
  final List<String> _taxOptions = ['Yes', 'No'];

  void onCheckBoxChange(bool? value) {
    setState(() {
      isVendor = value ?? false;
    });
    print(isVendor);
  }

  @override
  void initState() {
    super.initState();
    Get.put(RegisterController());
  }

  @override
  Widget build(BuildContext context) {
    RegisterController controller = Get.find();
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              !isVendor
                  ? Padding(
                      padding: const EdgeInsets.all(40),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          onTap: () => controller.imagePicker(
                              context, TTextString.profileImage),
                          child: Obx(
                            () => Container(
                              width: 200,
                              height: 200,
                              color: Colors.blue,
                              child: controller.profileImage.value != null
                                  ? Image.file(
                                      controller.profileImage.value!,
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(
                                      child: Text('Select Profile Photo')),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        InkWell(
                          onTap: () => controller.imagePicker(
                              context, TTextString.vendorShopImage),
                          child: Obx(
                            () => Container(
                              color: Colors.blue,
                              height: 240,
                              child: controller.vendorImage.value != null
                                  ? Center(
                                      child: Image.file(
                                        controller.vendorImage.value!,
                                        height: 300,
                                        width: 300,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Center(
                                      child: Text('Select Profile Photo')),
                            ),
                          ),
                        ),
                        // ................................................................................LOGO
                        Padding(
                          padding: const EdgeInsets.only(top: 160, left: 20),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => controller.imagePicker(
                                    context, TTextString.vendorShopLogo),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Obx(
                                    () => Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey.shade400,
                                      child: controller.vendorLogo.value != null
                                          ? Image.file(
                                              controller.vendorLogo.value!,
                                              height: 300,
                                              width: 300,
                                              fit: BoxFit.cover,
                                            )
                                          : const Center(
                                              child: Text(
                                                'Logo',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                _businessNameController.text,
                                style: const TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Fullname
                    isVendor
                        ? TextFormField(
                            onChanged: (value) => setState(() {}),
                            controller: _businessNameController,
                            decoration: const InputDecoration(
                              labelText: 'Business Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Business Name';
                              }
                              return null;
                            },
                          )
                        : TextFormField(
                            controller: _fullnameController,
                            decoration: const InputDecoration(
                              labelText: 'Fullname',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Fullname';
                              }
                              return null;
                            },
                          ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone Number
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Please enter a valid 10-digit phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 16),

                    isVendor
                        ? Column(
                            children: [
                              DropdownButtonFormField<String>(
                                value: _selectedTax,
                                decoration: const InputDecoration(
                                  labelText: 'Tax Registered',
                                  border: OutlineInputBorder(),
                                ),
                                items: _taxOptions.map((String option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedTax = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select Option';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // GST Number
                              TextFormField(
                                controller: _gstNumberController,
                                decoration: const InputDecoration(
                                  labelText: 'GST Number (Optional)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 16),

                              // Address
                              TextFormField(
                                controller: _addressController,
                                decoration: const InputDecoration(
                                  labelText: 'Address',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // City
                              TextFormField(
                                controller: _cityController,
                                decoration: const InputDecoration(
                                  labelText: 'City',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your city';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                          )
                        : const SizedBox(),

                    // Checkbox for Vendor
                    CheckboxListTile(
                      value: isVendor,
                      onChanged: onCheckBoxChange,
                      title: const Text('Are you a Vendor?'),
                    ),

                    // Register Button
                    ElevatedButton(
                      onPressed: () => controller.registerUser(
                          context: context,
                          fullnameController: _fullnameController,
                          emailController: _emailController,
                          phoneController: _phoneController,
                          passwordController: _passwordController,
                          businessNameController: _businessNameController,
                          addressController: _addressController,
                          cityController: _cityController,
                          gstNumberController: _gstNumberController,
                          isVendor: isVendor,
                          selectedTax: _selectedTax,
                          formKey: _formKey),
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
