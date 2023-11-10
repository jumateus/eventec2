import 'package:flutter/material.dart';

class Evento {
  final String uid;
  final String titulo;
  final String descricao;
  DateTime data;
  TimeOfDay horario;
  String local;
  bool eventoPago;

  Evento(
    this.uid,
    this.titulo,
    this.descricao,
    this.data,
    this.horario,
    this.local,
    this.eventoPago,
  );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'uid': uid,
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
      json['uid'],
      json['titulo'],
      json['descricao'],
      DateTime.parse(json['data']),
      _parseHorario(json['horario']),
      json['local'],
      json['eventoPago'],
    );
  }

  static TimeOfDay _parseHorario(String horario) {
    List<String> parts = horario.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}