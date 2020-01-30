import 'package:flutter/material.dart';

import '../screens/categorie_overview_screen.dart';

class CategoryItem extends StatelessWidget {
  final String category;
  final String imgPath;
  const CategoryItem({Key key, this.category, this.imgPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(CategorieOverviewScreen.routeName, arguments: category);
      },
      child: Card(
        margin: const EdgeInsets.all(2),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                //Clip force the widget to take a certain form
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Image.asset(
                    imgPath,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                //only workns inside Stack
                Positioned(
                  bottom: 20,
                  // right: 10,
                  child: Container(
                    width: 170,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    child: Text(
                      category,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
