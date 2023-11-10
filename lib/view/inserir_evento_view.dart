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
  TextEditingController nomeEventoController = TextEditingController();
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
              controller: nomeEventoController,
              decoration: InputDecoration(labelText: 'Nome do Evento'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: TextEditingController(
                  text: dataEvento != null && horarioEvento != null
                      ? "${_formatarDataHora(dataEvento!, horarioEvento!)}"
                      : ''),
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
                    _salvarEvento();
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

  // Função para selecionar o horário
  Future<void> _selecionarHorario() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        horarioEvento = pickedTime;
      });
    }
  }

  void _salvarEvento() {
    salvarEvento(
      context,
      txtTitulo: nomeEventoController.text,
      txtDescricao: localEventoController.text,
      dataEvento: dataEvento,
      horarioEvento: horarioEvento,
      eventoPago: eventoPago,
    );
    Navigator.pop(context);
  }

  String _formatarDataHora(DateTime data, TimeOfDay hora) {
    return "${data.day}/${data.month}/${data.year} ${hora.hour}:${hora.minute}";
  }
}

void salvarEvento(context,
    {docId,
    String? txtTitulo,
    String? txtDescricao,
    DateTime? dataEvento,
    TimeOfDay? horarioEvento,
    String? localEvento,
    bool? eventoPago}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Adicionar Evento"),
        content: SizedBox(
          height: 250,
          width: 300,
          child: Column(
            children: [
              TextField(
                controller: TextEditingController(text: txtTitulo),
                decoration: InputDecoration(
                  labelText: 'Título',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: TextEditingController(text: txtDescricao),
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actionsPadding: EdgeInsets.fromLTRB(20, 0, 20, 10),
        actions: [
          TextButton(
            child: Text("fechar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: Text("salvar"),
            onPressed: () {
              var e = Evento(
                LoginController().idUsuario(),
                txtTitulo ?? '',
                txtDescricao ?? '',
                dataEvento ?? DateTime.now(),
                horarioEvento ?? TimeOfDay.now(),
                localEvento ?? '',
                eventoPago ?? false,
              );
              if (docId == null) {
                EventoController().adicionar(context, e);
              } else {
                EventoController().atualizar(context, docId, e);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
