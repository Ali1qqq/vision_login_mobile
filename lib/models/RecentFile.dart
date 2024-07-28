import 'dart:math';

class RecentFile {
  final String? recId, provider,car, date, location;

  RecentFile({this.recId, this.provider, this.date, this.location, this.car});
}

List demoRecentFiles = [
  RecentFile(
    recId: "REC${Random().nextInt(99999999)}",
    provider: "SSC",
    car: "Mazda 210",
    date: "01-03-2021",
      location:"Al Qusaidat - Ras Al Khaimah"
  ),
  RecentFile(
    recId: "REC${Random().nextInt(99999999)}",
    provider: "Rak for car rental",
    car: "Toyota camry",
    date: "27-02-2021",
      location:"Al Nakheel - Ras Al Khaimah"
  ),
  RecentFile(
    recId: "REC${Random().nextInt(99999999)}",
    provider: "Al-safina",
    car: "BMW X5",

    date: "23-02-2021",
      location:"Downtown Dubai - Dubai"
  ),
  RecentFile(
    recId: "REC${Random().nextInt(99999999)}",
    provider: "SSC",
    car: "BMW X5",

    date: "21-02-2021",
      location:"Jumeirah - Dubai"
  ),
  RecentFile(
    recId: "REC${Random().nextInt(99999999)}",
    provider: "Al-safina",
    car: "BMW X5",

    date: "23-02-2021",
      location:"Al Majaz - Sharjah"
  ),
  RecentFile(
    recId: "assets/car_icon.png",
    provider: "AL-khor office",
    car: "Mazda 210",

    date: "25-02-2021",
      location:"Al Nahda - Sharjah"
  ),
  RecentFile(
    recId: "REC${Random().nextInt(99999999)}",
    provider: "AL-khor office",
    car: "Mazda 210",

    date: "25-02-2021",
      location:"Al Rashidiya - Ajman"
  ),
  RecentFile(
    recId: "assets/car_icon.png",
    provider: "AL-khor office",
    car: "Nisan maxima",

    date: "25-02-2021",
      location:"Al Mowaihat - Ajman"
  ),
  RecentFile(
    recId: "assets/car_icon.png",
    provider: "Rak for car rental",
    car: "Nisan maxima",

    date: "25-02-2021",
      location:"Al Salamah - Umm Al Quwain"
  ),
  RecentFile(
    recId: "assets/car_icon.png",
    provider: "Rak for car rental",
    car: "Nisan maxima",

    date: "25-02-2021",
      location:"Al Raas - Umm Al Quwain"
  ),
  RecentFile(
    recId: "assets/car_icon.png",
    provider: "Rak for car rental",
    car: "Fourd Mosting",

    date: "25-02-2021",
      location:"Al Maqta - Abu Dhabi"
  ),
  RecentFile(
    recId: "assets/car_icon.png",
    provider: "Rak for car rental",
    car: "Fourd Mosting",

    date: "25-02-2021",
      location:"Yas Island - Abu Dhabi"
  ),
  RecentFile(
    recId: "REC${Random().nextInt(99999999)}",
    provider: "Al-safina",
    car: "BMW X3",
    date: "25-02-2021",
      location:"Al Dhait South - Ras Al Khaimah"
  ),
  RecentFile(
    recId: "REC${Random().nextInt(99999999)}",
    provider: "Al-safina",
    car: "BMW X3",
    date: "25-02-2021",
      location:"Jebel Ali - Dubai"
  ),
  RecentFile(
      recId: "REC${Random().nextInt(99999999)}",
    provider: "Al-safina",
    car: "Toyota 2022",
    date: "23-02-2021",
      location:"Al Khan - Sharjah"
  ),
];
