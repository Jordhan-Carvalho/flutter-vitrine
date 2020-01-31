import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/product.dart';
import '../widgets/card_container.dart';
import '../widgets/theme_button.dart';
import '../widgets/favorite_button.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key key}) : super(key: key);
  static final routeName = '/product-detail';

  Widget _buildImages(Product prod) {
    List<NetworkImage> images = [];
    for (var image in prod.imageUrl) {
      images.add(NetworkImage(image));
    }

    return Carousel(
      images: images,
      dotSize: 3.0,
      dotSpacing: 10,
      indicatorBgPadding: 5,
      autoplayDuration: Duration(seconds: 6),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prod = ModalRoute.of(context).settings.arguments as Product;

    return Scaffold(
      body: CustomScrollView(
        // slivers = scrollable areas of the screen
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(prod.title),
              background: Hero(
                tag: prod.id,
                child: _buildImages(prod),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Card(
                color: Theme.of(context).canvasColor,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Chip(
                          backgroundColor: Colors.transparent,
                          avatar: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text('R\$'),
                          ),
                          label: Text(
                              '${NumberFormat("###,###", "pt_BR").format(prod.price).toString()}'),
                        ),
                        Chip(
                          backgroundColor: Colors.transparent,
                          avatar: CircleAvatar(
                            backgroundColor: Colors.white10,
                            child: Icon(
                              prod.condition == Condition.Novo
                                  ? Icons.new_releases
                                  : Icons.beenhere,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          label: Text('${describeEnum(prod.condition)}'),
                        ),
                        Chip(
                          backgroundColor: Colors.transparent,
                          avatar: CircleAvatar(
                            backgroundColor: Colors.white10,
                            child: Icon(
                              Icons.timer,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          label: Text(DateFormat('yMMMd', 'pt-BR')
                              .format(prod.createdOn)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        if (prod.delivery)
                          Chip(
                            backgroundColor: Colors.transparent,
                            avatar: CircleAvatar(
                              backgroundColor: Colors.white10,
                              child: Icon(
                                Icons.local_shipping,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            label: const Text('Entrega disponível'),
                          ),
                        if (prod.tradable)
                          Chip(
                            backgroundColor: Colors.transparent,
                            avatar: CircleAvatar(
                              backgroundColor: Colors.white10,
                              child: Icon(
                                Icons.autorenew,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            label: const Text('Aceita trocas'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      'Vendido por:',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  Text(
                    prod.ownerName ?? "falha",
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontStyle: FontStyle.italic,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 45.0),
                    child: Text(
                      prod.category,
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              CardContainer(
                height: 160,
                width: 300,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Descrição',
                      style: Theme.of(context).textTheme.title,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          child: Text(
                            prod.description,
                            textAlign: TextAlign.justify,
                            softWrap: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FavoriteButton(
                    prod: prod,
                  ),
                  ThemeButton(
                    content: Row(
                      children: <Widget>[
                        Text('Mensagem'),
                        Icon(MdiIcons.whatsapp),
                      ],
                    ),
                    handlePress: () {
                      FlutterOpenWhatsapp.sendSingleMessage(
                          "55${prod.telNumber}",
                          "Olá, vi que você está vendendo ${prod.title} no Vitrine... ainda está disponível?");
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Row(
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          color: Colors.amber,
                          icon: Icon(
                            Icons.flag,
                            color: Colors.red,
                            size: 20,
                          ),
                          tooltip: 'Reportar',
                          onPressed: () {},
                        ),
                        Text(
                          'Reportar',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
