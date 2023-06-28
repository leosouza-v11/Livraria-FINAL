import 'dart:convert';

class Usuario {
  final int? id; //Null
  final String nome;
  final String email;
  final String telefone;
  final String senha;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.senha,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'senha': senha,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] != null ? map['id'] as int : null,
      nome: map['nome'] as String,
      email: map['email'] as String,
      telefone: map['telefone'] as String,
      senha: map['senha'] as String,
    );
  }

  Usuario copyWith({
    int? id,
    String? nome,
    String? email,
    String? telefone,
    String? senha,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      senha: senha ?? this.senha,
    );
  }

  String toJson() => json.encode(toMap());

  factory Usuario.fromJson(String source) =>
      Usuario.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Usuario(id: $id, nome: $nome, email: $email, telefone: $telefone, senha: $senha)';
  }

  @override
  bool operator ==(covariant Usuario other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nome == nome &&
        other.email == email &&
        other.telefone == telefone &&
        other.senha == senha;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        email.hashCode ^
        telefone.hashCode ^
        senha.hashCode;
  }
}
