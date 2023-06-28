import 'package:flutter/material.dart';
import 'package:livraria/model/classes/favoritos.dart';
import 'package:livraria/model/classes/livro_api.dart';
import 'package:livraria/model/livro_dao.dart';
import 'package:livraria/model/favoritos_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class LivroWidget extends StatefulWidget {
  const LivroWidget({super.key, required this.livro});

  final LivroApi livro;

  @override
  State<LivroWidget> createState() => _LivroWidgetState();
}

class _LivroWidgetState extends State<LivroWidget> {
  bool _btFavoritos = false;
  int _idUsuario = 0;

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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 32), //Espaçamento

            //Botão de Adicionar
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    //Inserir Livro no banco
                    LivroDAO.inserirLivro(widget.livro);

                    ConflictAlgorithm.replace;

                    //Inserir Usuário e Livro nos Favoritos
                    Favoritos favoritos = Favoritos(
                        idUsuario: _idUsuario,
                        codigoLivro: widget.livro.codigo);

                    //Inserir os favoritos nos Favoritos
                    FavoritosDAO.inserirFavoritos(favoritos);

                    //Muda o estado do coração
                    setState(() {
                      _btFavoritos = !_btFavoritos;
                    });
                  },
                  icon: Icon(
                    (_btFavoritos == false)
                        ? Icons.favorite_border
                        : Icons.favorite,
                    color: Colors.lightBlue,
                    size: 40,
                  ),
                ),
              ],
            ),

            //Capa Livro
            Image.network(
              widget.livro.capa ??
                  'https://jbinstrumentos.com.br/wp-content/uploads/2021/04/sem-imagem.jpg',
              width: 200,
              height: 300,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Título
                Text(
                  widget.livro.titulo,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24), //Espaçamento

                //Informações sobre o Livro
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Codigo: ${widget.livro.codigo}'),
                    //Autor
                    Text(
                      'Autor: ${widget.livro.autor}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8), //Espaçamento

                    //Páginas
                    Text(
                      'Páginas: ${widget.livro.paginas}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8), //Espaçamento

                    //Editora
                    Text(
                      'Editora: ${widget.livro.editora}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8), //Espaçamento

                    //Publicação
                    Text(
                      'Ano de Publicação: ${widget.livro.publicacao}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16), //Espaçamento

                //Sinopse
                Wrap(
                  //Quebra de linha automática
                  children: [
                    Text(
                      'Sinopse: ${widget.livro.sinopse}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),

      /*
      body: Wrap(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                //width: MediaQuery.of(context).size.width * 1,
                child: Wrap(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 32), //Espaçamento
                            //Capa Livro
                            Image(
                              width: 150,
                              height: 300,
                              image: AssetImage(livro.capa),
                            ),
                          ],
                        ),

                        const SizedBox(width: 16), //Espaçamento

                        //Informações do Livro
                        Wrap(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Título
                                Text(
                                  livro.titulo,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 24), //Espaçamento

                                //Autor
                                Text(
                                  'Autor: ${livro.autor}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),

                                const SizedBox(height: 8), //Espaçamento

                                //Páginas
                                Text(
                                  'Páginas: ${livro.paginas}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),

                                const SizedBox(height: 8), //Espaçamento

                                //Editora
                                Text(
                                  'Editora: ${livro.editora}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),

                                const SizedBox(height: 8), //Espaçamento

                                //Publicação
                                Text(
                                  'Ano de Publicação: ${livro.publicacao}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16), //Espaçamento
                      ],
                    ),

                    //Sinopse
                    Wrap(
                      children: [
                        Text(
                          'Sinopse: ${livro.sinopse}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),*/
    );
  }
}
