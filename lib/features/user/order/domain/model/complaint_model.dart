// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status;
  final String createdId;
  final String createdBy;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  ComplaintModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  ComplaintModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? status,
    String? createdId,
    String? createdBy,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return ComplaintModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      createdId: createdId ?? this.createdId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'createdId': createdId,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    return ComplaintModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      status: map['status'] as String,
      createdId: map['createdId'] as String,
      createdBy: map['createdBy'] as String,
      createdAt: map['createdAt'] as Timestamp,
      updatedAt: map['updatedAt'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory ComplaintModel.fromJson(String source) =>
      ComplaintModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ComplaintModel(id: $id, title: $title, description: $description, category: $category, status: $status, createdId: $createdId, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant ComplaintModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.status == status &&
        other.createdId == createdId &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        category.hashCode ^
        status.hashCode ^
        createdId.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
