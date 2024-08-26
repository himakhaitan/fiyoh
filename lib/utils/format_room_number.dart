String formatRoomNumber(int roomNumber) {
  // Convert roomNumber to string
  String roomNumberString = roomNumber.toString();

  // Check if the string length is less than 3
  if (roomNumberString.length < 3) {
    // Pad with zeros to make it at least 3 characters long
    roomNumberString = roomNumberString.padLeft(3, '0');
  }

  // Return the formatted room number string
  return roomNumberString;
}
