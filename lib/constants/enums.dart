enum USER_TYPE {
  OWNER,
  TENANT,
}

extension UserTypeExtension on USER_TYPE {
  String get value {
    return toString().split('.').last;
  }

  static USER_TYPE fromString(String user) {
    return USER_TYPE.values.firstWhere((e) => e.value == user);
  }
}

enum BOOKING_STATUS {
  PENDING,
  CONFIRMED,
  CANCELLED,
  CHECKED_IN,
  CHECKED_OUT,
}

extension BookingStatusExtension on BOOKING_STATUS {
  String get value {
    return toString().split('.').last;
  }

  static BOOKING_STATUS fromString(String status) {
    return BOOKING_STATUS.values.firstWhere((e) => e.value == status);
  }
}
