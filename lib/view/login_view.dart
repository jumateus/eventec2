// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import '../controller/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var txtEmail = TextEditingController();
  var txtSenha = TextEditingController();
  var txtEmailEsqueceuSenha = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30, 50, 30, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ícone de login
                Icon(
                  Icons.school,
                  size: 150.0,
                  color: Colors.blue,
                ),
                // Legenda "EvenTec"
                Text(
                  'EvenTec',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 30), // Adjust the spacing as needed
                SizedBox(height: 60),
                TextField(
                  controller: txtEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: txtSenha,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'cadastrar');
                      },
                      child: Text('Cadastre-se'),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Esqueceu a senha?"),
                              content: Container(
                                height: 150,
                                child: Column(
                                  children: [
                                    Text(
                                      "Identifique-se para receber um e-mail com as instruções e o link para criar uma nova senha.",
                                    ),
                                    SizedBox(height: 25),
                                    TextField(
                                      controller: txtEmailEsqueceuSenha,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        prefixIcon: Icon(Icons.email),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actionsPadding: EdgeInsets.all(20),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    LoginController().esqueceuSenha(
                                      context,
                                      txtEmailEsqueceuSenha.text,
                                    );
                                  },
                                  child: Text('enviar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Esqueceu a senha?'),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 40),
                  ),
                  onPressed: () {
                    LoginController().login(
                      context,
                      txtEmail.text,
                      txtSenha.text,
                    );
                  },
                  child: Text('Entrar'),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
