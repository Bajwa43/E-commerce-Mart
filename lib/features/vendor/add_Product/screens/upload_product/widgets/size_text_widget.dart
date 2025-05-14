import 'package:flutter/material.dart';
import 'package:vendoora_mart/features/vendor/controller/product_controller.dart';

class SizeTextWidget extends StatefulWidget {
  final String categoryName;
  final List<String> sizes;
  const SizeTextWidget(
      {super.key, required this.categoryName, required this.sizes});

  @override
  State<SizeTextWidget> createState() => _SizeTextWidgetState();
}

class _SizeTextWidgetState extends State<SizeTextWidget> {
  List<bool> isChecked = [false, false, false, false, false, false];
  @override
  Widget build(BuildContext context) {
    // print(selectedSizeList);

    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.categoryName,
              style: TextStyle(color: Colors.red),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Select available sizes',
              style: TextStyle(color: Colors.blueGrey),
            ),
          ),

          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.sizes.length,
              itemBuilder: (context, index) => Row(children: [
                Text(widget.sizes[index]),
                Checkbox(
                  value: isChecked[index],
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked[index] = value!;
                      if (value) {
                        // Add the size only if it's not already in the list
                        if (!ProductController.selectedSizeList
                            .contains(widget.sizes[index])) {
                          ProductController.selectedSizeList
                              .add(widget.sizes[index]);
                        }
                      } else {
                        // Remove the size from the list
                        ProductController.selectedSizeList
                            .remove(widget.sizes[index]);
                      }
                    });
                  },
                ),
              ]),
            ),
          ),
          // CheckboxListTile(
          //   title: Text(widget.sizes[1]),
          //   value: isChecked[1],
          //   onChanged: (bool? value) {
          //     setState(() {
          //       isChecked[1] = value!;
          //     });
          //   },
          // )
          // ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     itemCount: widget.sizes.length,
          //     itemBuilder: (context, index) {
          //       return CheckboxListTile(
          //         title: Text(widget.sizes[index]),
          //         value: isChecked[index],
          //         onChanged: (bool? value) {
          //           setState(() {
          //             isChecked[index] = value!;
          //           });
          //         },
          //       );
          //     })
        ],
      ),
    );
  }
}
