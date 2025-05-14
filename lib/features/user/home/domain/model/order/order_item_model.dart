import 'dart:convert';

class OrderItemModel {
  final String orderItemID;
  final String productID;
  final String productName;
  final String size;
  final String imageUrl;
  final int quantity;

  OrderItemModel({
    required this.orderItemID,
    required this.productID,
    required this.productName,
    required this.size,
    required this.imageUrl,
    required this.quantity,
  });

  OrderItemModel copyWith({
    String? orderItemID,
    String? productID,
    String? productName,
    String? size,
    String? imageUrl,
    int? quantity,
  }) {
    return OrderItemModel(
      orderItemID: orderItemID ?? this.orderItemID,
      productID: productID ?? this.productID,
      productName: productName ?? this.productName,
      size: size ?? this.size,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderItemID': orderItemID,
      'productID': productID,
      'productName': productName,
      'size': size,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      orderItemID: map['orderItemID'] as String,
      productID: map['productID'] as String,
      productName: map['productName'] as String? ?? '',
      size: map['size'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      quantity: map['quantity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderItemModel.fromJson(String source) =>
      OrderItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'OrderItemModel(orderItemID: $orderItemID, productID: $productID, productName: $productName, size: $size, imageUrl: $imageUrl, quantity: $quantity)';

  @override
  bool operator ==(covariant OrderItemModel other) {
    if (identical(this, other)) return true;

    return other.orderItemID == orderItemID &&
        other.productID == productID &&
        other.productName == productName &&
        other.size == size &&
        other.imageUrl == imageUrl &&
        other.quantity == quantity;
  }

  @override
  int get hashCode =>
      orderItemID.hashCode ^
      productID.hashCode ^
      productName.hashCode ^
      size.hashCode ^
      imageUrl.hashCode ^
      quantity.hashCode;
}
