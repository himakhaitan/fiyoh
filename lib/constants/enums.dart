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

enum PropertyType {
  male,
  female,
  coliving
}

extension PropertyTypeExtension on PropertyType {
  String get value {
    switch (this) {
      case PropertyType.coliving:
        return 'COLIVING';
      case PropertyType.male:
        return 'MALE';
      case PropertyType.female:
        return 'FEMALE';
      default:
        return '';
    }
  }

  static PropertyType? fromString(String? value) {
    if (value == null) {
      return null;
    }
    // Handle capital and small case
    value = value.toUpperCase();
    switch (value) {
      case 'COLIVING':
        return PropertyType.coliving;
      case 'MALE':
        return PropertyType.male;
      case 'FEMALE':
        return PropertyType.female;
      default:
        return null;
    }
  }
}