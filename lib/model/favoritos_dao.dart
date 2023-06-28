import 'package:livraria/database/db_libraria.dart';
import 'package:livraria/model/classes/favoritos.dart';
import 'package:livraria/model/classes/livro_api.dart';

class FavoritosDAO {
  //INSERT
  static Future<int> inserirFavoritos(Favoritos favoritos) async {
    //Chama o Banco de Dados
    var db = await DBLivraria.getInstance();

    int novoID = await db.insert(
      'favoritos',
      favoritos.toMap(),
    );

    return novoID;
  }

  //SELECT
  //Buscar todos os livros em favoritos
  static Future<List<Favoritos>> carregarLivrosFavoritos(idUsuario) async {
    //Chama o Banco de Dados
    var db = await DBLivraria.getInstance();

    List<Map<String, Object?>> resultado = await db
        .rawQuery('SELECT * FROM favoritos WHERE idUsuario = ?', [idUsuario]);

    List<Favoritos> favoritos =
        resultado.map((mapFavorito) => Favoritos.fromMap(mapFavorito)).toList();
    return favoritos;
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
