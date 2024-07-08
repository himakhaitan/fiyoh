enum USERTYPE {
  OWNER,
  TENANT,
}

extension UserTypeExtension on USERTYPE {
  String get value {
    return toString().split('.').last;
  }
}