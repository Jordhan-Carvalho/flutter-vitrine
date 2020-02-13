import 'package:flutter/material.dart';

import '../widgets/service_category_item.dart';
import '../models/service.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          expandedHeight: mediaQuery.size.height * 0.15,
          flexibleSpace: FlexibleSpaceBar(
            background: Center(
              child: Text(
                "Para a sua segurança, os profissionais listados são verificados e aprovados manualmente, assim, evitando fraudes.",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17 * mediaQuery.textScaleFactor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ServiceCategoryItem(
                Service.loadCategories.keys.toList()[index],
                Service.loadCategories.values.toList()[index]['subcategory'],
                Service.loadCategories.values.toList()[index]['icon'],
              );
            },
            childCount: Service.loadCategories.length,
          ),
        ),
      ],
    );
  }
}
