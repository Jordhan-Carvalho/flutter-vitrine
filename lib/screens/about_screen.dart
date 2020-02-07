import 'package:flutter/material.dart';

import '../widgets/comming_soon.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key key}) : super(key: key);

  static const routeName = "/about";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
      ),
      body: ComingSoon(),
    );
  }
}
