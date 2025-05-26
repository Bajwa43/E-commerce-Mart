import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';
import 'package:vendoora_mart/features/user/order/domain/model/complaint_model.dart';
import 'package:vendoora_mart/features/user/order/screen/compaint/screen/complaint_detail_screen.dart';
import 'package:vendoora_mart/features/user/order/screen/compaint/screen/previous_complaint_screen.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';

class NewComplaintScreen extends StatefulWidget {
  final String userId;

  const NewComplaintScreen({required this.userId});

  @override
  _NewComplaintScreenState createState() => _NewComplaintScreenState();
}

class _NewComplaintScreenState extends State<NewComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;

  final List<String> _categories = [
    'Product Quality',
    'Late Delivery',
    'Wrong Item Received',
    'Damaged Product',
    'Payment Issue',
    'Refund Request',
    'Customer Service',
    'App/Technical Issue',
    'Seller Behavior',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Complaint',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF24786D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.history, size: 20.sp),
            onPressed: () {
              // Navigate to previous complaints
              HelperFunctions.navigateToScreen(
                  context: context,
                  screen: PreviousComplaintsScreen(userId: widget.userId));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeaderSection(),
                SizedBox(height: 30.h),
                _buildFormSection(),
                SizedBox(height: 30.h),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6F8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Icon(Icons.report_problem,
              size: 50.sp, color: const Color(0xFF24786D)),
          SizedBox(height: 15.h),
          Text(
            'File a New Complaint',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF24786D),
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Please provide detailed information about your issue',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          style: TextStyle(color: Colors.blue, fontSize: 14.sp),
          decoration: InputDecoration(
            labelText: 'Category',
            labelStyle: TextStyle(fontSize: 14.sp),
            prefixIcon: Icon(Icons.category,
                color: const Color(0xFF24786D), size: 20.sp),
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          value: _selectedCategory,
          items: _categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category, style: TextStyle(fontSize: 14.sp)),
            );
          }).toList(),
          onChanged: (value) => setState(() => _selectedCategory = value),
          validator: (value) =>
              value == null ? 'Please select a category' : null,
        ),
        SizedBox(height: 20.h),
        TextFormField(
          controller: _titleController,
          style: TextStyle(color: Colors.black, fontSize: 14.sp),
          decoration: InputDecoration(
            labelText: 'Complaint Title',
            labelStyle: TextStyle(fontSize: 14.sp),
            prefixIcon:
                Icon(Icons.title, color: const Color(0xFF24786D), size: 20.sp),
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
        ),
        SizedBox(height: 20.h),
        TextFormField(
          controller: _descriptionController,
          style: TextStyle(color: Colors.black, fontSize: 14.sp),
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'Detailed Description',
            labelStyle: TextStyle(fontSize: 14.sp),
            alignLabelWithHint: true,
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 60.h),
              child: Icon(Icons.description,
                  color: const Color(0xFF24786D), size: 20.sp),
            ),
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) =>
              value!.isEmpty ? 'Please enter description' : null,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF24786D),
        padding: EdgeInsets.symmetric(vertical: 15.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      onPressed: _submitComplaint,
      child: Text(
        'SUBMIT COMPLAINT',
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userDoc =
            await HelperFirebase.userInstance.doc(widget.userId).get();
        final username = userDoc['fullName'] ?? 'Unknown';

        String compaintId =
            const Uuid().v4(); // Generate unique ID for the product

        final complaint = ComplaintModel(
          id: compaintId,
          title: _titleController.text,
          description: _descriptionController.text,
          category: _selectedCategory ?? 'Other',
          status: 'Open',
          createdId: FirebaseAuth.instance.currentUser!.uid,
          createdBy: username,
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
        );

        final docRef = await FirebaseFirestore.instance
            .collection('complaints')
            .add(complaint.toMap());

        Get.back();
        Get.snackbar(
          'Success',
          'Complaint submitted successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ComplainScreen(
              complaintId: docRef.id,
              userId: widget.userId,
            ),
          ),
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to submit complaint: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}
