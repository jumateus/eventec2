import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ConfigView(),
  ));
}

class ConfigView extends StatefulWidget {
  @override
  _ConfigViewState createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  TextEditingController _nomedeusuarioController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alterações de Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomedeusuarioController,
              decoration: InputDecoration(labelText: 'Nome de Usuário'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _saveChanges(context);
                  },
                  child: Text('Salvar Alterações'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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

 void _saveChanges(BuildContext context) {
    String nomeUsuario = _nomedeusuarioController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Verifica se pelo menos um campo foi preenchido
    if (nomeUsuario.isEmpty && email.isEmpty && password.isEmpty) {
      _showDialog('Campos vazios', 'Pelo menos um campo deve ser preenchido.');
    } else {
      // Salvar alterações (pode ser uma chamada de API, salvar em um banco de dados, etc.)

      // Exibir Snackbar de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Alterações salvas com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Voltar para a tela anterior
      Navigator.of(context).pop();
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
