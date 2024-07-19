// Type: User Enum
enum UserType {
  owner,
  manager,
}

// Type: User Enum Extension
extension UserTypeExtension on UserType {
  // Get the value of the enum
  String get value {
    switch (this) {
      case UserType.owner:
        return 'OWNER';
      case UserType.manager:
        return 'MANAGER';
      default:
        return '';
    }
  }

  // Get the enum from the value
  static UserType? fromString(String? value) {
    if (value == null) {
      return null;
    }
    switch (value) {
      case 'OWNER':
        return UserType.owner;
      case 'MANAGER':
        return UserType.manager;
      default:
        return null;
    }
  }
}
