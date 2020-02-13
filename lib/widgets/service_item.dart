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
            if (service.tier == Tier.Premium)
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
                      child: FadeInImage(
                        height: 150,
                        width: double.infinity,
                        placeholder: const AssetImage(
                          'assets/images/FEDTpyE.gif',
                        ),
                        image: NetworkImage(service.imagesUrl[0]),
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
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
            if (service.tier == Tier.Basic)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  service.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.title,
                ),
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
