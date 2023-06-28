import 'package:flutter/material.dart';
import 'package:livraria/biblioteca/widgets/livro_card.dart';
import 'package:livraria/model/classes/favoritos.dart';
import 'package:livraria/model/classes/livro_api.dart';
import 'package:livraria/model/favoritos_dao.dart';
import 'package:livraria/model/livro_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaFavoritos extends StatefulWidget {
  const TelaFavoritos({super.key});

  @override
  State<TelaFavoritos> createState() => _FavoritosState();
}

class _FavoritosState extends State<TelaFavoritos> {
  late int _idUsuario;
  final List<LivroApi> _listaLivros = [];

  @override
  void initState() {
    super.initState();
    _recuperaID(); //Recupera o ID do Usuário
  }

  Future<void> _recuperaID() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUsuario = prefs.getInt('id_usuario') as int;
    });
  }

  //Recupera os livros favoritos do banco para usar nos cards
  Future<List<Favoritos>> recuperaLivrosFavoritos() async {
    return FavoritosDAO.carregarLivrosFavoritos(_idUsuario);
  }

  Future<void> recuperaLivroPorID(String codigoLivro) async {
    List<LivroApi> livro = await LivroDAO.buscarLivroID(codigoLivro);
    _listaLivros.add(livro[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(212, 242, 246, 1),
      body: Padding(
        padding: const EdgeInsets.all(8.0),

        //Grid com os livros
        child: FutureBuilder(
          future: recuperaLivrosFavoritos(),
          builder: (context, snapshot) {
            //se não tiver error
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error.toString()}');
              }

              List<Favoritos> favoritos = snapshot.data as List<Favoritos>;

              for (var item in favoritos) {
                recuperaLivroPorID(item.codigoLivro);
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4),

                //Roda o "for" a quantidade de livros na lista
                itemCount: _listaLivros.length,

                //chama a lista toda, um por vez (como num for) e coloca em algo (Card)
                itemBuilder: (context, index) => LivroCard(
                  livro: _listaLivros[index],
                ),
              );
            } else {
              return const Text('Erro, não foi possível obter os dados');
            }
          },
        ),
      ),
    );
  }
}
