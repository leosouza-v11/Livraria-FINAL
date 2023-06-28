import 'package:flutter/material.dart';
import 'package:livraria/model/classes/usuario.dart';
import 'package:livraria/model/usuario_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Campos Login
  late final TextEditingController _emailController;
  late final TextEditingController _senhaController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _senhaController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> verificaLogin(String email, senha) async {
    //Faz a consulta com o email do usuario
    List<Usuario> usuario = await UsuarioDAO.buscaUsuarioEmail(email);

    if (usuario.isNotEmpty) {
      //Faz a consulta com o Email e a Senha
      bool resultado = await UsuarioDAO.verificaLogin(email, senha);

      if (resultado == true) {
        //Pega o ID
        var id = usuario[0].id as int;

        //Crio uma "sessão" e atribuo o id nela.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('id_usuario', id);

        alertaLogadoComSucesso();
      } else {
        alertaSenhaIncorreta();
      }
    } else {
      alertaEmailNaoEncontrado();
    }
  }

  //Alerta de "Email Não Encontrado"
  alertaEmailNaoEncontrado() {
    //Botão OK
    Widget btConfirmar = TextButton(
      child: const Text('OK'),
      onPressed: () {
        Navigator.pop(context); //Volta para tela de login
      },
    );

    //Configura o Alerta
    AlertDialog alerta = AlertDialog(
      title: const Text('Não foi possível fazer Login'),
      content: const Text('Email não encontrado!'),
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

  //Alerta de "Senha Incorreta"
  alertaSenhaIncorreta() {
    //Botão OK
    Widget btConfirmar = TextButton(
      child: const Text('OK'),
      onPressed: () {
        Navigator.pop(context); //Volta para tela de login
      },
    );

    //Configura o Alerta
    AlertDialog alerta = AlertDialog(
      title: const Text('Não foi possível fazer Login'),
      content: const Text('Senha Incorreta!'),
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

  //Alerta de "Logado com Sucesso"
  alertaLogadoComSucesso() {
    //Botão OK
    Widget btConfirmar = TextButton(
      child: const Text('OK', style: TextStyle(fontSize: 18)),
      onPressed: () {
        //Rota para onde vai
        Navigator.pushNamed(
          context,
          '/biblioteca',
        );
      },
    );

    //Configura o Alerta
    AlertDialog alerta = AlertDialog(
      title: const Text('Logado com Sucesso!'),
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
      backgroundColor: const Color.fromRGBO(212, 242, 246, 1),
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
                  image: AssetImage('assets/images/login.png'),
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

                    //Borda antes de clicar
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),

                    //Borda depois de clicar
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.lightBlue,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),

                    //Ícone antes do texto
                    prefixIcon: Icon(
                      Icons.email_outlined,
                    ),
                  ),
                ),

                const SizedBox(height: 16), //Espaçamento

                //Campo Senha
                TextField(
                  controller: _senhaController,
                  obscureText: true, //Oculta a senha
                  decoration: const InputDecoration(
                    label: Text(
                      'Senha',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),

                    //Borda antes de clicar
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),

                    //Borda depois de clicar
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.lightBlue,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),

                    //Ícone antes do texto
                    prefixIcon: Icon(
                      Icons.lock_outline,
                    ),
                  ),
                ),

                //Link para Esquecer Senha
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/esqueceu_senha');
                      },
                      child: const Text(
                        'Esqueci minha senha',
                        style: TextStyle(fontSize: 16, color: Colors.lightBlue),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30), //Espaçamento

                //Botão Login
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.40, 45)),
                  onPressed: () => verificaLogin(
                      _emailController.text, _senhaController.text),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8), //Espaçamento

                //Link para Cadastro
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/cadastro');
                  },
                  child: const Text(
                    'Não tem cadastro? Clique aqui',
                    style: TextStyle(fontSize: 16, color: Colors.lightBlue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
