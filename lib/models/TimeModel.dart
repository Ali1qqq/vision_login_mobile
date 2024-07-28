import 'package:intl/intl.dart';

class TimesModel {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int seconds;
  final int milliSeconds;
  final DateTime dateTime;
  final String date;
  // final String time;
  final String timeZone;
  final String dayOfWeek;
  // final bool dstActive;

  TimesModel({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.minute,
    required this.seconds,
    required this.milliSeconds,
    required this.dateTime,
    required this.date,
    // required this.time,
    required this.timeZone,
    required this.dayOfWeek,
    // required this.dstActive,
  });

  factory TimesModel.fromJson(Map<String, dynamic> json) {
    return TimesModel(
      year: DateTime.parse(json['datetime']).toLocal().year,
      month: DateTime.parse(json['datetime']).toLocal().month,
      day:DateTime.parse(json['datetime']).toLocal().day,
      // day: 19,
      hour: DateTime.parse(json['datetime']).toLocal().hour ,
      minute: DateTime.parse(json['datetime']).toLocal().minute,
      seconds: DateTime.parse(json['datetime']).toLocal().second,
      milliSeconds: DateTime.parse(json['datetime']).toLocal().millisecond,
      dateTime: DateTime.parse(json['datetime']).toLocal(),
      date: json['datetime'].toString().split("T")[0],
      // time: json['time'],
      timeZone: json['utc_offset'],
      dayOfWeek: json['day_of_week'].toString(),
      // dstActive: json['dst'],
    );
  }
  String get formattedTime {
    final dateTime = DateTime(year, month, day,/* hour, minute, seconds, milliSeconds*/);
    final format = DateFormat('yyyy-MM-dd');
    return format.format(dateTime);
  }
  bool isAfter(int hours,int mints) {
    final dateTime = DateTime(year, month, day, hour, minute, seconds, milliSeconds);
    final targetTime = DateTime(year, month, day, hours, mints);
    return dateTime.isAfter(targetTime);
  }
  bool isBefore(int hours,int mints) {
    final dateTime = DateTime(year, month, day, hour, minute, seconds, milliSeconds);
    final targetTime = DateTime(year, month, day, hours, mints);
    return dateTime.isBefore(targetTime);
  }

}