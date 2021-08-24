//cadastro.fotoimport 'dart:html';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../componentes/foto.dart';
import '../models/cadastro.dart';
import '../providers/cadastro_providers.dart';
import 'package:provider/provider.dart';

class TelaFormCadastros extends StatefulWidget {
  @override
  TelaFormCadastrosState createState() => TelaFormCadastrosState();
}

String dropdownValue = 'Ensino médio incompleto';

class TelaFormCadastrosState extends State<TelaFormCadastros> {
  final form = GlobalKey<FormState>();
  final dadosForm = Map<String, Object>();
  File imagem = null;

  fotografar() async {
    final ImagePicker picker = ImagePicker();
    try {
      final arquivoImagem = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
        preferredCameraDevice: CameraDevice.front,
      );
      if (arquivoImagem == null) return;

      setState(() {
        imagem = File(arquivoImagem.path);
        dadosForm['foto'] = arquivoImagem.path;
        print('teste:');
        print(dadosForm['foto']);
      });
    } catch (e) {
      print('Catch fotografar:\n$e');
    }
  }

  void saveForm(context, Cadastro cadastro) {
    var formValido = form.currentState.validate();

    form.currentState.save();

    final novoCadastro = Cadastro(
        id: cadastro != null ? cadastro.id : cadastro,
        nome: dadosForm['nome'],
        cpf: dadosForm['cpf'],
        grauescolaridade: dadosForm['grauescolaridade'],
        foto: dadosForm['foto']);

    if (formValido) {
      if (cadastro != null) {
        Provider.of<CadastroProvider>(context, listen: false)
            .postCadastro(novoCadastro);
        dropdownValue = cadastro.cpf;
        Navigator.of(context).pop();
      } else {
        Provider.of<CadastroProvider>(context, listen: false)
            .postCadastro(novoCadastro);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cadastro = ModalRoute.of(context).settings.arguments as Cadastro;
    print(cadastro);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Dados"),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                saveForm(context, cadastro);
              })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                initialValue: cadastro != null ? cadastro.nome : '',
                onSaved: (value) {
                  dadosForm['nome'] = value;
                },
                validator: (value) {
                  if (value.trim().isEmpty) {
                    return "Informe um nome válido";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'CPF'),
                textInputAction: TextInputAction.done,
                onSaved: (value) {
                  dadosForm['cpf'] = value;
                },
                initialValue: cadastro != null ? cadastro.cpf : '',
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Grau de escolaridade',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ),
              DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_downward, color: Colors.blue),
                iconSize: 24,
                elevation: 20,
                itemHeight: 60,
                underline: Container(
                  height: 2,
                  color: Colors.grey,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                    dadosForm['grauescolaridade'] = newValue;
                  });
                },
                items: <String>[
                  'Ensino médio incompleto',
                  'Ensino médio completo',
                  'Ensino superior incompleto',
                  'Ensino superiro completo',
                  'Mestrado',
                  'Doutorado'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Divider(),
              Container(
                width: 180,
                height: 100,
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 1,
                  color: Colors.blue,
                )),
                alignment: Alignment.center,
                child: cadastro != null
                    ? Image.file(
                        imagem != null ? imagem : File(cadastro.foto),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Text("Nenhuma imagem!"),
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                icon: Icon(Icons.camera),
                onPressed: fotografar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
