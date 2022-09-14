import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart' as slideDialog;
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../halper/buttonHelp.dart';
import '../model/cercle_model.dart';
import 'add_place.dart';



class code extends StatefulWidget {
  const code({Key? key}) : super(key: key);

  @override
  _codeState createState() => _codeState();
}

class _codeState extends State<code> {
  late Future<String> _value;

  String? myName;
  String? myUid;
  String? cercleName;



  @override
  initState()  {

    super.initState();
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    _value = getMyCercleName()!;

    _getMyUid()!;
    // _getMyCercleName()!;
    // Stream<QuerySnapshot>? _usersStream = FirebaseFirestore.instance.collection('users').doc(myUid).collection("cercle").snapshots();

  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   _getUserLocation();
  //
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    FutureBuilder<String>(
      future: _value, // async work
      builder: (BuildContext context,
          AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              print(snapshot.data);

            myName = snapshot.data;
            print(myName);
            return Center(child: CircularProgressIndicator());
        }
      },
    );

    return Center(child: Text("rrrrr"),);
  }
  void getMyUserName(double lat,double long){

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) async {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      if (user != null) {

        await firebaseFirestore
            .collection("users")
            .doc(user.uid).get().then(
              (DocumentSnapshot doc) {
            final data = doc.data() as Map<String, dynamic>;
            //readData(data['userName']);
          },
          onError: (e) => print("Error getting document: $e"),
        );

      }
    });
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  _getMyUid() async {
    final prefs = await SharedPreferences.getInstance();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) async {
      //FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      if (user != null) {
        await prefs.setString('myUid', "${user.uid}");
      }
    });
    myUid = prefs.getString('myUid');
  }
  Future<String>? getMyCercleName() async {
    final prefs = await SharedPreferences.getInstance();

    cercleName = prefs.getString('CercleName');
    if(cercleName != null){
      cercleName = prefs.getString('CercleName');
      final String? myNamee = cercleName!;
      return myNamee!;
    }else{
      final String? myNamee = "None";
      return myNamee!;
    }
  }
  // Future<String>? _getMyName() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   FirebaseAuth.instance
  //       .authStateChanges()
  //       .listen((User? user) async {
  //     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //     if (user != null) {
  //       await prefs.setString('myUid', "${user.uid}");
  //
  //       await firebaseFirestore
  //           .collection("users")
  //           .doc(user.uid).get().then(
  //             (DocumentSnapshot doc) async {
  //           final data = doc.data() as Map<String, dynamic>;
  //           //String   name =  data['userName'];
  //           await prefs.setString('myName', "${data['userName']}");
  //
  //         },
  //         onError: (e) => print("Error getting document: $e"),
  //       );
  //     }
  //   });
  //   final String? myName = prefs.getString('myName');
  //   final String? myUid = prefs.getString('myUid');
  //
  //   return myName!;
  // }

}

