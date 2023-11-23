import 'package:dam_u3_practica2/inicio.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 5), () {});
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Inicio()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Logo
          Center(
            child: Image.asset("assets/images/logo.png",
                width: MediaQuery.of(context).size.width *
                    0.5), // Ajusta el tamaño según sea necesario
          ),
          // Indicador de carga y texto
          Positioned(
            bottom: MediaQuery.of(context).size.height *
                0.1, // Ajusta la posición según sea necesario
            left: 0,
            right: 0,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 20),
                Text('Cargando...',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      backgroundColor: Colors.white,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
