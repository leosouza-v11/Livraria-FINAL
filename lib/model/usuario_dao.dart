import 'package:livraria/database/db_libraria.dart';
import 'package:livraria/model/classes/usuario.dart';

class UsuarioDAO {
  //INSERT
  static Future<int> inserir(Usuario usuario) async {
    //Chama o Banco de Dados
    var db = await DBLivraria.getInstance();

    //Retorna o ID da última inserção
    var novoID = await db.insert('usuario', usuario.toMap());

    return novoID;
  }

  //SELECT
  //Buscar por ID
  static Future<List<Usuario>> buscarUsuarioID(int id) async {
    //Chama o Banco de Dados
    var db = await DBLivraria.getInstance();

    List<Map<String, Object?>> resultado =
        await db.query('usuario', where: 'id=?', whereArgs: [id]);

    List<Usuario> usuario =
        resultado.map((mapUsuario) => Usuario.fromMap(mapUsuario)).toList();

    return usuario;
  }

  //Busca por Email
  static Future<List<Usuario>> buscaUsuarioEmail(String email) async {
    //Chama o Banco de Dados
    var db = await DBLivraria.getInstance();

    List<Map<String, Object?>> resultado =
        await db.query('usuario', where: 'email=?', whereArgs: [email]);

    List<Usuario> usuario =
        resultado.map((mapUsuario) => Usuario.fromMap(mapUsuario)).toList();

    return usuario;
  }

  //Consultar se email existe
  static Future<bool> consultarEmail(String email) async {
    //Chama o Banco de Dados
    var db = await DBLivraria.getInstance();

    //Consulta por email
    var resultado =
        await db.rawQuery('SELECT * FROM usuario WHERE email = ?', [email]);

    if (resultado.isNotEmpty) {
      //Se achar algo retorna true
      return true;
    } else {
      //Se não achar nada retorna false
      return false;
    }
  }

  //Verifica email e senha Login
  static Future<bool> verificaLogin(String email, senha) async {
    //Chama o Banco de Dados
    var db = await DBLivraria.getInstance();

    //Consulta por email e senha
    var resultado = await db.rawQuery(
        'SELECT * FROM usuario WHERE email = ? AND senha = ?', [email, senha]);

    if (resultado.isNotEmpty) {
      //Se existir retorna true
      return true;
    } else {
      //Se não existir retorna false
      return false;
    }
  }

  //UPDATE
  static Future<bool> atualizarSenhaUsuario(String email) async {
    try {
      //Chama o Banco de Dados
      var db = await DBLivraria.getInstance();

      //Altera a senha do usuário para 1234
      await db.rawQuery(
        'UPDATE usuario SET senha = ? WHERE email = ?',
        ['1234', email],
      );
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  static Future<void> atualizarUsuario(Usuario usuario) async {
    //Chama o Banco de Dados
    var db = await DBLivraria.getInstance();

    await db.update('usuario', usuario.toMap(),
        where: 'id=?', whereArgs: [usuario.id]);
  }

  //DELET
  Future<void> deletarUsuario(Usuario usuario) async {
    //Chama o Banco de Dados
    var db = await DBLivraria.getInstance();

    await db.delete('usuario', where: 'id=?', whereArgs: [usuario.id]);
  }
}
