import 'package:flutter/material.dart';

class Cadastro {
  final String id;
  final String nome;
  final String cpf;
  final String grauescolaridade;
  final String foto;
  final String idUsuario;

  const Cadastro({
    @required this.id,
    @required this.nome,
    @required this.cpf,
    @required this.grauescolaridade,
    @required this.foto,
    this.idUsuario,
  });
}
