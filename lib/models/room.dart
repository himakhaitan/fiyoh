
class Room {
  final String roomId;
  final int? occupancy;
  final int? floor;
  final String roomNumber;

  final List<Map<String, String>>? tenants;

  Room({
    required this.roomId,
    this.occupancy,
    this.floor,
    required this.roomNumber,
    this.tenants,
  });
}