import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Adicionando o firebase core
import 'package:firebase_auth/firebase_auth.dart'; // Adicionando o firebase auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Adicionando o Firestore
import 'firebase_options.dart'; // Adicionando o firebase options
import 'screens/cookbooks_screen.dart'; // Adicionando a tela CookBooks Screen
import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> _isConnected() async {
  var connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    return true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Verificação de incialização do Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ); // Inicializando o Firebase
    print('Firebase inicializado com sucesso');
  } catch (e) {
    print('Erro ao inicializar o Firebase: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CookBooks',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Função para login
  Future<void> _login() async{
    // Verificando se os campos estão vazios
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login realizado com sucesso!')),
      );

      // Redirecionando para a tela de CookBooks Screen
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CookBooksScreen())
      );

    } catch (e) {
      print('Erro ao fazer login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao fazer login: ${e.toString()}')),
      );
    }
  }

  //Função para cadastro
  Future<void> _signUp() async{
    // Verificando se os campos estão vazios
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      // Salvar usuário no Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': _emailController.text.trim(),
        'created_at': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );

      // Redirecionar para a tela cookbooks_screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CookBooksScreen()),
      );

    } catch (e) {
      print('Erro ao cadastrar: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao cadastrar: ${e.toString()}')),
      );
    }
  }

  //Função para recuperar a senha
  Future<void> _resetPassword() async{
    // Verificando se o campo de e-mail está vazio
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, insira seu email!')),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('E-mail de recuperação enviado!')),
      );
    } catch (e) {
      print('Erro ao enviar e-mail de recuperação: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar e-mail de recuperação: ${e.toString()}')),
      );
    }
  }

  // Mostrando o bottom sheet de login
  void _showLoginBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite o bottom sheet expandir para ocupar mais espaço
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Wrap(
            children: [
              Center(
                child: Text(
                  'Fazer login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Satisfy',
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: ElevatedButton(
                        onPressed: _login,
                        child: Text(
                            'Entrar',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'Satisfy',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20), // Adiciona espaço entre os botões
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context), // Fechar o bottomSheet
                        child: Text(
                            'Cancelar',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'Satisfy',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: ElevatedButton(
                        onPressed: _resetPassword,
                        child: Text(
                            'Esqueceu sua senha? Recupere aqui',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'Satisfy',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCadastroBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Permite o bottom sheet expandir para ocupar mais espaço
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Wrap(
            children: [
              Center(
                child: Text(
                  'Cadastre seu usuário',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Satisfy',
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nome Completo',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: ElevatedButton(
                        onPressed: _signUp,
                        child: Text(
                            'Cadastrar',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'Satisfy',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20), // Adiciona espaço entre os botões
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                            'Cancelar',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'Satisfy',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/backgrounds/background_cookbooks.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), // Define a cor e o nível de transparência
                  BlendMode.srcATop, // Define como a cor deve ser aplicada à imagem
                ),
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.asset(
                            'assets/images/logos/logo_cookbooks.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Center(
                          child: Text(
                            "CookBook's",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 80.0,
                              fontFamily: 'Satisfy',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 10.0,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _showLoginBottomSheet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                            vertical: 15,
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'Satisfy',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _showCadastroBottomSheet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                            vertical: 15,
                          ),
                        ),
                        child: Text(
                          'Cadastro',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'Satisfy',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Desenvolvido por:',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            fontFamily: 'Satisfy',
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: Image.asset(
                            'assets/images/logos/logo_lab_informatica.png',
                            fit: BoxFit.cover,
                            color: Colors.white,
                            width: 60,
                            height: 60,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Laboratório de informática do TE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            fontFamily: 'Satisfy',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}