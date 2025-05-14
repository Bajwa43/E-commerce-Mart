import 'package:flutter/material.dart';

class EarningContainerWidget extends StatelessWidget {
  final String label;
  final String value;
  final Color containerColor;
  const EarningContainerWidget(
      {super.key,
      this.containerColor = Colors.green,
      required this.label,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 150,
      decoration: BoxDecoration(
          color: containerColor, borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
