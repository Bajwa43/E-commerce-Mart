import 'dart:convert';
import 'package:flutter/foundation.dart';

class ProductModel {
  String? venderUid;
  String? productUid;
  bool? publish;
  bool? approved; // <-- New field added
  String? productName;
  String? price;
  String? fashionCategory;
  String? gender;
  String? fashionItem;
  String? keyFeatures;
  String? description;
  List<String>? sizes;
  List<String> images;
  int? quantityOfProduct;

  ProductModel({
    this.venderUid,
    this.productUid,
    this.publish,
    this.approved, // <-- In constructor
    this.productName,
    this.price,
    this.fashionCategory,
    this.gender,
    this.fashionItem,
    this.keyFeatures,
    this.description,
    this.sizes,
    required this.images,
    this.quantityOfProduct,
  });

  ProductModel copyWith({
    String? venderUid,
    String? productUid,
    bool? publish,
    bool? approved,
    String? productName,
    String? price,
    String? fashionCategory,
    String? gender,
    String? fashionItem,
    String? keyFeatures,
    String? description,
    List<String>? sizes,
    List<String>? images,
    int? quantityOfProduct,
  }) {
    return ProductModel(
      venderUid: venderUid ?? this.venderUid,
      productUid: productUid ?? this.productUid,
      publish: publish ?? this.publish,
      approved: approved ?? this.approved,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      fashionCategory: fashionCategory ?? this.fashionCategory,
      gender: gender ?? this.gender,
      fashionItem: fashionItem ?? this.fashionItem,
      keyFeatures: keyFeatures ?? this.keyFeatures,
      description: description ?? this.description,
      sizes: sizes ?? this.sizes,
      images: images ?? this.images,
      quantityOfProduct: quantityOfProduct ?? this.quantityOfProduct,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'venderUid': venderUid,
      'productUid': productUid,
      'publish': publish,
      'approved': approved, // <-- Added here
      'productName': productName,
      'price': price,
      'fashionCategory': fashionCategory,
      'gender': gender,
      'fashionItem': fashionItem,
      'keyFeatures': keyFeatures,
      'description': description,
      'sizes': sizes,
      'images': images,
      'quantityOfProduct': quantityOfProduct,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      venderUid: map['venderUid'],
      productUid: map['productUid'],
      publish: map['publish'],
      approved: map['approved'], // <-- Added here
      productName: map['productName'],
      price: map['price'],
      fashionCategory: map['fashionCategory'],
      gender: map['gender'],
      fashionItem: map['fashionItem'],
      keyFeatures: map['keyFeatures'],
      description: map['description'],
      sizes: map['sizes'] != null ? List<String>.from(map['sizes']) : null,
      images: List<String>.from(map['images']),
      quantityOfProduct: map['quantityOfProduct'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(venderUid: $venderUid, productUid: $productUid, publish: $publish, approved: $approved, productName: $productName, price: $price, fashionCategory: $fashionCategory, gender: $gender, fashionItem: $fashionItem, keyFeatures: $keyFeatures, description: $description, sizes: $sizes, images: $images, quantityOfProduct: $quantityOfProduct)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.venderUid == venderUid &&
        other.productUid == productUid &&
        other.publish == publish &&
        other.approved == approved && // <-- Included in equality
        other.productName == productName &&
        other.price == price &&
        other.fashionCategory == fashionCategory &&
        other.gender == gender &&
        other.fashionItem == fashionItem &&
        other.keyFeatures == keyFeatures &&
        other.description == description &&
        listEquals(other.sizes, sizes) &&
        listEquals(other.images, images) &&
        other.quantityOfProduct == quantityOfProduct;
  }

  @override
  int get hashCode {
    return venderUid.hashCode ^
        productUid.hashCode ^
        publish.hashCode ^
        approved.hashCode ^ // <-- Included here
        productName.hashCode ^
        price.hashCode ^
        fashionCategory.hashCode ^
        gender.hashCode ^
        fashionItem.hashCode ^
        keyFeatures.hashCode ^
        description.hashCode ^
        sizes.hashCode ^
        images.hashCode ^
        quantityOfProduct.hashCode;
  }
}
