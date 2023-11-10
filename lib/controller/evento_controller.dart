import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/evento.dart';
import '../view/util.dart';
//import 'login_controller.dart';

class EventoController {

  void adicionar(context, Evento e) {
  FirebaseFirestore.instance
    .collection('eventos')
    .add(e.toJson())
    .then((value) => sucesso(context, 'Evento adicionado com sucesso'))
    .catchError((e) => erro(context, 'Não foi possível adicionar o evento.'))
    .whenComplete(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    });
}

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

void excluir(context, id, String idUsuarioLogado) {
  FirebaseFirestore.instance
      .collection('eventos')
      .doc(id)
      .get()
      .then((evento) {
        if (evento.exists && evento['uid'] == idUsuarioLogado) {
          // O evento foi criado pelo usuário logado, pode ser excluído
          FirebaseFirestore.instance
              .collection('eventos')
              .doc(id)
              .delete()
              .then((value) => sucesso(context, 'Evento excluído com sucesso'))
              .catchError((e) => erro(context, 'Não foi possível excluir o evento.'));
        } else {
          // O evento não foi criado pelo usuário logado, exiba uma mensagem ou faça algo apropriado
          erro(context, 'Você não tem permissão para excluir este evento.');
        }
      })
      .catchError((e) => erro(context, 'Não foi possível verificar o evento.'));
}


  listar() {
    return FirebaseFirestore.instance
        .collection('eventos');
        //.where('uid', isEqualTo: LoginController().idUsuario());
  }
}
