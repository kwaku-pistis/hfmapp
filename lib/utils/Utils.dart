import 'package:intl/intl.dart';

String timeConverter(int unix) {
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(unix);
  var formattedTime = DateFormat('H:mm').format(date);
  // return '${date.hour}:${date.minute}';
  return formattedTime;
}
