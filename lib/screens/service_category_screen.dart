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
  String dropdownValue = 'Todos';
  List<String> subcategories = ['Todos'];
  var _isLoading = false;

  @override
  void initState() {
    //fetch items
    fetchServices(widget.category);
    subcategories = [
      ...subcategories,
      ...Service.loadCategories[widget.category]['subcategory']
    ];
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Filtro: ',
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: subcategories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Expanded(
                  child: Consumer<Services>(
                    builder: (ctx, servicesData, child) {
                      if (servicesData.items.length == 0 ||
                          dropdownValue != "Todos" &&
                              servicesData
                                      .filterBySubcategories(dropdownValue)
                                      .length ==
                                  0) {
                        return Center(
                          child: Text('Sem prestadores de serviço nessa area'),
                        );
                      } else {
                        return ListView.builder(
                          itemBuilder: (ctx, index) {
                            if (dropdownValue == 'Todos') {
                              return ServiceItem(
                                service: servicesData.items[index],
                              );
                            } else {
                              return ServiceItem(
                                service: servicesData.filterBySubcategories(
                                    dropdownValue)[index],
                              );
                            }
                          },
                          itemCount: dropdownValue == 'Todos'
                              ? servicesData.items.length
                              : servicesData
                                  .filterBySubcategories(dropdownValue)
                                  .length,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
