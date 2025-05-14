// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'order_item_model.dart';

class VendorOrderSepModel {
  final String orderID;
  final String orderStatus;
  final String venderID;
  final List<OrderItemModel> productList;

  VendorOrderSepModel({
    required this.orderID,
    required this.orderStatus,
    required this.venderID,
    required this.productList,
  });

  VendorOrderSepModel copyWith({
    String? orderID,
    String? orderStatus,
    String? venderID,
    List<OrderItemModel>? productList,
  }) {
    return VendorOrderSepModel(
      orderID: orderID ?? this.orderID,
      orderStatus: orderStatus ?? this.orderStatus,
      venderID: venderID ?? this.venderID,
      productList: productList ?? this.productList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderID': orderID,
      'orderStatus': orderStatus,
      'venderID': venderID,
      'productList': productList.map((x) => x.toMap()).toList(),
    };
  }

  factory VendorOrderSepModel.fromMap(Map<String, dynamic> map) {
    return VendorOrderSepModel(
      orderID: map['orderID'] as String,
      orderStatus: map['orderStatus'] as String,
      venderID: map['venderID'] as String,
      productList: List<OrderItemModel>.from(
        (map['productList'] as List<dynamic>).map<OrderItemModel>(
          (x) => OrderItemModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory VendorOrderSepModel.fromJson(String source) =>
      VendorOrderSepModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'VendorOrderSepModel(orderID: $orderID, orderStatus: $orderStatus, venderID: $venderID, productList: $productList)';
  }

  @override
  bool operator ==(covariant VendorOrderSepModel other) {
    if (identical(this, other)) return true;

    return other.orderID == orderID &&
        other.orderStatus == orderStatus &&
        other.venderID == venderID &&
        listEquals(other.productList, productList);
  }

  @override
  int get hashCode {
    return orderID.hashCode ^
        orderStatus.hashCode ^
        venderID.hashCode ^
        productList.hashCode;
  }
}

class OrderConformModel {
  final String orderID;
  final String userID;
  final List<VendorOrderSepModel> orderItemVendor;
  final Timestamp orderDate;
  final String paymentMethod;
  final bool orderSatus; // e.g. true = order confirmed
  final double totalAmount;
  final String paymentSatus; // e.g. "paid", "pending"

  OrderConformModel({
    required this.orderID,
    required this.userID,
    required this.orderItemVendor,
    required this.orderDate,
    required this.paymentMethod,
    required this.orderSatus,
    required this.totalAmount,
    required this.paymentSatus,
  });

  OrderConformModel copyWith({
    String? orderID,
    String? userID,
    List<VendorOrderSepModel>? orderItemVendor,
    Timestamp? orderDate,
    String? paymentMethod,
    bool? orderSatus,
    double? totalAmount,
    String? paymentSatus,
  }) {
    return OrderConformModel(
      orderID: orderID ?? this.orderID,
      userID: userID ?? this.userID,
      orderItemVendor: orderItemVendor ?? this.orderItemVendor,
      orderDate: orderDate ?? this.orderDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderSatus: orderSatus ?? this.orderSatus,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentSatus: paymentSatus ?? this.paymentSatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderID': orderID,
      'userID': userID,
      'orderItemVendor': orderItemVendor.map((x) => x.toMap()).toList(),
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'orderSatus': orderSatus,
      'totalAmount': totalAmount,
      'paymentSatus': paymentSatus,
    };
  }

  factory OrderConformModel.fromMap(Map<String, dynamic> map) {
    return OrderConformModel(
      orderID: map['orderID'] as String,
      userID: map['userID'] as String,
      orderItemVendor: List<VendorOrderSepModel>.from(
        (map['orderItemVendor'] as List<dynamic>).map<VendorOrderSepModel>(
          (x) => VendorOrderSepModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      orderDate: map['orderDate'] as Timestamp,
      paymentMethod: map['paymentMethod'] as String,
      orderSatus: map['orderSatus'] as bool,
      totalAmount: (map['totalAmount'] as num).toDouble(),
      paymentSatus: map['paymentSatus'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderConformModel.fromJson(String source) =>
      OrderConformModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderConformModel(orderID: $orderID, userID: $userID, orderItemVendor: $orderItemVendor, orderDate: $orderDate, paymentMethod: $paymentMethod, orderSatus: $orderSatus, totalAmount: $totalAmount, paymentSatus: $paymentSatus)';
  }

  @override
  bool operator ==(covariant OrderConformModel other) {
    if (identical(this, other)) return true;

    return other.orderID == orderID &&
        other.userID == userID &&
        listEquals(other.orderItemVendor, orderItemVendor) &&
        other.orderDate == orderDate &&
        other.paymentMethod == paymentMethod &&
        other.orderSatus == orderSatus &&
        other.totalAmount == totalAmount &&
        other.paymentSatus == paymentSatus;
  }

  @override
  int get hashCode {
    return orderID.hashCode ^
        userID.hashCode ^
        orderItemVendor.hashCode ^
        orderDate.hashCode ^
        paymentMethod.hashCode ^
        orderSatus.hashCode ^
        totalAmount.hashCode ^
        paymentSatus.hashCode;
  }
}
