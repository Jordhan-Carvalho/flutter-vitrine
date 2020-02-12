import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import '../models/service.dart';
import '../widgets/carousel_pro.dart';

class ServiceDetailScreen extends StatelessWidget {
  static const routeName = '/service-detail';

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
        maxHeight: mediaQuery.size.height * 0.3,
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
        child: Icon(MdiIcons.whatsapp),
        onPressed: () {
          FlutterOpenWhatsapp.sendSingleMessage("55${service.telNumber}",
              "Olá ${service.title}, te achei no Vitrine Virtual e estou interessado na sua prestação de serviço Vitrine... está disponível?");
        },
      ),
      body: CustomScrollView(
        // slivers = scrollable areas of the screen
        slivers: <Widget>[
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
          SliverList(
            delegate: SliverChildListDelegate([
              Column(
                children: <Widget>[
                  _buildSectionTitle("Descrição", context),
                  _buildContainer(
                      Card(
                        // color: Theme.of(context).accentColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Text(service.description),
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
                  )
                ],
              ),
              SizedBox(
                height: 200,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
