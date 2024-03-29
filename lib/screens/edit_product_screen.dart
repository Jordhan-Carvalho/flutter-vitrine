import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

// import '../providers/product.dart';
import '../widgets/custom_stepper_buttons.dart';
import '../providers/products.dart';
import '../models/product.dart';
import '../widgets/image_capture.dart';
import '../providers/auth.dart';
import '../helpers/text_formatter.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = '/test';
  @override
  _EditProductScreenState createState() => new _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://vitrine-3da15.appspot.com');
  StorageUploadTask _uploadTask;

  var _editedProd = Product(
    id: null,
    title: '',
    price: 0,
    telNumber: 77,
    description: '',
    condition: Condition.Usado,
    imageUrl: [],
    category: null,
    subcategory: null,
    delivery: false,
    tradable: false,
  );

  List<File> _filesArray = [];
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final prodId = ModalRoute.of(context).settings.arguments as String;
      if (prodId != null) {
        _editedProd = Provider.of<Products>(context, listen: false)
            .findUserProdById(prodId);
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
      Scaffold.of(ctx)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Selecione uma categoria !'),
          duration: Duration(milliseconds: 2000),
        ));
      return false;
    } else if (_editedProd.subcategory == null) {
      Scaffold.of(ctx)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Selecione uma subcategoria !'),
          duration: Duration(milliseconds: 2000),
        ));
      return false;
    } else if (_filesArray.isEmpty &&
        _currentStep == 1 &&
        _editedProd.imageUrl.isEmpty) {
      Scaffold.of(ctx)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Adicione ao menos uma foto !'),
          duration: Duration(milliseconds: 2000),
        ));
      return false;
    } else {
      return true;
    }
  }

  int _addFileToArray({File file, int fileIndex}) {
    if (fileIndex == null) {
      _filesArray.add(file);
      return _filesArray.indexOf(file);
    }
    _filesArray[fileIndex] = file;
    return -1;
  }

  Future<void> _startUpload({String imageName, File file}) async {
    setState(() {
      _uploadTask = _storage.ref().child(imageName).putFile(file);
    });
    var downurl = await (await _uploadTask.onComplete).ref.getDownloadURL();

    _editedProd.imageUrl.add(downurl.toString());
  }

  void _saveForm([BuildContext ctx]) async {
    if (!_validateInputs(ctx)) {
      _validateInputs(ctx);
      return;
    }
    if (!await _showConfirmation()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    if (_editedProd.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProd.id, _editedProd);
    } else {
      try {
        // Loop thru an array of files and for each upload the file and add the url on _editProd
        final String _userId = Provider.of<Auth>(context, listen: false).userId;
        final _timeCreated = DateTime.now();
        for (var i = 0; i < _filesArray.length; i++) {
          String imgNamePath = 'images/$_userId/${_timeCreated.toString()}&$i';
          await _startUpload(
              imageName: imgNamePath.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
              file: _filesArray[i]);
        }
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProd, _timeCreated);
      } catch (e) {
        print(e);
        // TODO delete photos in case of success
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Um erro ocorreu!'),
            content: Text('Algo deu errado'),
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

  Future<bool> _showConfirmation() {
    // returns a promisse(Future) with tru or false after the button is pressed
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Finalizar produto?'),
              content:
                  Text('Após finalizado, as fotos não poderão ser editadas'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Sim'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                FlatButton(
                  child: Text('Não'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ));
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
      _validateInputs(ctx);
    }
  }

  void _cancel() {
    if (_currentStep > 0) {
      _goTo(_currentStep - 1);
      return;
    }
    if (_currentStep == 0) {
      Navigator.of(context).pop();
    }
  }

  void _goTo(int step) {
    setState(() => _currentStep = step);
  }
  //STEPPER

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Produto'),
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
                        onStepTapped: (step) {
                          if (_currentStep == 1) {
                            _formKeys[_currentStep].currentState.save();
                            _currentStep = step;
                            _goTo(step);
                            return;
                          }
                          if (_formKeys[_currentStep].currentState.validate() &&
                              _validateInputs(context)) {
                            _formKeys[_currentStep].currentState.save();
                            _currentStep = step;
                            // _currentStep + 1 != steps.length
                            _goTo(step);
                          } else {
                            _validateInputs(context);
                            return;
                          }
                        },
                        controlsBuilder: (BuildContext context,
                                {VoidCallback onStepContinue,
                                VoidCallback onStepCancel}) =>
                            CustomStepperButtom(
                          context,
                          onStepContinue: () => _next(context),
                          onStepCancel: _cancel,
                          currentStep: _currentStep,
                          saveForm: () => _saveForm(context),
                        ),
                        steps: [
                          Step(
                            title: const Text('Informações gerais'),
                            isActive: _currentStep >= 0,
                            state: StepState.complete,
                            content: Form(
                              key: _formKeys[0],
                              autovalidate: true,
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    initialValue: _editedProd.title,
                                    maxLength: 28,
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
                                      if (value.length >= 29) {
                                        return "Diminuir titulo";
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
                                          initialValue: _editedProd.price == 0
                                              ? 'R\$ ${NumberFormat("#,##0.00", "pt_BR").format(0 / 100).toString()}'
                                              : 'R\$ ${NumberFormat("#,##0.00", "pt_BR").format(_editedProd.price / 100).toString()}',
                                          inputFormatters: [
                                            WhitelistingTextInputFormatter
                                                .digitsOnly,
                                            CurrencyPtBrInputFormatter()
                                          ],
                                          decoration: InputDecoration(
                                            labelText: 'Preço',
                                          ),
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.number,
                                          focusNode: _priceFocusNode,
                                          maxLength: 13,
                                          onFieldSubmitted: (_) =>
                                              FocusScope.of(context)
                                                  .nextFocus(),
                                          validator: (value) {
                                            final newVal =
                                                CurrencyPtBrInputFormatter
                                                    .valueToIntString(value);
                                            if (newVal.isEmpty) {
                                              return "Por favor preencha o campo";
                                            }
                                            if (int.tryParse(newVal) == null) {
                                              return 'Fornecer valor valido';
                                            }
                                            if (int.parse(newVal) <= 0) {
                                              return 'Valor precisa ser maior que 0';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _editedProd = Product(
                                              tradable: _editedProd.tradable,
                                              telNumber: _editedProd.telNumber,
                                              category: _editedProd.category,
                                              subcategory:
                                                  _editedProd.subcategory,
                                              delivery: _editedProd.delivery,
                                              condition: _editedProd.condition,
                                              id: _editedProd.id,
                                              title: _editedProd.title,
                                              price: int.parse(
                                                  CurrencyPtBrInputFormatter
                                                      .valueToIntString(value)),
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
                                            maxLength: 11,
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
                                              if (int.tryParse(value) == null ||
                                                  int.parse(value) >
                                                      99900000000) {
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
                                              _editedProd.subcategory = null;
                                            });
                                          },
                                          items: Product.loadCategories.keys
                                              .toList()
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
                                  if (_editedProd.category != null &&
                                      _editedProd.category != '')
                                    DropdownButton<String>(
                                      value: _editedProd.subcategory,
                                      icon: Icon(Icons.arrow_downward),
                                      iconSize: 20,
                                      elevation: 16,
                                      hint: Text('Subcategorias'),
                                      iconEnabledColor:
                                          Theme.of(context).primaryColor,
                                      isExpanded: true,
                                      // isDense: true,
                                      onChanged: (String newValue) {
                                        setState(() {
                                          _editedProd.subcategory = newValue;
                                        });
                                      },
                                      items: Product
                                          .loadCategories[_editedProd.category]
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
                                      if (value.length < 16) {
                                        return 'Por favor aumente a sua descrição.';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _editedProd = Product(
                                        tradable: _editedProd.tradable,
                                        telNumber: _editedProd.telNumber,
                                        category: _editedProd.category,
                                        subcategory: _editedProd.subcategory,
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
                                    secondary: Icon(
                                      Icons.autorenew,
                                      color: Theme.of(context).primaryColor,
                                    ),
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
                                    secondary: Icon(
                                      Icons.local_shipping,
                                      color: Theme.of(context).primaryColor,
                                    ),
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
                                  if (_editedProd.imageUrl.isEmpty)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        ImageCapture(
                                          addFile: _addFileToArray,
                                          existingImage: _filesArray.length >= 1
                                              ? _filesArray[0]
                                              : null,
                                          existingIndex: _filesArray.length >= 1
                                              ? 0
                                              : null,
                                        ),
                                        ImageCapture(
                                          addFile: _addFileToArray,
                                          existingImage: _filesArray.length >= 2
                                              ? _filesArray[1]
                                              : null,
                                          existingIndex: _filesArray.length >= 2
                                              ? 1
                                              : null,
                                        ),
                                      ],
                                    ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (_editedProd.imageUrl.isEmpty)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        ImageCapture(
                                          addFile: _addFileToArray,
                                          existingImage: _filesArray.length >= 3
                                              ? _filesArray[2]
                                              : null,
                                          existingIndex: _filesArray.length >= 3
                                              ? 2
                                              : null,
                                        ),
                                        ImageCapture(
                                          addFile: _addFileToArray,
                                          existingImage: _filesArray.length >= 4
                                              ? _filesArray[3]
                                              : null,
                                          existingIndex: _filesArray.length >= 4
                                              ? 3
                                              : null,
                                        ),
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
