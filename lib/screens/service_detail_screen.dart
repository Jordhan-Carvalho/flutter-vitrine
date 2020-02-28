import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/service.dart';
import '../widgets/carousel_pro.dart';

class ServiceDetailScreen extends StatelessWidget {
  static const routeName = '/service-detail';

  void _launchURL(String portUrl) async {
    final url = portUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Falha em abrir $url';
    }
  }

  Widget _buildImages(Service service) {
    List<FadeInImage> images = [];
    for (var image in service.imagesUrl) {
      images.add(FadeInImage(
        placeholder: AssetImage('assets/images/FEDTpyE.gif'),
        image: NetworkImage(image),
        fit: BoxFit.cover,
      ));
    }

    return Carousel(
      images: images,
      dotSize: 3.0,
      dotSpacing: 10,
      indicatorBgPadding: 5,
      autoplayDuration: Duration(seconds: 7),
      borderRadius: false,
    );
  }

// those methods could be separeted widgets
  Widget _buildSectionTitle(String text, BuildContext ctx) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(ctx).textTheme.title,
      ),
    );
  }

  Widget _buildContainer(Widget child, MediaQueryData mediaQuery) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      // height: mediaQuery.size.height * 0.4,
      constraints: new BoxConstraints(
        maxHeight: mediaQuery.size.height * 0.4,
      ),
      width: mediaQuery.size.width * 0.98,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = ModalRoute.of(context).settings.arguments as Service;
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          MdiIcons.whatsapp,
          color: Colors.white,
        ),
        onPressed: () {
          FlutterOpenWhatsapp.sendSingleMessage("55${service.telNumber}",
              "Olá ${service.title}, te achei no Vitrine Virtual e estou interessado(a) na sua prestação de serviço... está disponível?");
        },
      ),
      body: CustomScrollView(
        // slivers = scrollable areas of the screen
        slivers: <Widget>[
          if (service.tier == Tier.Premium)
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: DecoratedBox(
                  // position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(service.title),
                ),
                background: Hero(
                  tag: service.id,
                  child: _buildImages(service),
                ),
              ),
            ),
          if (service.tier == Tier.Basic)
            SliverAppBar(
              // expandedHeight: 50,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(service.title),
              ),
            ),
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                children: <Widget>[
                  if (service.portfolio != '' && service.portfolio != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton.icon(
                        onPressed: () => _launchURL(service.portfolio),
                        icon: Icon(
                          Icons.work,
                        ),
                        label: Text('Portfólio'),
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.white)),
                      ),
                    ),
                  _buildSectionTitle("Descrição", context),
                  _buildContainer(
                      Card(
                        color: Colors.white,
                        elevation: 0,
                        child: Text(
                          service.description,
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ),
                      mediaQuery),
                  _buildSectionTitle("Serviços", context),
                  _buildContainer(
                    ListView.builder(
                      itemCount: service.serviceTags.length,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                child: Text('# ${index + 1}'),
                              ),
                              title: Text(service.serviceTags[index]),
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                    mediaQuery,
                  ),
                ],
              ),
              SizedBox(
                height: 100,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
