import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hermes/qr_code.dart';
import 'package:hermes/receiver.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hermes/services/notification.dart';
import 'package:hermes/admin.dart';
import "package:hermes/functions.dart";



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // print('${dotenv.env['API_URL']}/auth/login/');
      final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/auth/login/'),
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode >= 200 && response.statusCode < 300) {
        var token = getToken(response);
        saveToken(token);
        // final data = jsonDecode(response.body);
        print('Login successful: $token');
        final permissionResponse = await http.get(
          Uri.parse('${dotenv.env['API_URL']}/auth/getPermission'),
          headers: {
            'Authorization': "Bearer $token",
            'Content-Type': 'application/json',
          },
        );
        var permissionData = jsonDecode(permissionResponse.body);
        print('Permission: $permissionData');
        int permission = permissionData['permission'];
        NotificationService.showNotification(
            'Login Sucessful!', 'Welcome back, ${_usernameController.text}!');
        Widget page;
        if (permission == 2) {
          page = const DashboardPage();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        }
        if (permission == 0) {
          page = const QRCodePage();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        }
        if (permission == 1) {
          page = const ReceiverPage();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        }
      } else {
        // Handle login error
        setState(() {
          _errorMessage = 'Invalid username or password';
        });
      }
    } on Exception catch (e) {
      print('Failed to login: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to login';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Hermes',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'Gerenciamento de medicamentos com qualidade dos deuses',
                    style: TextStyle(
                      fontSize:
                          20.0, // Ajuste o tamanho da fonte conforme necessário
                      fontWeight: FontWeight.w400, // Fonte mais leve
                    ),
                    textAlign: TextAlign
                        .center, // Centraliza o texto dentro do Text widget
                  ),
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              Colors.deepPurple),
                          fixedSize: WidgetStateProperty.all<Size>(
                              const Size(200, 60)),
                        ),
                      onPressed: _login,
                      child: const Text('Login', 
                      style: TextStyle(
                            letterSpacing: 1.0,
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
              const SizedBox(height: 20),
              _errorMessage.isNotEmpty
                  ? Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
