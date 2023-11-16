import 'package:eventec_firebase/view/config_view.dart';
import 'package:eventec_firebase/view/inserir_evento_view.dart';
import 'package:eventec_firebase/view/listar_eventos_view.dart';
import 'package:eventec_firebase/view/sobre_view.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/login_controller.dart';
import '../controller/evento_controller.dart';
import '../model/evento.dart';

class PrincipalView extends StatefulWidget {
  const PrincipalView({Key? key}) : super(key: key);

  @override
  State<PrincipalView> createState() => _PrincipalViewState();
}

class _PrincipalViewState extends State<PrincipalView> {
  var txtTitulo = TextEditingController();
  var txtDescricao = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Principal'),
        actions: [
          PopupMenuButton<int>(
            offset: Offset(0, 57),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: FutureBuilder<String>(
                  future: LoginController().usuarioLogado(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Text(
                        snapshot.data.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      );
                    }
                    return Text('');
                  },
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem<int>(
                value: 1,
                child: Text('Configurações'),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text('Listar Eventos'),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Text('Inserir Evento'),
              ),
              PopupMenuItem<int>(
                value: 4,
                child: Text('Sobre'),
              ),
              PopupMenuItem<int>(
                value: 5,
                child: Text('Sair'),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ConfigView()));
                  break;
                case 2:
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListarEventosView()));
                  break;
                case 3:
                  Navigator.push(context, MaterialPageRoute(builder: (context) => InserirEventoView()));
                  break;
                case 4:
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SobreView()));
                  break;
                case 5:
                  LoginController().logout();
                  Navigator.pushReplacementNamed(context, 'login');
                  break;
              }
            },
          ),
        ],
      ),

      // BODY
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          buildImageCard('Increva-se já para o vestibular da FATEC de Ribeirão Preto! As inscrições vão até 12/12, compartilhe o máximo que puder!', 'assets/vestibular.png'),
          SizedBox(height: 20.0),
          buildImageCard('Huuuum, 2024 vai nos trazer um novo curso! Que tal saber mais sobre esse curso? Venha conhecer!', 'assets/novocurso.png'),
          SizedBox(height: 20.0),
          buildImageCard('Alunos de todos os cursos e todos os semestres...Já responderam o Websai?\nAinda não? Não perca tempo, responda o quanto antes, ajuda muito!', 'assets/websai.png'),
        ],
      ),
    );
  }

  Widget buildImageCard(String description, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5.0,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            child: Image.asset(
              imagePath,
              fit: BoxFit.fitWidth,
              height: 100.0,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              description,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
