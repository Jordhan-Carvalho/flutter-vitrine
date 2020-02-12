import 'package:flutter/material.dart';

import '../screens/service_category_screen.dart';

class ServiceCategoryItem extends StatelessWidget {
  final String category;
  final List<String> subcategories;
  final Icon icon;

  ServiceCategoryItem(this.category, this.subcategories, this.icon);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ServiceCategoryScreen.routeName, arguments: category);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: icon,
                ),
              ),
            ),
            title: Text(category),
            subtitle: Text('${subcategories.join(", ")}'),
          ),
        ),
      ),
    );
  }
}
