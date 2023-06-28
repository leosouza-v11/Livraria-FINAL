import 'package:flutter/material.dart';
import 'package:livraria/model/classes/usuario.dart';
import 'package:livraria/model/usuario_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  Usuario _usuario = Usuario(nome: '', email: '', telefone: '', senha: '');
  late int _idUsuario;
  bool _perfilAtualizado = false;

  //Campos Perfil
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;
  late TextEditingController _senhaController;

  @override
  void initState() {
    super.initState();
    _recuperaID(); //Recupera o ID do Usuário
    _nomeController = TextEditingController();
    _emailController = TextEditingController();
    _telefoneController = TextEditingController();
    _senhaController = TextEditingController();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _recuperaID() async {
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
      atribuiValorCampos();
      _perfilAtualizado = true;
    });
  }

  //Atualiza o usuário no banco de dados
  Future<void> atualizaUsuario() async {
    //Atualiza as informações dos campos
    setState(() {
      _nomeController;
      _emailController;
      _telefoneController;
    });

    //Coloca as novas informações do usuário
    _usuario = Usuario(
      id: _idUsuario,
      nome: _nomeController.text,
      email: _emailController.text,
      telefone: _telefoneController.text,
      senha: _senhaController.text,
    );

    //Atualiza o usuário no banco
    await UsuarioDAO.atualizarUsuario(_usuario);

    setState(() {
      _perfilAtualizado = false;
    });

    //Exibe o alerta
    perfilAtualizado();
  }

  void atribuiValorCampos() {
    _nomeController.text = _usuario.nome;
    _emailController.text = _usuario.email;
    _telefoneController.text = _usuario.telefone;
    _senhaController.text = _usuario.senha;
  }

  //Alerta de "Perfil Atualizado"
  perfilAtualizado() {
    //Botão OK
    Widget btConfirmar = TextButton(
      child: const Text('OK', style: TextStyle(fontSize: 18)),
      onPressed: () {
        //Rota para onde vai
        Navigator.pop(context);
      },
    );

    //Configura o Alerta
    AlertDialog alerta = AlertDialog(
      title: const Text('Perfil Atualizado!'),
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
    //Atualiza informações do Perfil
    if (_perfilAtualizado == false) {
      recuperaUsuario();
    }

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

                //Logo Cadastro
                const Image(
                  width: 150,
                  image: AssetImage('assets/images/perfil.png'),
                ),

                const SizedBox(height: 24), //Espaçamento

                //Campo Nome Completo
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    label: const Text(
                      'Nome Completo',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    hintText: _nomeController.text,

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
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),

                const SizedBox(height: 16), //Espaçamento

                //Campo Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    label: const Text(
                      'Email',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    hintText: _emailController.text,

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
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: 16), //Espaçamento

                //Campo Telefone
                TextField(
                  controller: _telefoneController,
                  decoration: InputDecoration(
                    label: const Text(
                      'Telefone',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    hintText: _telefoneController.text,

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
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),

                const SizedBox(height: 32), //Espaçamento

                //Botão Salvar
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.40, 45)),
                  onPressed: atualizaUsuario,
                  child: const Text(
                    'Salvar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30), //Espaçamento

                //Botão Alterar Senha
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.40, 45)),
                  onPressed: () {
                    Navigator.pushNamed(context, '/alterar_senha');
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
