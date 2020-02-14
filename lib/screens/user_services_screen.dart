import 'package:flutter/material.dart';

import '../widgets/comming_soon.dart';
import '../widgets/main_drawer.dart';
import './buy_services.dart';

class UserServicesScreen extends StatelessWidget {
  const UserServicesScreen({Key key}) : super(key: key);
  static const routeName = '/user-services';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Meus serviços'),
          actions: <Widget>[
            FlatButton.icon(
                textColor: Colors.white,
                onPressed: () =>
                    Navigator.of(context).pushNamed(BuyServices.routeName),
                icon: Icon(Icons.group),
                label: Text("Anunciar"))
          ],
        ),
        drawer: MainDrawer(),
        body: Center(
          child: Text('Nenhum serviço anunciado'),
        ));
  }
}
