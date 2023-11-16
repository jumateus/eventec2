import 'package:eventec_firebase/controller/evento_controller.dart';
import 'package:eventec_firebase/controller/login_controller.dart';
import 'package:eventec_firebase/model/evento.dart';
import 'package:eventec_firebase/view/util.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: InserirEventoView(),
  ));
}

class InserirEventoView extends StatefulWidget {
  @override
  _InserirEventoViewState createState() => _InserirEventoViewState();
}

class _InserirEventoViewState extends State<InserirEventoView> {
  TextEditingController tituloEventoController = TextEditingController();
  TextEditingController descricaoEventoController = TextEditingController();
  DateTime? dataEvento;
  TimeOfDay? horarioEvento;
  TextEditingController localEventoController = TextEditingController();
  bool eventoPago = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inserir Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: tituloEventoController,
              decoration: InputDecoration(labelText: 'Título do Evento'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descricaoEventoController,
              decoration: InputDecoration(labelText: 'Descrição do Evento'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: TextEditingController(
                text: dataEvento != null && horarioEvento != null
                    ? "${_formatarDataHora(dataEvento!, horarioEvento!)}"
                    : '',
              ),
              decoration: InputDecoration(labelText: 'Data do Evento'),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != DateTime.now()) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      dataEvento = pickedDate;
                      horarioEvento = pickedTime;
                    });
                  }
                }
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: localEventoController,
              decoration: InputDecoration(labelText: 'Local do Evento'),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Evento Pago'),
                Checkbox(
                  value: eventoPago,
                  onChanged: (value) {
                    setState(() {
                      eventoPago = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    salvarEvento(
                      context,
                      tituloEvento: tituloEventoController.text,
                      descricaoEvento: descricaoEventoController.text,
                      dataEvento: dataEvento,
                      horarioEvento: horarioEvento,
                      localEvento: localEventoController.text,
                      eventoPago: eventoPago,
                    );
                  },
                  child: Text('OK'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to the previous page
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

String _formatarDataHora(DateTime data, TimeOfDay hora) {
    return "${data.day}/${data.month}/${data.year} ${hora.hour}:${hora.minute}";
  }
}

void salvarEvento(context,
    {docId,
    String? tituloEvento,
    String? descricaoEvento,
    DateTime? dataEvento,
    TimeOfDay? horarioEvento,
    String? localEvento,
    bool? eventoPago}) async {
  try {
    var e = Evento(
      uid: LoginController().idUsuario(),
      uidUsuario: LoginController().idUsuario(),
      titulo: tituloEvento ?? '',
      descricao: descricaoEvento ?? '',
      data: dataEvento ?? DateTime.now(),
      horario: horarioEvento ?? TimeOfDay.now(),
      local: localEvento ?? '',
      eventoPago: eventoPago ?? false,
    );

    if (docId == null) {
      EventoController().adicionar(context, e);
      sucesso(context, 'Evento adicionado com sucesso');
    } else {
      // Obtenha o evento existente do Firestore para verificar o UID do usuário
      Evento eventoExistente = await EventoController().carregarDetalhesEvento(docId, LoginController().idUsuario());

      if (eventoExistente.uidUsuario == LoginController().idUsuario()) {
        // O usuário logado é o criador do evento, permita a edição
        EventoController().atualizar(context, docId, e.toJson() as String);
        sucesso(context, 'Evento atualizado com sucesso');
      } else {
        // O usuário logado não é o criador do evento, não permita a edição
        erro(context, 'Você não tem permissão para editar este evento.');
      }
    }

    Navigator.of(context).pop();
  } catch (e) {
    erro(context, 'Erro ao salvar o evento: $e');
  }
}
