// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

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
  const PrincipalView({super.key});

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
        title: Row(
          children: [
            Expanded(child: Text('Menu Principal')),
            FutureBuilder<String>(
              future: LoginController().usuarioLogado(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {
                        LoginController().logout();
                        Navigator.pushReplacementNamed(context, 'login');
                      },
                      icon: Icon(Icons.exit_to_app, size: 14),
                      label: Text(snapshot.data.toString()),
                    ),
                  );
                }
                return Text('');
              },
            ),
          ],
        ),
      ),

      // BODY
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          padding: EdgeInsets.all(16.0),
          childAspectRatio: 1.0,
          children: [
            buildIconButton(context, Icons.settings, Colors.brown, ConfigView()),
            buildIconButton(context, Icons.event, Colors.red, ListarEventosView()),
            buildIconButton(context, Icons.list, Colors.blueAccent, InserirEventoView()),
            buildIconButton(context, Icons.info, Colors.indigo, SobreView()),
          ],
        ),
      ),
    );
  }

  Widget buildIconButton(BuildContext context, IconData iconData, Color iconColor, Widget destinationScreen) {
    return IconButton(
      icon: Icon(
        iconData,
        size: 50.0,
        color: iconColor,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen),
        );
      },
    );
  }
}
