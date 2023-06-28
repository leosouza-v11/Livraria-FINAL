import 'dart:convert';

class Favoritos {
  final int idUsuario;
  final String codigoLivro;

  Favoritos({
    required this.idUsuario,
    required this.codigoLivro,
  });

  Favoritos copyWith({
    int? idUsuario,
    String? codigoLivro,
  }) {
    return Favoritos(
      idUsuario: idUsuario ?? this.idUsuario,
      codigoLivro: codigoLivro ?? this.codigoLivro,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idUsuario': idUsuario,
      'codigoLivro': codigoLivro,
    };
  }

  factory Favoritos.fromMap(Map<String, dynamic> map) {
    return Favoritos(
      idUsuario: map['idUsuario'] as int,
      codigoLivro: map['codigoLivro'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Favoritos.fromJson(String source) =>
      Favoritos.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Favoritos(idUsuario: $idUsuario, codigoLivro: $codigoLivro)';

  @override
  bool operator ==(covariant Favoritos other) {
    if (identical(this, other)) return true;

    return other.idUsuario == idUsuario && other.codigoLivro == codigoLivro;
  }

  @override
  int get hashCode => idUsuario.hashCode ^ codigoLivro.hashCode;
}
