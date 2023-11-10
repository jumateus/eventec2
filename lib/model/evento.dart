import 'package:flutter/material.dart';

class Evento {
  final String uid;
  final String uidUsuario;
  final String titulo;
  final String descricao;
  DateTime data;
  TimeOfDay horario;
  String local;
  bool eventoPago;

  Evento({
    required this.uid,
    required this.uidUsuario,
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.horario,
    required this.local,
    required this.eventoPago,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
      'uidUsuario': uidUsuario,
      'titulo': titulo,
      'descricao': descricao,
      'data': data.toIso8601String(),
      'horario': '${horario.hour}:${horario.minute}',
      'local': local,
      'eventoPago': eventoPago,
    };
  }

  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      uid: json['uid'],
      uidUsuario: json['uidUsuario'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      data: DateTime.parse(json['data']),
      horario: _parseHorario(json['horario']),
      local: json['local'],
      eventoPago: json['eventoPago'],
    );
  }

  static TimeOfDay _parseHorario(String horario) {
    List<String> parts = horario.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
