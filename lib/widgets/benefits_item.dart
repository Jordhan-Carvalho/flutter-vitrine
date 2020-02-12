import 'dart:math';

import 'package:flutter/material.dart';

class BenefitsItem extends StatefulWidget {
  final List<String> benefits;

  BenefitsItem(this.benefits);

  @override
  _BenefitsItemState createState() => _BenefitsItemState();
}

class _BenefitsItemState extends State<BenefitsItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Benefícios'),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          // if (_expanded)
          AnimatedContainer(
            duration: Duration(
              milliseconds: 200,
            ),
            curve: Curves.linear,
            height:
                _expanded ? min(widget.benefits.length * 20.0 + 10, 100) : 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
            child: ListView(
              children: <Widget>[
                ...widget.benefits.map(
                  (benefit) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      '• $benefit',
                      style: TextStyle(
                          // fontSize: 18,
                          // color: Colors.grey,
                          ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
