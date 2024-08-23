import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgrounds/background_cookbooks.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Center(
                child: Container(
                  width: 300.0,  // Largura maior do contêiner
                  height: 300.0, // Altura maior do contêiner (igual à largura para que seja circular)
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100.0), // Raio igual à metade do tamanho para fazer o círculo
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0), // Também deve ter o mesmo raio para manter a imagem dentro do círculo
                    child: Image.asset(
                      'assets/images/icons/logo_cookbooks.png', // Caminho da sua imagem dentro do projeto
                      fit: BoxFit.cover, // Faz a imagem cobrir todo o contêiner
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'CookBooks',
                    textAlign: TextAlign.center, // Para centralizar o texto horizontalmente
                    style: TextStyle(
                      fontSize: 90.0,
                      fontFamily: 'Satisfy',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0, // Defina o nível de desfoque da sombra
                          color: Colors.grey.withOpacity(0.5), // Defina a cor da sombra com opacidade
                          offset: Offset(5.0, 5.0), // Define o deslocamento horizontal e vertical da sombra
                        ),
                      ],
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(20),
              ),
              const Spacer(),
              // Container inferior
              Container(
                padding: const EdgeInsets.all(20.0),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80)
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Usuário',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const TextField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        // Adicione a funcionalidade de login aqui
                      },
                      child: const Text('Entrar'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        // Navegação para a tela de cadastro
                      },
                      child: const Text(
                        'Ainda não tem uma conta? Clique aqui e inscreva-se',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}