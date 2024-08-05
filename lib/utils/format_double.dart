String formatDouble(double value) {
  // Convert the double to a string with two decimal places
  String formattedString = value.toStringAsFixed(2);

  // Split the string into integer and decimal parts
  List<String> parts = formattedString.split('.');
  String integerPart = parts[0];
  String decimalPart = parts[1];

  // Add commas to the integer part
  StringBuffer buffer = StringBuffer();
  for (int i = 0; i < integerPart.length; i++) {
    if (i != 0 && (integerPart.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(integerPart[i]);
  }

  // Combine the formatted integer part with the decimal part
  return '${buffer.toString()}.${decimalPart}';
}