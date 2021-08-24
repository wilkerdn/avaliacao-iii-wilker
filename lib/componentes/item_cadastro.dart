//import 'dart:html';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/cadastro.dart';
import '../providers/cadastro_providers.dart';
import '../utils/rotas.dart';
import 'package:provider/provider.dart';

class ItemListaCadastro extends StatelessWidget {
  final Cadastro cadastro;
  File image;

  ItemListaCadastro(this.cadastro);

  void deleteCadastro(context, Cadastro cadastro) {
    Provider.of<CadastroProvider>(context, listen: false)
        .deleteCadastro(cadastro);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.file(
        File(cadastro.foto),
        fit: BoxFit.cover,
      ),
      contentPadding: EdgeInsets.all(15),
      tileColor: Colors.black12,
      title: Container(
        child: Text(
          '${cadastro.nome}\n${cadastro.cpf}\n${cadastro.grauescolaridade}',
          style: TextStyle(color: Colors.black),
        ),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            Expanded(
              child: IconButton(
                iconSize: 20,
                icon: Icon(
                  Icons.delete,
                  color: Colors.black,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("ATENÇÃO"),
                      content: Text("Está certo disso?"),
                      actions: [
                        TextButton(
                            child: Text("Não"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        TextButton(
                            child: Text("Sim"),
                            onPressed: () {
                              deleteCadastro(context, cadastro);
                              Navigator.of(context).pop();
                            })
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
