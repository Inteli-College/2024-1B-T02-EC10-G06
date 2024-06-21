import 'dart:async';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hermes/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hermes/services/notification.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MinhaPrimeiraTela(),
    );
  }
}

class MinhaPrimeiraTela extends StatefulWidget {
  const MinhaPrimeiraTela({super.key});

  @override
  State<MinhaPrimeiraTela> createState() => _MinhaPrimeiraTelaState();
}


class _MinhaPrimeiraTelaState extends State<MinhaPrimeiraTela> {
  final int _numRoles = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numRoles; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.deepPurple : const Color.fromARGB(255, 137, 137, 137),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // ignore: unused_field
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {
        _currentPage = (_currentPage + 1) % _numRoles;
        _pageController.animateToPage(_currentPage,
            duration: const Duration(milliseconds: 400), curve: Curves.easeInOutQuad);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/hermesImage.png'), // Substitua 'background_image.jpg' pelo nome do seu arquivo de imagem
            fit: BoxFit.fitHeight, // Ajuste a imagem para preencher a tela
            opacity: 0.8,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: BlurryContainer(
            blur: 20,
            height: ((MediaQuery.of(context).size.height) / 100) * 45,
            elevation: 6,
            padding: const EdgeInsets.only(left: 24, right: 24),
            color: const Color.fromARGB(255, 240, 238, 255).withOpacity(0.45),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: 200,
                    child: PageView(
                            physics: const ClampingScrollPhysics(),
                            controller: _pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                                
                              });
                            },
                            children: const [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Enfermeiras",
                                      style: TextStyle(
                                          fontSize: 28, fontWeight: FontWeight.bold)),
                                  Text(
                                    'Criação de tickets para a solicitação de medicamentos.' ,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          20.0, // Ajuste o tamanho da fonte conforme necessário
                                      fontWeight: FontWeight.w400, // Fonte mais leve
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Tecnicos de enfermagem",
                                      style: TextStyle(
                                          fontSize: 28, fontWeight: FontWeight.bold)),
                                  Text(
                                    'Recebimento e Gerenciamento de Tickets.' ,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          20.0, // Ajuste o tamanho da fonte conforme necessário
                                      fontWeight: FontWeight.w400, // Fonte mais leve
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Administradores",
                                      style: TextStyle(
                                          fontSize: 28, fontWeight: FontWeight.bold)),
                                  Text(
                                    'Supervisão geral e análise de dados.' ,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          20.0, // Ajuste o tamanho da fonte conforme necessário
                                      fontWeight: FontWeight.w400, // Fonte mais leve
                                    ),
                                  ),
                                ],
                              ),
                            ],
                  )),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 32),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              Colors.deepPurple),
                          fixedSize: WidgetStateProperty.all<Size>(
                              const Size(200, 60)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          "Começar",
                          style: TextStyle(
                            letterSpacing: 1.0,
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
