import 'package:eventec_firebase/controller/evento_controller.dart';
import 'package:eventec_firebase/controller/login_controller.dart';
import 'package:eventec_firebase/model/evento.dart';
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
      LoginController().idUsuario(),
      tituloEvento ?? '',
      descricaoEvento ?? '',
      dataEvento ?? DateTime.now(),
      horarioEvento ?? TimeOfDay.now(),
      localEvento ?? '',
      eventoPago ?? false,
    );

    if (docId == null) {
      EventoController().adicionar(context, e);
      _mostrarSnackBar(context, 'Evento adicionado com sucesso');
    } else {
       EventoController().atualizar(context, docId, e);
      _mostrarSnackBar(context, 'Evento atualizado com sucesso');
    }

    Navigator.of(context).pop();
  } catch (e) {
    _mostrarSnackBar(context, 'Erro ao salvar o evento');
  }
}

void _mostrarSnackBar(BuildContext context, String mensagem) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensagem),
      duration: Duration(seconds: 2),
    ),
  );
}

