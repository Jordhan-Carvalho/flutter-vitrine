import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/consts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key key}) : super(key: key);

  static const routeName = "/about";

  void _launchURL(String portUrl) async {
    final url = portUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Falha em abrir $url';
    }
  }

  Future<String> _fetchVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    return "$version+$buildNumber";
  }

  @override
  Widget build(BuildContext context) {
    // final String version = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
      ),
      // drawer: MainDrawer(),
      body: FutureBuilder<String>(
          future: _fetchVersion(),
          builder: (context, snapshot) {
            return Column(children: [
              Image(
                image:
                    AssetImage('assets/images/vtn-black-transparent-cut.png'),
                height: 130,
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                'Versão: ${snapshot.data}',
                style: TextStyle(color: Colors.grey),
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
                      onTap: () =>
                          _launchURL("https://vitrinevirtual.app/privacidade"),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.library_books,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text('Termos de uso'),
                      onTap: () =>
                          _launchURL("https://vitrinevirtual.app/termos"),
                    ),
                    ListTile(
                      leading: Icon(
                        MdiIcons.whatsapp,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text('Fale conosco'),
                      onTap: () {
                        print(Consts.vitrineNumber);
                        FlutterOpenWhatsapp.sendSingleMessage(
                            Consts.vitrineNumber, "Olá !");
                      },
                    ),
                  ],
                ),
              ),
            ]);
          }),
    );
  }
}
