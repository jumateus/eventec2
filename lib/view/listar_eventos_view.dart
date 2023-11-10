// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventec_firebase/controller/evento_controller.dart';
import 'package:eventec_firebase/view/inserir_evento_view.dart';
import 'package:flutter/material.dart';

class ListarEventosView extends StatelessWidget {
  ListarEventosView({Key? key});
  var txtTitulo = TextEditingController();
  var txtDescricao = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: EventoController().listar().snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Text('Não foi possível conectar.'),
                );
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                final dados = snapshot.requireData;
                if (dados.size > 0) {
                  return ListView.builder(
                    itemCount: dados.size,
                    itemBuilder: (context, index) {
                      String id = dados.docs[index].id;
                      dynamic item = dados.docs[index].data();
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.description),
                          title: Text(item['titulo']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Descrição: ${item['descricao']}'),
                              Text('Data: ${_formatarData(item['data'])}'),
                              Text('Horário: ${_formatarHorario(item['horario'])}'),
                              Text('Local: ${item['local']}'),
                              Text('Pago: ${item['eventoPago'] ? 'Sim' : 'Não'}'),
                            ],
                          ),
                          onTap: () {
                            txtTitulo.text = item['titulo'];
                            txtDescricao.text = item['descricao'];
                            salvarEvento(context, docId: id);
                          },
                          onLongPress: () {
                            EventoController().excluir(context, id);
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text('Nenhum evento encontrado.'),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  String _formatarData(String data) {
    DateTime dateTime = DateTime.parse(data);
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  String _formatarHorario(String horario) {
    List<String> partes = horario.split(':');
    return "${partes[0]}:${partes[1]}";
  }
}
