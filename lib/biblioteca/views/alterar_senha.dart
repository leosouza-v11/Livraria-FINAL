import 'package:flutter/material.dart';
import 'package:livraria/model/classes/usuario.dart';
import 'package:livraria/model/usuario_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlterarSenha extends StatefulWidget {
  const AlterarSenha({super.key});

  @override
  State<AlterarSenha> createState() => _AlterarSenhaState();
}

class _AlterarSenhaState extends State<AlterarSenha> {
  //Campos Senhas
  late final TextEditingController _senhaAtualController;
  late final TextEditingController _novaSenhaController;
  late final TextEditingController _confirmarNovaSenhaController;

  //Visualizar senhas
  bool _senhaAtualEscondida = true;
  bool _novaSenhaEscondida = true;
  bool _confirmarNovaSenhaEscondida = true;

  //Comparação das senhas
  late bool _senhaAtual = false;
  late bool _senhasIguais = false;

  //Usuário
  Usuario _usuario = Usuario(nome: '', email: '', telefone: '', senha: '');
  int _idUsuario = 0; //Inicia em 0

  @override
  void initState() {
    super.initState();
    _senhaAtualController = TextEditingController();
    _novaSenhaController = TextEditingController();
    _confirmarNovaSenhaController = TextEditingController();
    recuperaID();
  }

  @override
  void dispose() {
    _senhaAtualController.dispose();
    _novaSenhaController.dispose();
    _confirmarNovaSenhaController.dispose();
    super.dispose();
  }

  //Mostrar ou Esconder Senha Atual
  void _visibilidadeSenhaAtual() {
    setState(() {
      _senhaAtualEscondida = !_senhaAtualEscondida;
    });
  }

  //Mostrar ou Esconder Nova Senha
  void _visibilidadeNovaSenha() {
    setState(() {
      _novaSenhaEscondida = !_novaSenhaEscondida;
    });
  }

  //Mostrar ou Esconder Confirmar Nova Senha
  void _visibilidadeConfirmarSenha() {
    setState(() {
      _confirmarNovaSenhaEscondida = !_confirmarNovaSenhaEscondida;
    });
  }

  //Função que altera a senha
  _alterarSenha(BuildContext context) {
    //Verifica se senhas são iguais
    verificarSenhas();

    if (_senhaAtual == true && _senhasIguais == true) {
      //Atualiza as informações no banco
      atualizaUsuario();

      //Botão OK
      Widget btConfirmar = TextButton(
        child: const Text('OK'),
        onPressed: () {
          Navigator.pop(context); //Volta para tela de alterar senha
          Navigator.pop(context); //Volta para tela de perfil
        },
      );

      //Configura o Alerta
      AlertDialog alerta = AlertDialog(
        title: const Text('Senha alterada com Sucesso!'),
        //content: const Text('Senha alterada com Sucesso!'),
        actions: [btConfirmar],
      );

      //Exibir o diálogo
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alerta;
        },
      );
    } else if (_senhaAtual == false) {
      //Botão OK
      Widget btConfirmar = TextButton(
        child: const Text('OK'),
        onPressed: () {
          Navigator.pop(context); //Volta para tela de alterar senha
        },
      );

      //Configura o Alerta da Senha Atual
      AlertDialog alerta = AlertDialog(
        title: const Text('Não foi possível alterar'),
        content: const Text('Senha atual incorreta!'),
        actions: [btConfirmar],
      );

      //Exibir o diálogo
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alerta;
        },
      );
    } else if (_senhasIguais == false) {
      //Botão OK
      Widget btConfirmar = TextButton(
        child: const Text('OK'),
        onPressed: () {
          Navigator.pop(context); //Volta para tela de alterar senha
        },
      );

      //Configura o Alerta da Nova Senha
      AlertDialog alerta = AlertDialog(
        title: const Text('Não foi possível alterar'),
        content: const Text('Senhas diferentes!'),
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

    //Volta para os valores iniciais
    setState(() {
      _senhaAtual = false;
      _senhasIguais = false;
    });
  }

  //Compara as Senhas
  verificarSenhas() {
    //Verifica a senha atual
    if (_senhaAtualController.text == _usuario.senha) {
      setState(() {
        _senhaAtual = true;
      });
    }

    //Verifica a nova senha
    if ((_novaSenhaController.text == _confirmarNovaSenhaController.text) &&
        (_novaSenhaController.text != '' ||
            _confirmarNovaSenhaController.text != '')) {
      setState(() {
        _senhasIguais = true;
      });
    }
  }

  //Recupera o ID do usuário
  Future<void> recuperaID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUsuario = prefs.getInt('id_usuario') as int;
    });
  }

  //Recupera o usuário do banco para usar nos campos
  Future<void> recuperaUsuario() async {
    List<Usuario> usuarios = await UsuarioDAO.buscarUsuarioID(_idUsuario);

    setState(() {
      _usuario = usuarios[0];
    });
  }

  //Atualiza o usuário no banco de dados
  Future<void> atualizaUsuario() async {
    //Coloca as novas informações do usuário
    _usuario = Usuario(
      id: _idUsuario,
      nome: _usuario.nome,
      email: _usuario.email,
      telefone: _usuario.telefone,
      senha: _novaSenhaController.text,
    );

    //Atualiza o usuário no banco
    await UsuarioDAO.atualizarUsuario(_usuario);
  }

  @override
  Widget build(BuildContext context) {
    //Puxa as informações do usuário
    recuperaUsuario();

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
                  image: AssetImage('assets/images/alterar-senha.png'),
                ),

                const SizedBox(height: 30), //Espaçamento

                //Campo Senha Atual
                TextField(
                  controller: _senhaAtualController,
                  obscureText: _senhaAtualEscondida,
                  decoration: InputDecoration(
                    label: const Text(
                      'Senha Atual',
                      style: TextStyle(fontSize: 18, color: Colors.black),
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
                      onPressed: _visibilidadeSenhaAtual,
                      icon: Icon(_senhaAtualEscondida
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),

                const SizedBox(height: 16), //Espaçamento

                //Campo Nova Senha
                TextField(
                  controller: _novaSenhaController,
                  obscureText: _novaSenhaEscondida,
                  decoration: InputDecoration(
                    label: const Text(
                      'Nova Senha',
                      style: TextStyle(fontSize: 18, color: Colors.black),
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
                      onPressed: _visibilidadeNovaSenha,
                      icon: Icon(_novaSenhaEscondida
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),

                const SizedBox(height: 16), //Espaçamento

                //Campo Confirmar Nova Senha
                TextFormField(
                  controller: _confirmarNovaSenhaController,
                  obscureText: _confirmarNovaSenhaEscondida,
                  decoration: InputDecoration(
                    label: const Text(
                      'Confirmar Senha',
                      style: TextStyle(fontSize: 18, color: Colors.black),
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
                      icon: Icon(_confirmarNovaSenhaEscondida
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
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
                    _alterarSenha(context);
                  },
                  child: const Text(
                    'Alterar Senha',
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
