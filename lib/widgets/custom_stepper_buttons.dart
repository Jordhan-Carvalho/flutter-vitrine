import 'package:flutter/material.dart';

import './theme_button.dart';

class CustomStepperButtom extends StatelessWidget {
  final Function onStepContinue;
  final BuildContext context;
  final Function onStepCancel;
  final currentStep;
  final Function saveForm;

  const CustomStepperButtom(
    this.context, {
    this.onStepContinue,
    this.onStepCancel,
    this.saveForm,
    this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          currentStep == 1 // this is the last step
              ? ThemeButton(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Icon(
                        Icons.save,
                        size: 20,
                      ),
                      const Text('Salvar'),
                    ],
                  ),
                  handlePress: saveForm,
                )
              : ThemeButton(
                  content: const Text('Continuar'),
                  handlePress: onStepContinue,
                ),
          FlatButton.icon(
            icon: const Icon(Icons.delete_forever),
            label: const Text('Cancelar'),
            onPressed: onStepCancel,
          )
        ],
      ),
    );
  }
}
