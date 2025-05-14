enum UserType { vendor, customer }

extension UserTypeExtension on UserType {
  String get value {
    switch (this) {
      case UserType.vendor:
        return 'vendor';
      case UserType.customer:
        return 'customer';
    }
  }

  static UserType fromString(String value) {
    switch (value) {
      case 'vendor':
        return UserType.vendor;
      case 'customer':
      default:
        return UserType.customer;
    }
  }
}
