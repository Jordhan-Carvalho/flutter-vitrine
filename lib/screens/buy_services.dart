import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import '../models/service.dart';
import '../widgets/service_item.dart';
import '../widgets/benefits_item.dart';

class BuyServices extends StatelessWidget {
  BuyServices({Key key}) : super(key: key);
  static const routeName = "/buy-service";

  final List<String> benefitsPremium = [
    'Até 2x mais visualizações',
    'Banner no anúncio',
    'Prioridade na ordem de visualização',
    'Até 4 imagens para exibição',
  ];

  final List<String> benefitsBasic = [
    'Alto índice de visualizações',
  ];

  final Service service = Service(
    category: "Aulas",
    description:
        "Professor formado em Letras e certificado CELTA Cambridge. 17 anos de experiência e mais de 700 aulas realizadas no Profes.",
    title: "Professor de Inglês",
    serviceTags: [
      "Aulas particulares de Inglês",
      "Correção de provas",
      "Planos de acompanhamento de estudos",
      "Aulas em grupo"
    ],
    slogan: "Professor de Inglês formado em Letras",
    approved: true,
    tier: Tier.Premium,
    telNumber: 77991116269,
    subcategory: "Acadêmicos",
    imagesUrl: [
      "https://img.olx.com.br/images/20/202912034932897.jpg",
      "https://www.aulasintelectu.com.br/imagens/aulas-particular-de-ingles-precos-no-jardim-sao-paulo.jpg"
    ],
    id: "idTeste",
    ownerId: "ownerTest",
    city: City.Barreiras,
    createdOn: DateTime.now(),
  );
  final Service serviceBasic = Service(
    category: "Aulas",
    description:
        "Professor formado em Letras e certificado CELTA Cambridge. 17 anos de experiência e mais de 700 aulas realizadas no Profes.",
    title: "Professor de Inglês",
    serviceTags: [
      "Aulas particulares de Inglês",
      "Correção de provas",
      "Planos de acompanhamento de estudos",
      "Aulas em grupo"
    ],
    slogan: "Professor de Inglês formado em Letras",
    approved: true,
    tier: Tier.Basic,
    telNumber: 77991116269,
    subcategory: "Acadêmicos",
    imagesUrl: [
      "https://img.olx.com.br/images/20/202912034932897.jpg",
      "https://www.aulasintelectu.com.br/imagens/aulas-particular-de-ingles-precos-no-jardim-sao-paulo.jpg"
    ],
    id: "idTeste",
    ownerId: "ownerTest",
    city: City.Barreiras,
    createdOn: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anunciar"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              // height: 300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Texto explicando os planos e tal porque devemos sempre agir conforme a lei do escambal e tal e grande pa carai doido mano para com isso",
                  textScaleFactor: 1.3,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Plano Premium R\$50.00",
                  style: Theme.of(context).textTheme.title,
                )),
            BenefitsItem(benefitsPremium),
            ServiceItem(service: service),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Plano Básico R\$25.00",
                  style: Theme.of(context).textTheme.title,
                )),
            BenefitsItem(benefitsBasic),
            ServiceItem(service: serviceBasic),
            SizedBox(
              height: 15,
            ),
            RaisedButton.icon(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                FlutterOpenWhatsapp.sendSingleMessage("55${service.telNumber}",
                    "Olá ${service.title}, te achei no Vitrine Virtual e estou interessado na sua prestação de serviço Vitrine... está disponível?");
              },
              icon: Icon(MdiIcons.whatsapp),
              label: Text("Entrar em contato"),
              textColor: Colors.white,
            ),
            SizedBox(
              height: 150,
            )
          ],
        ),
      ),
    );
  }
}
