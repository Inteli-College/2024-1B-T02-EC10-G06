import 'package:flutter/material.dart';
import 'package:hermes/qr_code.dart';


class SucessoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 24),
            Text(
              'Sua solicitação foi gerada com sucesso!',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRCodePage()),
                );
              },
              child: Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
  }
}
