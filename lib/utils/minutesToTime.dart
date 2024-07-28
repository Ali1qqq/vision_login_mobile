import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:intl/intl.dart';

abstract class DateFun{
  static String minutesToTime(int time){
    return  printDuration(Duration(minutes:time),locale:ArabicDurationLocale(),delimiter: " و " );
  }
  static String dateToMinAndHour(DateTime dateTime) {
    final format = DateFormat('hh:mm a');

    String formattedTime = format.format(dateTime);


    if (formattedTime.contains('AM')) {
      formattedTime = formattedTime.replaceAll('AM', 'صباحاً');
    } else if (formattedTime.contains('PM')) {
      formattedTime = formattedTime.replaceAll('PM', 'مساءً');
    }

    return formattedTime;
  }
}