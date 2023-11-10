import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/evento.dart';
import '../view/util.dart';
import 'login_controller.dart';

class EventoController {
  //
  // ADICIONAR uma nova Tarefa
  //
  void adicionar(context, Evento e) {
    FirebaseFirestore.instance
        .collection('eventos')
        .add(e.toJson())
        .then((value) => sucesso(context, 'Evento adicionado com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível adicionar o evento.'))
        .whenComplete(() => Navigator.pop(context));
  }

  //
  // ATUALIZAR
  //
  void atualizar(context, id, Evento e) {
    FirebaseFirestore.instance
        .collection('eventos')
        .doc(id)
        .update(e.toJson())
        .then((value) => sucesso(context, 'Evento atualizado com sucesso'))
        .catchError(
            (e) => erro(context, 'Não foi possível atualizar o evento.'))
        .whenComplete(() => Navigator.pop(context));
  }

  //
  // EXCLUIR
  //
  void excluir(context, id) {
    FirebaseFirestore.instance
        .collection('eventos')
        .doc(id)
        .delete()
        .then((value) => sucesso(context, 'Evento excluído com sucesso'))
        .catchError((e) => erro(context, 'Não foi possível excluir o evento.'));
  }

  //
  // LISTAR todas as Tarefas da coleção
  //
  listar() {
    return FirebaseFirestore.instance
        .collection('eventos')
        .where('uid', isEqualTo: LoginController().idUsuario());
  }
}
