import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frooyd/COMMON/app_bars/custom_bar.dart';
import 'PskologKayıtForm.dart';

class PsikologKayit extends StatefulWidget {
  @override
  _PsikologKayitState createState() => _PsikologKayitState();
}

class _PsikologKayitState extends State<PsikologKayit> {

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar.withBackButton(width, context),
      body:PsikologKayitForm(),

    );
  }
}
