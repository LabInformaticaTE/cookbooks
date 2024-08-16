import 'package:flutter/material.dart';

void main() {
  runApp(const Login());
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CookBooks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const LoginScreen(title: 'Login'),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _HomeState();
}

class _HomeState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/imagem_de_fundo_1920x1080.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Image.asset(
                'images/imagem_logo_culinaria_1920x1080.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(labelText: 'Usuário'),
              ),
              const TextField(
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              const ElevatedButton(
                onPressed: null, // Aqui você adiciona a funcionalidade de login
                child: Text('Entrar'),
              ),
              const SizedBox(height: 20),
              const ElevatedButton(
                onPressed: null, // Aqui você adiciona a funcionalidade de login
                child: Text('Cadastra-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
