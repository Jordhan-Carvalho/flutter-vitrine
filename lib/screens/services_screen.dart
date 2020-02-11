import 'package:flutter/material.dart';

import '../widgets/service_item_list.dart';
import '../models/service.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      children: <Widget>[
        Container(
          height: mediaQuery.size.height * 0.1,
          child: Center(
            child: Text(
              "Somente profissionais certificados e bla bla participam de uma triagem bla bla bla",
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (ctx, index) {
              return ServiceItemList(
                Service.loadCategories.keys.toList()[index],
                Service.loadCategories.values.toList()[index]['subcategory'],
                Service.loadCategories.values.toList()[index]['icon'],
              );
            },
            itemCount: Service.loadCategories.length,
          ),
        )
      ],
    );
  }
}
