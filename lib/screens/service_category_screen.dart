import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/services.dart';
import '../widgets/service_item.dart';
import '../models/service.dart';

class ServiceCategoryScreen extends StatefulWidget {
  static const routeName = '/category-services';
  final String category;

  ServiceCategoryScreen(this.category);

  @override
  _ServiceCategoryScreenState createState() => _ServiceCategoryScreenState();
}

class _ServiceCategoryScreenState extends State<ServiceCategoryScreen> {
  String categoryTitle;
  List<Service> displayedMeals;
  var _isLoading = false;

  @override
  void initState() {
    //fetch items
    fetchServices(widget.category);
    super.initState();
  }

  Future<void> fetchServices(String category) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Services>(context, listen: false)
          .fetchCategory(category);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category}'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Container(
                  height: mediaQuery.size.height * 0.05,
                  child: Center(
                    child: Text(
                      "Filtro Dropdown",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer<Services>(
                    builder: (ctx, servicesData, child) {
                      return ListView.builder(
                        itemBuilder: (ctx, index) {
                          return ServiceItem(
                            service: servicesData.items[index],
                          );
                        },
                        itemCount: servicesData.items.length,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
