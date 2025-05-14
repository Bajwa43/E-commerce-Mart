// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? userId;
  String? fullName;
  String? email;
  String? phone;
  String? password;
  String? business;
  String? textRegistered;
  String? gstNumber;
  String? address;
  String? userType;
  bool? approved;
  String? city;
  String? imageUrl;
  String? shopImageUrl;
  String? logoUrl;
  UserModel({
    this.userId,
    this.fullName,
    this.email,
    this.phone,
    this.password,
    this.business,
    this.textRegistered,
    this.gstNumber,
    this.address,
    this.userType,
    this.approved,
    this.city,
    this.imageUrl,
    this.shopImageUrl,
    this.logoUrl,
  });

  UserModel copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? phone,
    String? password,
    String? business,
    String? textRegistered,
    String? gstNumber,
    String? address,
    String? userType,
    bool? approved,
    String? city,
    String? imageUrl,
    String? shopImageUrl,
    String? logoUrl,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      business: business ?? this.business,
      textRegistered: textRegistered ?? this.textRegistered,
      gstNumber: gstNumber ?? this.gstNumber,
      address: address ?? this.address,
      userType: userType ?? this.userType,
      approved: approved ?? this.approved,
      city: city ?? this.city,
      imageUrl: imageUrl ?? this.imageUrl,
      shopImageUrl: shopImageUrl ?? this.shopImageUrl,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'business': business,
      'textRegistered': textRegistered,
      'gstNumber': gstNumber,
      'address': address,
      'userType': userType,
      'approved': approved,
      'city': city,
      'imageUrl': imageUrl,
      'shopImageUrl': shopImageUrl,
      'logoUrl': logoUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] != null ? map['userId'] as String : null,
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      business: map['business'] != null ? map['business'] as String : null,
      textRegistered: map['textRegistered'] != null
          ? map['textRegistered'] as String
          : null,
      gstNumber: map['gstNumber'] != null ? map['gstNumber'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      userType: map['userType'] != null ? map['userType'] as String : null,
      approved: map['approved'] != null ? map['approved'] as bool : null,
      city: map['city'] != null ? map['city'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      shopImageUrl:
          map['shopImageUrl'] != null ? map['shopImageUrl'] as String : null,
      logoUrl: map['logoUrl'] != null ? map['logoUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(userId: $userId, fullName: $fullName, email: $email, phone: $phone, password: $password, business: $business, textRegistered: $textRegistered, gstNumber: $gstNumber, address: $address, userType: $userType, approved: $approved, city: $city, imageUrl: $imageUrl, shopImageUrl: $shopImageUrl, logoUrl: $logoUrl)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.fullName == fullName &&
        other.email == email &&
        other.phone == phone &&
        other.password == password &&
        other.business == business &&
        other.textRegistered == textRegistered &&
        other.gstNumber == gstNumber &&
        other.address == address &&
        other.userType == userType &&
        other.approved == approved &&
        other.city == city &&
        other.imageUrl == imageUrl &&
        other.shopImageUrl == shopImageUrl &&
        other.logoUrl == logoUrl;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        fullName.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        password.hashCode ^
        business.hashCode ^
        textRegistered.hashCode ^
        gstNumber.hashCode ^
        address.hashCode ^
        userType.hashCode ^
        approved.hashCode ^
        city.hashCode ^
        imageUrl.hashCode ^
        shopImageUrl.hashCode ^
        logoUrl.hashCode;
  }
}
