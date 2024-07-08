enum USER {
  OWNER,
  TENANT,
}

extension UserExtension on USER {
  String get value {
    return toString().split('.').last;
  }
}