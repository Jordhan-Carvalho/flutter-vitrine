import 'package:flutter/material.dart';

import '../models/service.dart';
import '../screens/service_detail_screen.dart';

class ServiceItem extends StatelessWidget {
  final Service service;

  const ServiceItem({@required this.service});

  @override
  Widget build(BuildContext context) {
    // Same thing as Gesture but with ripple effect
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ServiceDetailScreen.routeName, arguments: service);
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                //Clip force the widget to take a certain form
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Hero(
                    tag: service.id,
                    //TODO change to fadeinimage with placehold
                    child: Image.network(
                      service.imagesUrl[0],
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                //only workns inside Stack
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    width: 300,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                    child: Text(
                      service.title,
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(
                    Icons.info,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      service.slogan,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
