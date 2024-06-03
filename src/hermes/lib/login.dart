import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hermes/services/notification.dart';
import 'package:hermes/admin.dart';
import 'package:hermes/receiver.dart';

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
      final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/login'),
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
        final data = jsonDecode(response.body);
        print('Login successful: $data');
        NotificationService.showNotification('Login Sucessful!', 'Welcome back, ${_usernameController.text}!');
        Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
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
          // APAGAR DEPOIS
          Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardPage()));
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                      fontSize: 20.0, // Ajuste o tamanho da fonte conforme necessário
                      fontWeight: FontWeight.w400, // Fonte mais leve
                    ),
                    textAlign: TextAlign.center, // Centraliza o texto dentro do Text widget
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
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