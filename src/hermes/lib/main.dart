import 'package:flutter/material.dart';
import 'package:hermes/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hermes/services/notification.dart';
import 'package:hermes/qr_code.dart';
import 'package:hermes/pyxis_pedido.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    NotificationService.allowed();
    super.initState();
  }

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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/hermes.png'), // Substitua 'background_image.jpg' pelo nome do seu arquivo de imagem
            fit: BoxFit.cover, // Cobrir toda a tela
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text("Hermes",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
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
                        MaterialPageRoute(builder: (context) => const LoginPage()),
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
                          //MaterialPageRoute(builder: (context) => const QRCodePage()),
                          MaterialPageRoute(builder: (context) => PyxisPedidoPage(qrCode: '665f829c0ff12c8077ab5282')),
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
