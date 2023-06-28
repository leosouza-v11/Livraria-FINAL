import 'package:livraria/database/db_libraria.dart';
import 'package:livraria/model/classes/livro_api.dart';

class LivroDAO {
  //INSERT
  static Future<int> inserirLivro(LivroApi livro) async {
    //Chama o Banco de Dados
    var db = await DBLivraria.getInstance();

    int novoID = await db.insert(
      'livro',
      livro.toMap(),
    );
    return novoID;
  }

  //SELECT
  //Buscar todos os livros
  static Future<List<LivroApi>> carregarLivros() async {
    //Chama o Banco de Dados
    var db = await DBLivraria.getInstance();

    List<Map<String, Object?>> resultado = await db.query('livro');

    List<LivroApi> livros =
        resultado.map((mapLivro) => LivroApi.fromMap(mapLivro)).toList();
    return livros;
  }

  //Buscar por ID
  static Future<List<LivroApi>> buscarLivroID(String id) async {
    //Chama o Banco de Dados
    var db = await DBLivraria.getInstance();

    List<Map<String, Object?>> resultado =
        await db.query('livro', where: 'codigo=?', whereArgs: [id]);

    List<LivroApi> livro =
        resultado.map((mapLivro) => LivroApi.fromMap(mapLivro)).toList();

    return livro;
  }
}
