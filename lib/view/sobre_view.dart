import 'package:flutter/material.dart';

class SobreView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre os integrantes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPersonCard('André Filipe', 'RA 2840 4822 13006', 'https://cdn-icons-png.flaticon.com/512/3884/3884851.png'),
            SizedBox(height: 20),
            _buildPersonCard('Julia Mateus', 'RA 2840 4822 13031', 'https://cdn-icons-png.flaticon.com/512/3532/3532661.png'),
            SizedBox(height: 30),
            Text(
              'O EvenTec, um aplicativo multiplataforma para eventos acadêmicos da FATEC-RP. '
              'Ele serve para visualizar e cadastrar eventos relacionados à unidade de Ribeirão Preto.'
              'Em resumo, o EvenTec otimiza a experiência acadêmica ao consolidar informações no app e facilitar a participação em eventos universitários.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonCard(String nome, String ra, String imageUrl) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(imageUrl),
            ),
            SizedBox(height: 10),
            Text(nome),
            Text(ra),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SobreView(),
  ));
}