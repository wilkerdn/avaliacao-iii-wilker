import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/cadastro.dart';
import 'package:http/http.dart' as http;
import '../utils/variaveis.dart';

class CadastroProvider with ChangeNotifier {
  List<Cadastro> _cadastro = [];
  String token;
  String idUsuario;

  CadastroProvider(this.token, this.idUsuario, this._cadastro);

  List<Cadastro> get getCadastro => [..._cadastro];

  void adicionarCadastro(Cadastro cadastro) {
    _cadastro.add(cadastro);
    notifyListeners();
  }

  Future<void> postCadastro(Cadastro cadastro) async {
    var url = Uri.https(Variaveis.BACKURL, '/cadastros.json');
    http
        .post(url,
            body: jsonEncode(
              {
                'nome': cadastro.nome,
                'cpf': cadastro.cpf,
                'grauescolaridade': cadastro.grauescolaridade,
                'foto': cadastro.foto,
                'idUsuario': '$idUsuario',
              },
            ))
        .then((value) {
      adicionarCadastro(cadastro);
    });
  }

  Future<void> deleteCadastro(Cadastro cadastro) async {
    var url = Uri.https(Variaveis.BACKURL, '/cadastros/${cadastro.id}.json');
    http.delete((url)).then((value) {
      buscaCadastro();
      notifyListeners();
    });
  }

  Future<void> buscaCadastro() async {
    var url = Uri.https(Variaveis.BACKURL, '/cadastros.json', {'auth': token});
    var resposta = await http.get(url);
    Map<String, dynamic> data = json.decode(resposta.body);
    _cadastro.clear();
    data.forEach((idCadastro, dadosCadastro) {
      if (dadosCadastro['idUsuario'].toString() == '$idUsuario') {
        adicionarCadastro(Cadastro(
          id: idCadastro,
          nome: dadosCadastro['nome'],
          cpf: dadosCadastro['cpf'],
          grauescolaridade: dadosCadastro['grauescolaridade'],
          foto: dadosCadastro['foto'],
          idUsuario: dadosCadastro['idUsuario'],
        ));
      }
    });
    notifyListeners();
  }
}
