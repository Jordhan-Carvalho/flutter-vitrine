import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import '../widgets/main_drawer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key key}) : super(key: key);

  static const routeName = "/about";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
      ),
      // drawer: MainDrawer(),
      body: Column(children: [
        Image(
          image: AssetImage('assets/images/logo-preto-menor.png'),
          height: 130,
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.lock_open,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('Política de Privacidade'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.library_books,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('Termos de uso'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  MdiIcons.whatsapp,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text('Fale conosco'),
                onTap: () {
                  FlutterOpenWhatsapp.sendSingleMessage(
                      "5577991116269", "Olá !");
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
