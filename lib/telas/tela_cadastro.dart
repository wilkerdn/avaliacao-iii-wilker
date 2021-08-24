import 'package:flutter/material.dart';
import '../providers/cadastro_providers.dart';
import '../componentes/drawer_personalizado.dart';
import '../componentes/item_cadastro.dart';
import '../providers/cadastro_providers.dart';
import '../utils/rotas.dart';
import 'package:provider/provider.dart';

class TelaCadastros extends StatefulWidget {
  @override
  _TelaCadastrosState createState() => _TelaCadastrosState();
}

class _TelaCadastrosState extends State<TelaCadastros> {
  bool _isLoading = false;
  Future<void> _atualizarLista(BuildContext context) {
    return Provider.of<CadastroProvider>(context, listen: false)
        .buscaCadastro();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<CadastroProvider>(context, listen: false)
        .buscaCadastro()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final carta = Provider.of<CadastroProvider>(context).getCadastro;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastros"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(Rotas.FORM_CADASTRO);
            },
          )
        ],
      ),
      drawer: DrawerPersonalisado(),
      body: RefreshIndicator(
        onRefresh: () => _atualizarLista(context),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: ListView.builder(
            itemCount: carta.length,
            itemBuilder: (ctx, i) => Column(
              children: [
                ItemListaCadastro(carta[i]),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
