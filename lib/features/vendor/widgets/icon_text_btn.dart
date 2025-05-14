import 'package:flutter/material.dart';

class IconTextBtn extends StatelessWidget {
  final Icon icon;
  final String text;
  final void Function()? onTap;

  const IconTextBtn(
      {super.key,
      this.icon = const Icon(Icons.star_border),
      this.text = 'btn',
      this.onTap});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: FittedBox(
        child: Container(
          padding: EdgeInsets.all(15),
          // height: 40,
          // width: width * 0.4,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(offset: Offset(-1, -1), blurRadius: 2)],
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade300),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [icon, Text(text)],
          ),
        ),
      ),
    );
  }
}
