import 'package:flutter/material.dart';
import 'package:hermes/qr_code.dart';


class SucessoPage extends StatelessWidget {
  const SucessoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 24),
            const Text(
              'Sua solicitação foi gerada com sucesso!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const QRCodePage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }
}