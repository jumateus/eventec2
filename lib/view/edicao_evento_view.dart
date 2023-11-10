// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'package:eventec_firebase/view/util.dart';
import 'package:flutter/material.dart';
import 'package:eventec_firebase/controller/evento_controller.dart';
import 'package:eventec_firebase/model/evento.dart';

class EditarEventoView extends StatefulWidget {
  final String idEvento;
  final String uidUsuarioLogado;

  EditarEventoView({required this.idEvento, required this.uidUsuarioLogado});

  @override
  _EditarEventoViewState createState() => _EditarEventoViewState();
}

class _EditarEventoViewState extends State<EditarEventoView> {
  TextEditingController tituloController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController horarioController = TextEditingController();
  TextEditingController localController = TextEditingController();
  TextEditingController eventoPagoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Carregar os detalhes do evento ao iniciar a tela
    carregarDetalhesEvento();
  }

  void carregarDetalhesEvento() async {
    try {
      // Use o idEvento da propriedade do widget para carregar os detalhes do evento
      Evento evento = await EventoController().carregarDetalhesEvento(widget.idEvento, widget.uidUsuarioLogado);
      setState(() {
        // Preencha os controladores com os detalhes do evento
        tituloController.text = evento.titulo;
        descricaoController.text = evento.descricao;
        dataController.text = _formatarData(evento.data);
        horarioController.text = _formatarHorario(evento.horario);
        localController.text = evento.local;
        eventoPagoController.text = evento.eventoPago.toString();
      });
    } catch (e) {
      // Tratar erros, exibir mensagem ou fazer algo apropriado
      erro(context,'Erro ao carregar detalhes do evento: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: tituloController,
              decoration: InputDecoration(labelText: 'Título do Evento'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição do Evento'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: dataController,
              decoration: InputDecoration(labelText: 'Data do Evento'),
              readOnly: true,
              onTap: () async {
                // Implemente a lógica para selecionar a data
                // Pode usar showDatePicker, por exemplo
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: horarioController,
              decoration: InputDecoration(labelText: 'Horário do Evento'),
              readOnly: true,
              onTap: () async {
                // Implemente a lógica para selecionar o horário
                // Pode usar showTimePicker, por exemplo
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: localController,
              decoration: InputDecoration(labelText: 'Local do Evento'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: eventoPagoController,
              decoration: InputDecoration(labelText: 'Evento Pago'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Salvar as alterações no evento
          salvarAlteracoesEvento();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  String _formatarData(DateTime data) {
    return "${data.day}/${data.month}/${data.year}";
  }

  String _formatarHorario(TimeOfDay horario) {
    return "${horario.hour}:${horario.minute}";
  }

void salvarAlteracoesEvento() {
  // Criar um novo objeto Evento com as alterações
  Evento eventoAtualizado = Evento(
    uid: widget.idEvento,
    uidUsuario: widget.uidUsuarioLogado,  // Adicione o uid do usuário logado
    titulo: tituloController.text,
    descricao: descricaoController.text,
    data: DateTime.now(),
    horario: TimeOfDay.now(),
    local: localController.text,
    eventoPago: eventoPagoController.text.toLowerCase() == 'true',
  );

  // Chamar o método de atualização no EventoController
  EventoController().atualizar(context, eventoAtualizado, widget.uidUsuarioLogado);
}

}