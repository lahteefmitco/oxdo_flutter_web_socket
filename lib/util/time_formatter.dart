import 'package:intl/intl.dart';

String formatTime(DateTime dateTime){
  return DateFormat('hh:mm a').format(dateTime);
}