import 'package:intl/intl.dart';

String formatTime12(String time24) {
  final format24 = DateFormat("HH:mm");
  final dateTime = format24.parse(time24);
  return DateFormat("h:mm a").format(dateTime);
}
