import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DBLivraria {
  static Future<Database> getInstance() async {
    String dbname = 'livrariaV8.db';
    String path = await getDatabasesPath() + dbname;
    var instance = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onOpen: _onOpen,
      onUpgrade: _onUpgrade,
      onDowngrade: _onDowngrade,
    );

    return instance;
  }

  static Future<void> _onCreate(Database db, int version) async {
    //TABELA USUÁRIO
    await db.execute(
      'CREATE TABLE usuario ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
      'nome TEXT NOT NULL,'
      'email TEXT NOT NULL,'
      'telefone TEXT NOT NULL,'
      'senha TEXT NOT NULL)',
    );

    debugPrint(
        ' ########################### CRIANDO A TABELA USUÁRIO ########################### ');

    //TABELA LIVRO
    await db.execute(
      'CREATE TABLE livro ('
      'idLivro INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
      'codigo TEXT NOT NULL,'
      'capa TEXT NOT NULL,'
      'titulo TEXT NOT NULL,'
      'autor TEXT NOT NULL,'
      'paginas TEXT NOT NULL,'
      'editora TEXT NOT NULL,'
      'publicacao TEXT NOT NULL,'
      'sinopse TEXT NOT NULL)',
    );

    debugPrint(
        ' ########################### CRIANDO A TABELA LIVRO ########################### ');

    //TABELA FAVORITOS
    await db.execute(
      'CREATE TABLE favoritos ('
      'id_favoritos INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
      'idUsuario INTEGER NOT NULL,'
      'codigoLivro TEXT NOT NULL,'
      'FOREIGN KEY(idUsuario) REFERENCES usuario(id),'
      'FOREIGN KEY(codigoLivro) REFERENCES livro(codigo))',
    );

    debugPrint(
        ' ########################### CRIANDO A TABELA FAVORITOS ########################### ');
  }

  static Future<void> _onOpen(Database db) async {
    var version = await db.getVersion();
    debugPrint(
        ' ************** Abrindo banco de dados. Versão: $version ************** ');
  }

  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    // Executar scripts de alteração de banco de dados
    debugPrint(
        ' *********** Fazendo Upgrade da versão $oldVersion para a versão $newVersion *********** ');
  }

  static Future<void> _onDowngrade(
      Database db, int oldVersion, int newVersion) async {
    // Executar scripts de alteração de banco de dados
    debugPrint(
        ' *********** Fazendo Downgrade da versão $oldVersion para a versão $newVersion *********** ');
  }
}
