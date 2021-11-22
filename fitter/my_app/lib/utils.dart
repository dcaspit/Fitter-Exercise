import 'package:intl/intl.dart';

class Utils{
  static String toDateTime(DateTime dateTime){
    return toDate(dateTime) + toTime(dateTime);
  }

  static String toDate(DateTime dateTime){
    return DateFormat.yMMMEd().format(dateTime);
  }

  static String toTime(DateTime dateTime){
    return DateFormat.Hm().format(dateTime);
  }
}