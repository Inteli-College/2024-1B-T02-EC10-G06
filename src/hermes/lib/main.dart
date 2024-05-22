import 'package:flutter/material.dart';
import 'package:hermes/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hermes/services/notifi.dart';
import 'package:hermes/qr_code.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hermes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MinhaPrimeiraTela(),
    );
  }
}

class MinhaPrimeiraTela extends StatelessWidget {
  const MinhaPrimeiraTela({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/hermes.png'), // Substitua 'background_image.jpg' pelo nome do seu arquivo de imagem
            fit: BoxFit.cover, // Cobrir toda a tela
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: const <Widget>[
                  Text("Hermes",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Gerenciamento de medicamentos com qualidade dos Deuses',
                  style: TextStyle(
                    fontSize: 20.0, // Ajuste o tamanho da fonte conforme necessário
                    fontWeight: FontWeight.w400, // Fonte mais leve
                  ),
                  textAlign: TextAlign.center, // Centraliza o texto dentro do Text widget
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text("Vamos começar"),
                  ),
                ],
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Scan QR Code'),
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QRCodePage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              ]
          ),
        ),
      );
  }
}
