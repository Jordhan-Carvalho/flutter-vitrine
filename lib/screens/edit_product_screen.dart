import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../providers/product.dart';
import '../providers/products.dart';
import '../models/products.dart';
import '../widgets/image_capture.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = '/test';
  @override
  _EditProductScreenState createState() => new _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  // Global key to interact with a widget inside the code, in this case Form
  // final _form = GlobalKey<FormState>();
  List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
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
  bool _autoValidate = false;
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

  bool _validateInputs([BuildContext ctx]) {
    if (_editedProd.category == null) {
      // None of the radio buttons was selected
      Scaffold.of(ctx)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Selecione uma categoria'),
          duration: Duration(milliseconds: 1500),
        ));
      return false;
    } else {
      return true;
    }
  }

  void _saveForm() async {
    // _validateInputs();
    // final isValid = _formKeys[0].currentState.validate();
    // if (!isValid) {
    //   return;
    // }
    // _formKeys[0].currentState.save();
    // _formKeys[1].currentState.save();
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

  //STEPPER
  int _currentStep = 0;
  bool complete = false;

  void _next([BuildContext ctx]) {
    if (_formKeys[_currentStep].currentState.validate() &&
        _validateInputs(ctx)) {
      _formKeys[_currentStep].currentState.save();
      _currentStep++;
      // _currentStep + 1 != steps.length
      _currentStep + 1 != 2
          ? _goTo(_currentStep + 1)
          : setState(() => complete = true);
    } else {
      setState(() => _autoValidate = true);
      _validateInputs(ctx);
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      _goTo(_currentStep - 1);
    }
  }

  void _goTo(int step) {
    setState(() => _currentStep = step);
  }

  Widget _customButtons(BuildContext context,
      {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _currentStep == 1 // this is the last step
              ? RaisedButton.icon(
                  icon: Icon(Icons.create),
                  onPressed: _saveForm,
                  label: Text('CREATE'),
                  color: Colors.green,
                )
              : RaisedButton.icon(
                  icon: Icon(Icons.navigate_next),
                  onPressed: onStepContinue,
                  label: Text('CONTINUE'),
                  color: Colors.pink,
                ),
          FlatButton.icon(
            icon: Icon(Icons.delete_forever),
            label: const Text('CANCEL'),
            onPressed: onStepCancel,
          )
        ],
      ),
    );
  }

  //STEPPER

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Builder(
              builder: (context) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Stepper(
                        type: StepperType.horizontal,
                        currentStep: _currentStep,
                        onStepTapped: (step) => _goTo(step),
                        controlsBuilder: (BuildContext context,
                                {VoidCallback onStepContinue,
                                VoidCallback onStepCancel}) =>
                            _customButtons(context,
                                onStepContinue: () => _next(context),
                                onStepCancel: _cancel),
                        steps: [
                          Step(
                            title: const Text('New Account'),
                            isActive: _currentStep >= 0,
                            state: StepState.complete,
                            content: Form(
                              key: _formKeys[0],
                              autovalidate: _autoValidate,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    initialValue: _editedProd.title,
                                    decoration:
                                        InputDecoration(labelText: 'Título'),
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) {
                                      FocusScope.of(context)
                                          .requestFocus(_priceFocusNode);
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Por favor preencha o campo";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _editedProd.title = value;
                                    },
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextFormField(
                                          initialValue:
                                              _editedProd.price.toString(),
                                          decoration: InputDecoration(
                                              labelText: 'Preço'),
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          focusNode: _priceFocusNode,
                                          onFieldSubmitted: (_) =>
                                              FocusScope.of(context)
                                                  .nextFocus(),
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
                                              description:
                                                  _editedProd.description,
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
                                              activeColor: Theme.of(context)
                                                  .primaryColorDark,
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
                                              activeColor: Theme.of(context)
                                                  .primaryColorDark,
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
                                          padding: const EdgeInsets.only(
                                              right: 30.0),
                                          child: TextFormField(
                                            initialValue: _editedProd.telNumber
                                                .toString(),
                                            decoration: InputDecoration(
                                                labelText: 'Número WhatsApp',
                                                helperText:
                                                    'Formato: 77991114567'),
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType: TextInputType.phone,
                                            onFieldSubmitted: (_) =>
                                                FocusScope.of(context)
                                                    .nextFocus(),
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Por favor preencha o campo";
                                              }
                                              if (int.tryParse(value) == null) {
                                                return 'Coloque um valor valido';
                                              }
                                              if (int.parse(value) <=
                                                  10000000000) {
                                                return 'Valor precisa incluir o DDD';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _editedProd.telNumber =
                                                  int.parse(value);
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
                                          iconEnabledColor:
                                              Theme.of(context).primaryColor,
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
                                  TextFormField(
                                    initialValue: _editedProd.description,
                                    decoration:
                                        InputDecoration(labelText: 'Descrição'),
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
                          Step(
                            title: const Text('Fotos'),
                            isActive: _currentStep >= 1,
                            state: StepState.editing,
                            content: Form(
                              key: _formKeys[1],
                              child: Column(
                                children: <Widget>[
                                  CheckboxListTile(
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
                                  CheckboxListTile(
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      ImageCapture(),
                                      ImageCapture(),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      ImageCapture(),
                                      ImageCapture(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
