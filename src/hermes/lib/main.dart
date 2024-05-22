import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hermes/view/onboarding/login.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}




class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String _idUser = '';

Future<bool> _validateCredentials(String email, String password, BuildContext context) async {
  // Simula uma chamada de API para validar as credenciais
  final response = await Future.delayed(const Duration(seconds: 2), () {
    return http.get(
      Uri.parse('http://172.29.96.1:8000/auth/$email/$password'),
      headers: {'Content-Type': 'application/json'},
    ); 
  }); 

  // Se a resposta da API for bem-sucedida e as credenciais forem válidas, retorne true
  if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      _idUser = jsonResponse['access_token']; 
    return true;
  } else {
    return false;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(onPressed: (){
                                          Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginPage()),
                                );
        }, child: const Text("...")),
      ));
  }
}
