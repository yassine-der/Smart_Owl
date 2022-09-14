import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_owl/authentification/loginPage.dart';

import '../halper/createmMaterialColor.dart';
import '../halper/buttonHelp.dart';
import '../mapScreen/realTimeMap.dart';
import 'inscription_par_mail.dart';


class seConnecter extends StatefulWidget {
  const seConnecter({Key? key}) : super(key: key);

  @override
  _seConnecterState createState() => _seConnecterState();
}

class _seConnecterState extends State<seConnecter> {
  bool isPasswordVisibleIn = false;

  //key Form



  @override
  Widget build(BuildContext context) {

    final  createMaterialColor = CreateMaterialColor();
    Color smart =createMaterialColor.createMaterialColor(Color(0xff57cc2e));

    final size = MediaQuery.of(context).size;



    return Scaffold(
            backgroundColor: Colors.white,

            body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {

                if(snapshot.hasData){
                  return realTime();
                }
                else {
                  return loginPage();
                }

              }
            ),
    );
  }
}
