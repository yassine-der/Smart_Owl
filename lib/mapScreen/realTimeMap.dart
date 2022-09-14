import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_owl/mapScreen/activite.dart';
import 'package:smart_owl/mapScreen/partageCodeScreen.dart';

import '../halper/buttonHelp.dart';
import '../main.dart';
import '../model/user_model.dart';
import 'add_place.dart';
import 'listPersone.dart';



class realTime extends StatefulWidget {
  const realTime({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<realTime> {


  String? myUid;
  String? cercleName;
  String? CercleOwnerId;
  String? emailAdd;
  String? uidAdd;
  String? cercleUidAA;
  String? userNameAdd;
  String? code;
  String? CercleUid;


  int _currentIndex = 0;
  ThemeStyle _currentStyle = ThemeStyle.NotificationBadge;
  List<int> _badgeCounts = List<int>.generate(5, (index) => index);
  List<bool> _badgeShows = List<bool>.generate(5, (index) => true);

  @override
  initState()  {
    super.initState();
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    _getMyUid();
    _getMyCercleName();
  }


  @override
  Widget build(BuildContext context) {
    print(CercleOwnerId);
    print(cercleName);
    print(emailAdd);
    print(cercleUidAA);
    print(userNameAdd);
    print(code);
    print(uidAdd);
    String? myUid;

    _getMyUid();
    _getMyCercleName();
        return Scaffold(

          extendBody: true,

          body:  Stack(children:[screens[_currentIndex],
    ]),

            bottomNavigationBar: _buildFloatingBar(),
        );
  }
  Widget _buildFloatingBar() {
    return CustomNavigationBar(
      iconSize: 43.0,
      selectedColor: Color(0xff57CC2E),
      strokeColor: Color(0xff57CC2E),
      unSelectedColor: Color(0xff4C616B),
      backgroundColor: Colors.white,

      borderRadius: Radius.circular(20.0),

      items: [
        CustomNavigationBarItem(

        icon: Icon(Icons.location_on_outlined ),
          title: Text("Home", style: TextStyle(color: Color(0xff57CC2E),fontSize: 10),),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.group_outlined ),
          title: Text("Home", style: TextStyle(color: Color(0xff57CC2E),fontSize: 10),),
          badgeCount: _badgeCounts[1],
          showBadge: _badgeShows[1],
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.add_box_rounded ,color:Color(0xff57CC2E),),
          // title: Text("Home", style: TextStyle(color: Color(0xff57CC2E)),),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          title: Text("Home", style: TextStyle(color: Color(0xff57CC2E),fontSize: 10),),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.reorder_sharp),
          title: Text("MENU", style: TextStyle(color: Color(0xff57CC2E),fontSize: 10),),),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
          _badgeShows[index] = false;
          if(_currentIndex == 1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  UserList(myUid: myUid!, CercleUid: CercleUid!,)),
              // MaterialPageRoute(builder: (context) =>  listLieu(CercleUid:CercleUid!)),
            );

          }
          if(_currentIndex == 2 ) {
            _openCustomDialog(context,);
          }
          // }else{
          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Choisir une Cercle")));
          //
          // }
        });
      },
      isFloating: true,
      opacity: 0.8,


    );
  }

  final screens = [
    activite(),
    activite(),
    activite(),
    Center(child: Text("Chat",style: TextStyle(fontSize: 60,fontWeight: FontWeight.bold),),),
  ];

  void _openCustomDialog(BuildContext context) async{
    _getMyCercleName();

    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.61),
        transitionBuilder: (context,  animation1, animation2, widget) {
          return Transform.translate(
            child:   Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),

              color: Colors.white,

              child: Form(
                // key: _formKeyCercle,

                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          SizedBox(height:36 ,),

                          Text("Ajouter un nouveau membre",style: TextStyle(fontSize: 16),),
                          SizedBox(height:22 ,),

                          Padding(
                            padding: const EdgeInsets.only(right: 21,left: 21),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,

                              children: [
                                CustomAdd(fontColor: const Color(0xFF061C33), smart:  Color(0xffF1F2F5), onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (_) => PartageCode(userUid: myUid!,  code: code!, CercleOwnerId: CercleOwnerId!,)),);}, smart2:  Color(0xffF1F2F5), buttonText: 'Ajouter un parent', path: 'assets/images/parents.svg',),
                                SizedBox(width:10 ,),
                                CustomAdd(fontColor: const Color(0xFF061C33), smart:  Color(0xffF1F2F5), onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (_) => PartageCode(userUid: myUid!,  code: code!, CercleOwnerId: CercleOwnerId!,)),);  }, smart2:  Color(0xffF1F2F5), buttonText: 'Ajouter un parent', path: 'assets/images/enfant.svg',),

                              ],
                            ),
                          ),
                        ]
                    ),
                  ],
                ),
              ),
            ),
            offset: Offset(0, 500),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }
  _getMyUid() async {
    final prefs = await SharedPreferences.getInstance();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) async {
      if (user != null) {
        await prefs.setString('myUid', "${user.uid}");
      }
    });
    myUid = prefs.getString('myUid');
  }

  _getMyCercleName() async {
    final prefs = await SharedPreferences.getInstance();

    cercleName = prefs.getString('CercleName');
    code = prefs.getString('code');
    CercleUid = prefs.getString('CercleUid');
    CercleOwnerId = prefs.getString('CercleOwnerId');

    if (cercleName != null || CercleOwnerId != null|| code != null) {
      cercleName = prefs.getString('CercleName');
      CercleOwnerId = prefs.getString('CercleOwnerId');
      code = prefs.getString('code');
      CercleUid = prefs.getString('CercleUid');

    } else {
      cercleName = "None";
      CercleOwnerId = "None";
      code = "None";
      CercleUid = "None";

    }
  }
  void pop(){
    Navigator.of(context).pop();
  }

}

