import 'package:flutter/material.dart';
import 'telas/tela_form_cadastros.dart';
import 'telas/tela_auth_ou_home.dart';
import 'telas/tela_login.dart';
import 'providers/login.dart';
import 'providers/cadastro_providers.dart';
import 'telas/tela_cadastro.dart';
import 'utils/rotas.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Login(),
        ),
        ChangeNotifierProxyProvider<Login, CadastroProvider>(
          create: (ctx) => CadastroProvider('', '', []),
          update: (ctx, login, carta) =>
              CadastroProvider(login.token, login.idUsuario, carta.getCadastro),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        routes: {
          Rotas.AUTH: (ctx) => TelaEscolheHome(),
          Rotas.HOME: (ctx) => TelaCadastros(),
          Rotas.FORM_CADASTRO: (ctx) => TelaFormCadastros(),
        },
        onGenerateRoute: (settings) {
          print(settings.name);
          return null;
        },
        onUnknownRoute: (settings) {
          print("Rota não encontrada");
          return null;
        },
      ),
    );
  }
}
