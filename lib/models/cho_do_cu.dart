import 'package:uuid/uuid.dart';

const uuid = Uuid();

class DoCu {
  DoCu(
      {required this.date,
      required this.time,
      required this.name,
      required this.price,
      required this.description,
      String? id})
      : id = id ?? uuid.v4();

  final String date;
  final String time;
  final String name;
  final String price;
  final String description;
  final String id;
}
