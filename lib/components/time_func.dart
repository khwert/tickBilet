import 'package:intl/intl.dart';

DateTime convertToDateTime(String time) {
  return DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
}

String calculateTimeDifference(String departureTime, String arrivalTime) {
  DateTime depTime = convertToDateTime(departureTime);
  DateTime arrTime = convertToDateTime(arrivalTime);

  Duration difference = arrTime.difference(depTime);

  if (difference.inDays > 0) {
    return '${difference.inDays} Gün';
  }

  return '(${difference.inHours} Saat ${difference.inMinutes % 60} Dakika)*';
}

String formatTime(String dateTime) {
  try {
    DateTime parsedTime = DateTime.parse(dateTime);
    return DateFormat.Hm().format(parsedTime);
  } catch (e) {
    return dateTime;
  }
}
