enum USER {
  OWNER,
  TENANT,
}

extension UserExtension on USER {
  String get value {
    return toString().split('.').last;
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
}