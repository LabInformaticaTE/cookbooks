import 'package:flutter/material.dart';

class CookBooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CookBooks"),
      ),
      body: Center(
        child: Text("Bem-vindo ao CookBooks!"),
      ),
    );
  }
}
