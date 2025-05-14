// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistModel {
  String productId;
  Timestamp addedAt;
  WishlistModel({
    required this.productId,
    required this.addedAt,
  });

  WishlistModel copyWith({
    String? productId,
    Timestamp? addedAt,
  }) {
    return WishlistModel(
      productId: productId ?? this.productId,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'addedAt': addedAt.millisecondsSinceEpoch,
    };
  }

  factory WishlistModel.fromMap(Map<String, dynamic> map) {
    return WishlistModel(
        productId: map['productId'] as String,
        addedAt: map['addedAt'] != null
            ? Timestamp.fromMillisecondsSinceEpoch(map['addedAt'])
            : Timestamp.now());
  }

  String toJson() => json.encode(toMap());

  factory WishlistModel.fromJson(String source) =>
      WishlistModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'WishlistModel(productId: $productId, addedAt: $addedAt)';

  @override
  bool operator ==(covariant WishlistModel other) {
    if (identical(this, other)) return true;

    return other.productId == productId && other.addedAt == addedAt;
  }

  @override
  int get hashCode => productId.hashCode ^ addedAt.hashCode;
}
