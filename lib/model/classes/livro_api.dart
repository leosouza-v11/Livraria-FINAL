import 'dart:convert';

import 'package:http/http.dart' as http;

class LivroApi {
  final int? idLivro;
  final String codigo;
  final String? capa;
  final String titulo;
  final String? autor;
  final String? paginas;
  final String? editora;
  final String? publicacao;
  final String sinopse;

  LivroApi({
    this.idLivro,
    required this.codigo,
    required this.capa,
    required this.titulo,
    required this.autor,
    required this.paginas,
    required this.editora,
    required this.publicacao,
    required this.sinopse,
  });

  static Future<List<LivroApi>> pesquisaLivros(String pesquisa) async {
    const chaveApi = 'AIzaSyBtCAKKRTjNZi7VMdeEX3FtAImFaVumEzs';
    final url =
        //'https://www.googleapis.com/books/v1/volumes?q=$pesquisa&maxResults=30&key=$chaveApi';
        'https://www.googleapis.com/books/v1/volumes?q=id:$pesquisa&key=$chaveApi';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final items = responseData['items'];

      if (items != null) {
        List<LivroApi> listaLivros = [];

        for (var item in items) {
          var codigo = item['id'];
          var volumeInfo = item['volumeInfo'];
          final Map<String?, dynamic>? imageLinks = volumeInfo['imageLinks'];

          var capa = imageLinks?['thumbnail'];
          var titulo = volumeInfo['title'] ?? 'Título Desconhecido';
          var autor = volumeInfo['authors'] != null
              ? volumeInfo['authors'][0]
              : 'Autor Desconhecido';
          var paginas = volumeInfo['pageCount']?.toString() ?? '0';
          var editora = volumeInfo['publisher'];
          var publicacao = volumeInfo['publishedDate'];
          var sinopse = volumeInfo['description'];

          LivroApi livro = LivroApi(
            codigo: codigo,
            capa: capa ??
                'https://jbinstrumentos.com.br/wp-content/uploads/2021/04/sem-imagem.jpg',
            titulo: titulo,
            autor: autor,
            paginas: paginas,
            editora: editora ?? '',
            publicacao: publicacao ?? '',
            sinopse: sinopse ?? '',
          );

          listaLivros.add(livro);
        }

        return listaLivros;
      }
    }

    // Em caso de erro ou se nenhum livro for encontrado, retorna uma lista vazia
    return [];
  }

  LivroApi copyWith({
    String? codigo,
    String? capa,
    String? titulo,
    String? autor,
    String? paginas,
    String? editora,
    String? publicacao,
    String? sinopse,
  }) {
    return LivroApi(
      codigo: codigo ?? this.codigo,
      capa: capa ?? this.capa,
      titulo: titulo ?? this.titulo,
      autor: autor ?? this.autor,
      paginas: paginas ?? this.paginas,
      editora: editora ?? this.editora,
      publicacao: publicacao ?? this.publicacao,
      sinopse: sinopse ?? this.sinopse,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'codigo': codigo,
      'capa': capa,
      'titulo': titulo,
      'autor': autor,
      'paginas': paginas,
      'editora': editora,
      'publicacao': publicacao,
      'sinopse': sinopse,
    };
  }

  factory LivroApi.fromMap(Map<String, dynamic> map) {
    return LivroApi(
      codigo: map['codigo'] as String,
      capa: map['capa'] as String,
      titulo: map['titulo'] as String,
      autor: map['autor'] as String,
      paginas: map['paginas'] as String,
      editora: map['editora'] as String,
      publicacao: map['publicacao'] as String,
      sinopse: map['sinopse'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LivroApi.fromJson(String source) =>
      LivroApi.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LivroApi(codigo: $codigo, capa: $capa, titulo: $titulo, autor: $autor, paginas: $paginas, editora: $editora, publicacao: $publicacao, sinopse: $sinopse)';
  }

  @override
  bool operator ==(covariant LivroApi other) {
    if (identical(this, other)) return true;

    return other.codigo == codigo &&
        other.capa == capa &&
        other.titulo == titulo &&
        other.autor == autor &&
        other.paginas == paginas &&
        other.editora == editora &&
        other.publicacao == publicacao &&
        other.sinopse == sinopse;
  }

  @override
  int get hashCode {
    return codigo.hashCode ^
        capa.hashCode ^
        titulo.hashCode ^
        autor.hashCode ^
        paginas.hashCode ^
        editora.hashCode ^
        publicacao.hashCode ^
        sinopse.hashCode;
  }
}
