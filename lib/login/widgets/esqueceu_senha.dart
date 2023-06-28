import 'package:flutter/material.dart';
import 'package:livraria/model/usuario_dao.dart';

class EsqueceuSenha extends StatefulWidget {
  const EsqueceuSenha({super.key});

  @override
  State<EsqueceuSenha> createState() => _EsqueceuSenhaState();
}

class _EsqueceuSenhaState extends State<EsqueceuSenha> {
  //Campo Email
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  //Altera a senha no banco de dados
  Future<void> redefinirSenha(String email) async {
    bool resultado = await UsuarioDAO.atualizarSenhaUsuario(email);

    if (resultado == true) {
      alertaSenhaRedefinida();
    } else {
      alertaEmailInvalido();
    }
  }

  //Alerta de "Senha Redefinida"
  alertaSenhaRedefinida() {
    //Botão OK
    Widget btConfirmar = TextButton(
      child: const Text('OK'),
      onPressed: () {
        Navigator.of(context).pushNamed('/'); //Volta para tela de login
      },
    );

    //Configura o Alerta
    AlertDialog alerta = AlertDialog(
      title: const Text('Senha Redefinida'),
      content: const Text('Sua nova senha é: 1234'),
      actions: [btConfirmar],
    );

    //Exibir o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }

  //Alerta de "Senha Redefinida"
  alertaEmailInvalido() {
    //Botão OK
    Widget btConfirmar = TextButton(
      child: const Text('OK'),
      onPressed: () {
        Navigator.pop(context); //Continua na tela de Redefinir Senha
      },
    );

    //Configura o Alerta
    AlertDialog alerta = AlertDialog(
      title: const Text('Email não Encontrado!'),
      //content: const Text('Email não Encontrado!'),
      actions: [btConfirmar],
    );

    //Exibir o diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, //Encosta o body no appBar
      backgroundColor: const Color.fromRGBO(212, 242, 246, 1),
      //o appBar só é necessário por conta do "voltar"
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, //Leva a barra para o topo
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.75),

                //Logo
                const Image(
                  width: 150,
                  image: AssetImage('assets/images/esqueceu-senha.png'),
                ),

                const SizedBox(height: 30), //Espaçamento

                //Campo Email
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    label: Text(
                      'Email',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: 30), //Espaçamento

                //Botão Redefinir Senha
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.40, 45)),
                  onPressed: () {
                    redefinirSenha(_emailController.text);
                  },
                  child: const Text(
                    'Redefinir Senha',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8), //Espaçamento
              ],
            ),
          ),
        ),
      ),
    );
  }
}
