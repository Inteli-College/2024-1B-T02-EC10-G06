import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hermes/view/task_view.dart';

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
        primarySwatch: Colors.deepPurple,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}




class _LoginPageState extends State<LoginPage> {
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite seu email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, digite sua senha';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            setState(() {
                              _isLoading = true;
                            });
                            final isValid = await _validateCredentials(_email, _password, context);
                            setState(() {
                              _isLoading = false;
                            });
                            if (mounted) {
                              if (isValid) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => TasksView(idUser: _idUser)),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Credenciais inválidas')),
                                );
                              }
                            }
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ),

                  ],
                ),
                )
              ),
            ),
    );
  }
}
