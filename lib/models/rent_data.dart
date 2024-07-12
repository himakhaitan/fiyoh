class RentData {
  final String propertyId;
  final String propertyName;
  final String roomId;
  final String roomNumber;
  final int occupancy;
  final String roomStatus;
  final List<Map<String, String>> tenants;

  RentData({
    required this.propertyId,
    required this.roomId,
    required this.roomNumber,
    required this.occupancy,
    required this.roomStatus,
    required this.tenants,
    required this.propertyName,
  });
}