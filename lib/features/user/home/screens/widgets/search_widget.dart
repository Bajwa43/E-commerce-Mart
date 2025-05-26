import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final void Function(String)? onSubmitted; // 🔥 Add this line

  const SearchInput({
    super.key,
    required this.textController,
    required this.hintText,
    this.onSubmitted, // 🔥 Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 48.h),
      child: Container(
        height: TSizes.searchHomeFirldH,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(12, 26),
              blurRadius: 50,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.1),
            ),
          ],
        ),
        child: TextField(
          style: TextStyle(color: Colors.black),
          controller: textController,
          onChanged: (value) {
            // Optional: Live filtering
          },
          onSubmitted: onSubmitted, // 🔥 Use the submitted callback
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xff4338CA),
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
          ),
        ),
      ),
    );
  }
}
