import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vendoora_mart/features/vendor/add_Product/screens/edit_product/widget/product_cart_widget.dart';
import 'package:vendoora_mart/features/vendor/domain/models/product_model.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';

class EditProductWidget extends StatefulWidget {
  const EditProductWidget({super.key, required this.published});
  final bool published;

  @override
  State<EditProductWidget> createState() => _EditProductWidgetState();
}

class _EditProductWidgetState extends State<EditProductWidget> {
  List<ProductModel> products = [];

  Stream<List<ProductModel>> fetchProducts() {
    // QuerySnapshot snapshot =
    return HelperFirebase.productInstance
        .where('publish', isEqualTo: widget.published)
        .where('venderUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return ProductModel.fromMap(data); // Transform document to model
            }).toList());

    // return snapshot;
    // products = snapshot.docs.map((e) {
    //   var data = e.data() as Map<String, dynamic>;
    //   return ProductModel.fromMap(data); // Include the doc ID
    // }).toList();

    // setState(() {});

    // print('Products fetched: $products');
  }

  void fetchProductsManually() async {
    try {
      var snapshot = await HelperFirebase.productInstance
          .where('publish', isEqualTo: widget.published)
          .where('venderUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      print("Documents fetched: ${snapshot.docs.length}");

      for (var doc in snapshot.docs) {
        print(doc.data()); // Print each product
      }
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchProducts();
    // fetchProductsManually();
  }

  @override
  Widget build(BuildContext context) {
    print('.................................${products.length}');
    // return ListView.builder(
    //   itemCount: products.length,
    //   itemBuilder: (context, index) {
    //     // return Text(
    //     //   products[index].productName.toString(),
    //     //   style: TextStyle(color: Colors.black),
    //     // );
    //     return ProductCartWidget(product: products[index]);
    //   },
    // );
    return StreamBuilder(
      stream: fetchProducts(),
      builder: (context, snapshot) {
        // print('.................................${}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No products found.',
              style: TextStyle(color: Colors.black54),
            ),
          );
        }

        final products = snapshot.data!;
        print('.................................${products.length}');

        return Container(
          height: 30,
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCartWidget(product: products[index]);
            },
          ),
        );
      },
    );
  }
}
