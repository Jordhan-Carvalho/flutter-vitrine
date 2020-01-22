import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../providers/product.dart';
import '../providers/products.dart';
import '../models/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  // Global key to interact with a widget inside the code, in this case Form
  final _form = GlobalKey<FormState>();
  var _editedProd = Product(
    id: null,
    title: '',
    price: 0,
    telNumber: 77,
    description: '',
    condition: Condition.Usado,
    imageUrl: [],
    category: null,
    delivery: false,
    tradable: false,
  );
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final prodId = ModalRoute.of(context).settings.arguments as String;
      if (prodId != null) {
        _editedProd =
            Provider.of<Products>(context, listen: false).findById(prodId);
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    print(_editedProd.id);
    print(_editedProd.title);
    print(_editedProd.category);
    print(_editedProd.condition);
    print(_editedProd.delivery);
    print(_editedProd.description);
    print(_editedProd.price);
    print(_editedProd.telNumber);

    setState(() {
      _isLoading = true;
    });
    if (_editedProd.id != null) {
      // await Provider.of<Products>(context, listen: false)
      //     .updateProduct(_editedProd.id, _editedProd);
    } else {
      try {
        // await Provider.of<Products>(context, listen: false)
        //     .addProduct(_editedProd);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                // autovalidate: true,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _editedProd.title,
                        decoration: InputDecoration(labelText: 'Título'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Por favor preencha o campo";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProd = Product(
                            tradable: _editedProd.tradable,
                            telNumber: _editedProd.telNumber,
                            category: _editedProd.category,
                            delivery: _editedProd.delivery,
                            condition: _editedProd.condition,
                            id: _editedProd.id,
                            title: value,
                            price: _editedProd.price,
                            imageUrl: _editedProd.imageUrl,
                            description: _editedProd.description,
                          );
                        },
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              initialValue: _editedProd.price.toString(),
                              decoration: InputDecoration(labelText: 'Preço'),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              focusNode: _priceFocusNode,
                              onFieldSubmitted: (_) =>
                                  FocusScope.of(context).nextFocus(),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Por favor preencha o campo";
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Coloque um valor valido';
                                }
                                if (int.parse(value) <= 0) {
                                  return 'Valor precisa ser maior que 0';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProd = Product(
                                  tradable: _editedProd.tradable,
                                  telNumber: _editedProd.telNumber,
                                  category: _editedProd.category,
                                  delivery: _editedProd.delivery,
                                  condition: _editedProd.condition,
                                  id: _editedProd.id,
                                  title: _editedProd.title,
                                  price: int.parse(value),
                                  imageUrl: _editedProd.imageUrl,
                                  description: _editedProd.description,
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                RadioListTile<Condition>(
                                  title: const Text('Usado'),
                                  value: Condition.Usado,
                                  groupValue: _editedProd.condition,
                                  activeColor:
                                      Theme.of(context).primaryColorDark,
                                  onChanged: (Condition value) {
                                    setState(() {
                                      _editedProd.condition = value;
                                    });
                                  },
                                ),
                                RadioListTile<Condition>(
                                  title: const Text('Novo'),
                                  value: Condition.Novo,
                                  groupValue: _editedProd.condition,
                                  activeColor:
                                      Theme.of(context).primaryColorDark,
                                  onChanged: (Condition value) {
                                    setState(() {
                                      _editedProd.condition = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 30.0),
                              child: TextFormField(
                                initialValue: _editedProd.telNumber.toString(),
                                decoration: InputDecoration(
                                    labelText: 'Número WhatsApp',
                                    helperText: 'Formato: 77991114567'),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                                onFieldSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Por favor preencha o campo";
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Coloque um valor valido';
                                  }
                                  if (int.parse(value) <= 10000000000) {
                                    return 'Valor precisa incluir o DDD';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProd.telNumber = int.parse(value);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: DropdownButton<String>(
                              value: _editedProd.category,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 20,
                              elevation: 16,
                              hint: Text('Categoria'),
                              iconEnabledColor: Theme.of(context).primaryColor,
                              isExpanded: true,
                              // isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  _editedProd.category = newValue;
                                });
                              },
                              items: Product.loadCategories
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Opções",
                        style: Theme.of(context).textTheme.title,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text(
                                'Aceita Troca?',
                                style: TextStyle(fontSize: 15),
                              ),
                              value: _editedProd.tradable,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) {
                                setState(() {
                                  _editedProd.tradable = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text(
                                'Entrega na Residência?',
                                style: TextStyle(fontSize: 15),
                              ),
                              value: _editedProd.delivery,
                              activeColor: Theme.of(context).primaryColor,
                              onChanged: (bool value) {
                                setState(() {
                                  _editedProd.delivery = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: _editedProd.description,
                        decoration: InputDecoration(labelText: 'Descrição'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Por favor preencha o campo';
                          }
                          if (value.length < 10) {
                            return 'Por favor aumente a sua descrição.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProd = Product(
                            tradable: _editedProd.tradable,
                            telNumber: _editedProd.telNumber,
                            category: _editedProd.category,
                            delivery: _editedProd.delivery,
                            condition: _editedProd.condition,
                            id: _editedProd.id,
                            title: _editedProd.title,
                            price: _editedProd.price,
                            imageUrl: _editedProd.imageUrl,
                            description: value,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
