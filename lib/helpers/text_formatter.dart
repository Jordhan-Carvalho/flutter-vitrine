import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyPtBrInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);
    final formatter = new NumberFormat("#,##0.00", "pt_BR");
    String newText = "R\$ " + formatter.format(value / 100);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }

  static String valueToIntString(String value) {
    return value.replaceRange(0, 3, "").replaceAll(".", "").replaceAll(",", "");
  }
}

// how to use
// Widget _fieldValues() {
//     return Padding(
//       padding: EdgeInsets.only(top: 10, bottom: 60),
//       child:  TextFormField(
//               decoration: InputDecoration(
//                 icon: Icon(Icons.monetization_on),
//                 labelText: 'Valor *',
//               ),
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 WhitelistingTextInputFormatter.digitsOnly,
//                 CurrencyPtBrInputFormatter()
//               ]
//        );
//  }
