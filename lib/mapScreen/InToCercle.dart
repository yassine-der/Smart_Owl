import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authentification/encrypt.dart';
import '../halper/buttonHelp.dart';
import 'package:encrypt/encrypt.dart' as encrypt;


class InToCercle extends StatefulWidget {
  const InToCercle({Key? key}) : super(key: key);

  @override
  _InToCercleState createState() => _InToCercleState();
}

class _InToCercleState extends State<InToCercle> {

  final InTocercleController = TextEditingController();
  String? encryps;
  String? numb;
  String? myUid;
  encrypt.Encrypted? encryptt;
  final GlobalKey<FormState> _formKeyInToCercle= GlobalKey<FormState>();
  void dispose() {
    // TODO: implement dispose
    InTocercleController.dispose();
    super.dispose();
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMyUid();
  }
  @override
  Widget build(BuildContext context) {
    _getMyUid();
    final size = MediaQuery
        .of(context)
        .size;

    // print(encryps);
    DatabaseReference refi = FirebaseDatabase(databaseURL:'https://smartowl-2f856-default-rtdb.europe-west1.firebasedatabase.app/').ref("usersPositios/");

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,elevation: 3,),

      body: Stack(
        children: [
          StreamBuilder(
            stream: refi.onValue,
            builder: (context, AsyncSnapshot snap) {
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data.snapshot.value != null) {
                Map data = snap.data.snapshot.value;
                List item = [];

                print(item);

                data.forEach(
                        (index, data) =>
                        item.add({"key": index, ...data}));
                  numb = "${item.length}";
                //   print("tatatatatatatatatatatatatatataatatatatatatatatatatatatatatatatattatatatatatatatatatatatata");
                // print(data);
                // print(numb);


                // }
                return  Container();
              } else {
                numb= "0";
                return Container();
              }
            },
          ),

          Form(

          key: _formKeyInToCercle,

          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    SizedBox(height:36 ,),

                    Text("Participer à  un cercle",style: const TextStyle(fontSize: 22),),
                    SizedBox(height:13 ,),
                    const Padding(
                      padding: EdgeInsets.only(left: 20,right: 20),
                      child: Text("Saisissez le code qui correspond ",style: TextStyle(fontSize: 16,color: Color(0xFF58687F)),),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20,right: 20),
                      child: Text("à la cercle.",style: TextStyle(fontSize: 16,color: Color(0xFF58687F)),),
                    ),
                    const SizedBox(height:13 ,),
                    customField(label: 'Code', type: TextInputType.text, hint: 'Saisissez un code ', long: size.width, controller: InTocercleController,),
                    const SizedBox(height:38 ,),
                    // buttonWidgetUp("CRÉER UN LIEU",
                    //   width,),
                    CustomContainer(long: size.width, onTap: () {
                      final isvalidateUp = _formKeyInToCercle.currentState!.validate();
                      if(isvalidateUp  && InTocercleController.text.substring(9, ) != myUid){
                        _formKeyInToCercle.currentState?.save();
                        postDetailsToFirestore();
                      }
                      FocusScope.of(context).unfocus();

                    }, buttonText: 'ENREGISTRER', smart: Color(0xff57cc2e), fontColor: Colors.white,)
                  ]
              ),
            ],
          ),
        ),]
      ),
    );
  }
  _getMyUid() async {
    final prefs = await SharedPreferences.getInstance();
    myUid = prefs.getString('myUid');

  }


  postDetailsToFirestore( ) async {
    final prefs = await SharedPreferences.getInstance();

    if(_formKeyInToCercle.currentState!.validate()){
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      //User? user = _auth.currentUser;
      final String? myName =prefs.getString('myName');
      final String? myUid = prefs.getString('myUid');
      final String? myEmail = prefs.getString('myEmail');
      final String? myfileName = prefs.getString('myImagePath');
      final String? _currentAddress = prefs.getString('_currentAddress');
      encryps = InTocercleController.text;
      // writing all the values
      //
      // // print(InTocercleController.text.substring(9, ));

      DatabaseReference dbRef = FirebaseDatabase(databaseURL: 'https://smartowl-2f856-default-rtdb.europe-west1.firebasedatabase.app/').ref("usersPositios/${encryps!.substring(9, )}");
      await dbRef.child("${numb}aa").set({
        'uid': "${myUid}",
        'email': "${myEmail}",
        'fileName': "${myfileName}",
        'userName': "${myName}",
        'cercleUid': "${encryps!.substring(0,8)}",
        '_currentAddress': "${_currentAddress}"
      });

      const snackBar = SnackBar(
        content: Text(
          "Cercle created successfully ) ",
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      InTocercleController.clear();
    }
  }

}
