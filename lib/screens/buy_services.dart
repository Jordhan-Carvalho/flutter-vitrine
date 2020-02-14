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
    'Link para site/portfólio externo',
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
      "https://www.aulasintelectu.com.br/imagens/aulas-particular-de-ingles-precos-no-jardim-sao-paulo.jpg",
      "https://www.b-lab.us/wp-content/uploads/2019/07/imagem-4.jpg",
      "https://abrilexame.files.wordpress.com/2017/01/ryan-mcvay.jpg"
    ],
    id: "idTeste",
    ownerId: "ownerTest",
    city: City.Barreiras,
    createdOn: DateTime.now(),
    portfolio: 'https://fik.com.br',
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
    // portfolio: '',
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
                  "Para evitar fraudes, todo processo é feito manualmente através do contato fornecido abaixo, no qual o anunciante irá fornecer as informações pertinentes para verificação e cadastro.",
                  textScaleFactor: 1.3,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Plano Mensal Básico R\$25.00",
                  style: Theme.of(context).textTheme.title,
                )),
            Text(
              "*10% de desconto no plano anual (R\$ 22.50)",
              style: TextStyle(color: Colors.grey),
            ),
            BenefitsItem(benefitsBasic),
            Padding(
              padding: const EdgeInsets.only(right: 300.0),
              child: Text(
                "Exemplo",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ServiceItem(service: serviceBasic),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Plano Mensal Premium R\$50.00",
                  style: Theme.of(context).textTheme.title,
                )),
            Text(
              "*10% de desconto no plano anual (R\$ 45.00)",
              style: TextStyle(color: Colors.grey),
            ),
            BenefitsItem(benefitsPremium),
            Padding(
              padding: const EdgeInsets.only(right: 300.0),
              child: Text(
                "Exemplo",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ServiceItem(service: service),
            SizedBox(
              height: 30,
            ),
            RaisedButton.icon(
              color: Theme.of(context).primaryColor,
              onPressed: () {
                FlutterOpenWhatsapp.sendSingleMessage("5577991116269",
                    "Olá, estou interessado em anunciar prestação de serviço no Vitrine... como proceder?");
              },
              icon: Icon(MdiIcons.whatsapp),
              label: Text("Entrar em contato"),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white)),
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
