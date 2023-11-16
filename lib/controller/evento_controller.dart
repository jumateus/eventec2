// ignore_for_file: invalid_return_type_for_catch_error

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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    });
}

void atualizar(context, Evento eventoAtualizado, String idUsuarioLogado) {
  FirebaseFirestore.instance
      .collection('eventos')
      .doc(eventoAtualizado.uid)
      .get()
      .then((evento) {
        if (evento.exists) {
          // Check if the event was created by the user currently logged in
          if (evento['uidUsuario'] == idUsuarioLogado) {
            // The event was created by the user logged in, allow update
            FirebaseFirestore.instance
                .collection('eventos')
                .doc(eventoAtualizado.uid)
                .update(eventoAtualizado.toJson())
                .then((value) => sucesso(context, 'Evento atualizado com sucesso'))
                .catchError((e) => erro(context, 'Não foi possível atualizar o evento.'));
          } else {
            // The event was not created by the user logged in, display a message or take appropriate action
            erro(context, 'Você não tem permissão para atualizar este evento.');
          }
        } else {
          // The event does not exist, display a message or take appropriate action
          erro(context, 'Evento não encontrado.');
        }
      })
      .catchError((e) => erro(context, 'Não foi possível verificar o evento.'));
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

Future<Evento> carregarDetalhesEvento(String idEvento, String uidUsuarioLogado) async {
  DocumentSnapshot eventoSnapshot = await FirebaseFirestore.instance
      .collection('eventos')
      .doc(idEvento)
      .get();

  if (eventoSnapshot.exists) {
    // Criar uma instância de Evento a partir dos dados do Firestore
    Map<String, dynamic> dadosEvento = eventoSnapshot.data() as Map<String, dynamic>;
    return Evento(
      uid: dadosEvento['uid'],
      uidUsuario: uidUsuarioLogado,
      titulo: dadosEvento['titulo'],
      descricao: dadosEvento['descricao'],
      data: DateTime.parse(dadosEvento['data']),
      horario: _parseHorario(dadosEvento['horario']),
      local: dadosEvento['local'],
      eventoPago: dadosEvento['eventoPago'],
    );
  } else {
    // Se o evento não existir, você pode retornar null ou lançar uma exceção, conforme sua lógica de aplicativo
    return Future.error('Evento não encontrado.');
  }
}


  static TimeOfDay _parseHorario(String horario) {
    List<String> parts = horario.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

}
