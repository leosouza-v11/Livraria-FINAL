import 'package:flutter/material.dart';
import 'package:livraria/model/classes/usuario.dart';
import 'package:livraria/model/usuario_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  //Campos Cadastro
  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _telefoneController;
  late final TextEditingController _senhaController;
  late final TextEditingController _confirmarSenhaController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _emailController = TextEditingController();
    _telefoneController = TextEditingController();
    _senhaController = TextEditingController();
    _confirmarSenhaController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  //Campo senhas
  bool _senhaEscondida = true;
  bool _confirmarSenhaEscondida = true;

  //Mostrar ou Esconder Senha
  void _visibilidadeSenha() {
    setState(() {
      _senhaEscondida = !_senhaEscondida;
    });
  }

  //Mostrar ou Esconder Confirmar Senha
  void _visibilidadeConfirmarSenha() {
    setState(() {
      _confirmarSenhaEscondida = !_confirmarSenhaEscondida;
    });
  }

  //Verificar Campos Senhas
  verificarCampos() {
    if (_nomeController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _telefoneController.text.isNotEmpty &&
        _senhaController.text.isNotEmpty &&
        _confirmarSenhaController.text.isNotEmpty) {
      if (_senhaController.text == _confirmarSenhaController.text) {
        return true;
      } else {
        alertaSenhasDiferentes();
      }
    } else {
      alertaCamposVazios();
    }
  }

  //Cadastrar usuário
  Future<void> cadastrarUsuario() async {
    //Consulta se email já existe
    bool resultadoEmail =
        await UsuarioDAO.consultarEmail(_emailController.text);

    if (resultadoEmail == true) {
      //Exibe um alerta avisando que já existe esse email
      alertaEmailExistente();
    } else {
      //Passa as informações dos campos para o Usuário
      var usuario = Usuario(
        nome: _nomeController.text,
        email: _emailController.text,
        telefone: _telefoneController.text,
        senha: _senhaController.text,
      );

      //Verifica os campos
      var resultadoCampos = verificarCampos();

      if (resultadoCampos == true) {
        //Inserir no banco de dados
        int novoID = await UsuarioDAO.inserir(usuario);

        //Crio uma "sessão" e atribuo o id nela.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('id_usuario', novoID);

        //Exibir Alerta
        alertaCadastradoComSucesso();
      }
    }
  }

  //Alerta de "Cadastrado com Sucesso"
  alertaCadastradoComSucesso() {
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
      title: const Text('Cadastrado com Sucesso!'),
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

  //Alerta de "Email já Utilizado"
  alertaEmailExistente() {
    //Botão OK
    Widget btConfirmar = TextButton(
      child: const Text('OK', style: TextStyle(fontSize: 18)),
      onPressed: () {
        //Continua na página de cadastro
        Navigator.pop(context);
      },
    );

    //Configura o Alerta
    AlertDialog alerta = AlertDialog(
      title: const Text('Não foi possível cadastrar!'),
      content:
          const Text('Esse email já está sendo utilizado por outro usuário!'),
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

  //Alerta de "Senhas Diferentes"
  alertaSenhasDiferentes() {
    //Botão OK
    Widget btConfirmar = TextButton(
      child: const Text('OK', style: TextStyle(fontSize: 18)),
      onPressed: () {
        //Continua na página de cadastro
        Navigator.pop(context);
      },
    );

    //Configura o Alerta
    AlertDialog alerta = AlertDialog(
      title: const Text('Não foi possível cadastrar!'),
      content: const Text('Senhas Diferentes!'),
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

  //Alerta de "Campos Vazios"
  alertaCamposVazios() {
    //Botão OK
    Widget btConfirmar = TextButton(
      child: const Text('OK', style: TextStyle(fontSize: 18)),
      onPressed: () {
        //Continua na página de cadastro
        Navigator.pop(context);
      },
    );

    //Configura o Alerta
    AlertDialog alerta = AlertDialog(
      title: const Text('Não foi possível cadastrar!'),
      content: const Text('Campo(s) Vazio(s)!'),
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

                //Logo Cadastro
                const Image(
                  width: 150,
                  image: AssetImage('assets/images/cadastro.png'),
                ),

                const SizedBox(height: 24), //Espaçamento

                //Campo Nome Completo
                TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    label: Text(
                      'Nome Completo',
                      style: TextStyle(fontSize: 16, color: Colors.black),
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
                    prefixIcon: Icon(Icons.person),
                  ),
                ),

                const SizedBox(height: 16), //Espaçamento

                //Campo Email
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    label: Text(
                      'Email',
                      style: TextStyle(fontSize: 16, color: Colors.black),
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
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: 16), //Espaçamento

                //Campo Telefone
                TextField(
                  controller: _telefoneController,
                  decoration: const InputDecoration(
                    label: Text(
                      'Telefone',
                      style: TextStyle(fontSize: 16, color: Colors.black),
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
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),

                const SizedBox(height: 16), //Espaçamento

                //Campo Senha
                TextField(
                  controller: _senhaController,
                  obscureText: _senhaEscondida,
                  decoration: InputDecoration(
                    label: const Text(
                      'Senha',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),

                    //Borda antes de clicar
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),

                    //Borda depois de clicar
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.lightBlue,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),

                    //Ícone antes do texto
                    prefixIcon: const Icon(Icons.lock_outline),

                    //Ícone Mostrar Senha
                    suffixIcon: IconButton(
                      onPressed: _visibilidadeSenha,
                      icon: Icon(_senhaEscondida
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),

                const SizedBox(height: 16), //Espaçamento

                //Campo Confirmar Senha
                TextField(
                  controller: _confirmarSenhaController,
                  obscureText: _confirmarSenhaEscondida,
                  decoration: InputDecoration(
                    label: const Text(
                      'Confirmar Senha',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),

                    //Borda antes de clicar
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),

                    //Borda depois de clicar
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.lightBlue,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),

                    //Ícone antes do texto
                    prefixIcon: const Icon(Icons.lock_outline),

                    //Ícone Mostrar Senha
                    suffixIcon: IconButton(
                      onPressed: _visibilidadeConfirmarSenha,
                      icon: Icon(_confirmarSenhaEscondida
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),

                const SizedBox(height: 24), //Espaçamento

                //Botão Cadastrar
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.40, 45)),
                  onPressed: () => cadastrarUsuario(),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
