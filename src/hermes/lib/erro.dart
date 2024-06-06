import 'package:flutter/material.dart';
import 'qr_code.dart';

class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
              size: 100,
            ),
            SizedBox(height: 24),
            Text(
              message,
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
              child: Text('Tente novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
