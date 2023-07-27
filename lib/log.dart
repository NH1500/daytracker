import 'package:cloud_firestore/cloud_firestore.dart';

class Log {
  String id;
  final int productivity;
  final int happiness;
  final DateTime date;
  final bool gym;
  final String note;

  Log(
      {this.id = '',
      required this.productivity,
      required this.happiness,
      required this.date,
      required this.gym,
      required this.note});

  Map<String, dynamic> toJson() => {
        'id': id,
        'productivity': productivity,
        'happiness': happiness,
        'date': date,
        'gym': gym,
        'note': note,
      };

  static Log fromJson(Map<String, dynamic> json) => Log(
      productivity: json['productivity'],
      happiness: json['happiness'],
      date: (json['date'] as Timestamp).toDate(),
      gym: json['gym'],
      note: json['note']);
}
