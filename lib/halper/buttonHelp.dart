import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import 'createmMaterialColor.dart';

// class buttonWidget extends StatelessWidget {
//   final String text ;
//   final VoidCallback onClicked;
//   final double long;
//
//   const buttonWidget({
//
//     Key? key, required this.text, required this.onClicked, required this.long
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final  createMaterialColor = CreateMaterialColor();
//     Color smart =createMaterialColor.createMaterialColor(Color(0xff57cc2e));
//
//
//     return Padding(
//       padding: const EdgeInsets.only(right: 21.0,left: 21),
//       child: CustomContainer(long: long, smart: smart, onTap: null, buttonText: 'S’INSCRIRE',),
//     );
//
//   }
// }

class CustomContainer extends StatelessWidget {

  const CustomContainer({
    Key? key,
    required this.long,
    required this.smart, required this.buttonText, required this.onTap, required this.fontColor ,
  }) : super(key: key);

  final double long;
  final Color smart;
  final Color fontColor;
  final String buttonText;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,

      width: long,
      child: Padding(
        padding: const EdgeInsets.only(right: 21,left: 21),
        child: ElevatedButton(

            onPressed: onTap
            , child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(buttonText,style: TextStyle(color: fontColor ,fontSize: 15),)]),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( smart),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(0xff57CC2E),width: 1)

                    )
                )
            )

        ),
      ),

    );
  }
}
class AccRef extends StatelessWidget {

  const AccRef({
    Key? key,
    required this.smart, required this.buttonText, required this.onTap, required this.fontColor ,
  }) : super(key: key);

  final Color smart;
  final Color fontColor;
  final String buttonText;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,

      width: 156,
      child: Padding(
        padding: const EdgeInsets.only(right: 21,left: 21),
        child: ElevatedButton(

            onPressed: onTap
            , child: Text(buttonText,style: TextStyle(color: fontColor ,fontSize: 15),),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( smart),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                        //side: BorderSide(color: Color(0xff57CC2E),width: 1)

                    )
                )
            )

        ),
      ),

    );
  }
}
class CustomAdd extends StatelessWidget {

  const CustomAdd({
    Key? key,
    required this.smart, required this.buttonText, required this.onTap, required this.fontColor, required this.smart2, required this.path ,
  }) : super(key: key);

  final Color smart;
  final Color smart2;
  final Color fontColor;
  final String buttonText;
  final String path;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 134,
      width: 140,
      child: ElevatedButton(


          onPressed: onTap
          , child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Container(
              child: SvgPicture.asset(path),
            ),
            SizedBox(height: 11,),

            Text(buttonText,style: TextStyle(color:  fontColor,fontSize: 12),)] ),
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Color(0xff57CC2E); //<-- SEE HERE
                  return null; // Defer to the widget's default.
                },
              ),

              backgroundColor: MaterialStateProperty.all( smart),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                      //side: BorderSide(color: smart2,width: 1)

                  )
              )
          )

      ),

    );
  }
}
class CustomContainerArg extends StatelessWidget {
  const CustomContainerArg({
    Key? key,
    required this.long,
    required this.smart, required this.buttonText, required this.onTap, required this.path, required this.fontColor, required this.baground,
  }) : super(key: key);

  final double long;
  final Color smart;
  final Color baground;
  final Color fontColor;
  final String buttonText;
  final String path;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
    return                 SizedBox(

      height: 46,
      width: long,
      child: Padding(
        padding: const EdgeInsets.only(left: 21,right: 21),
        child: ElevatedButton(

            onPressed:onTap, child: Row(
            children:[
              SizedBox(width: 50,),
              Container(
                child:    SvgPicture.asset(path),
              ),
              SizedBox(width: 10,),

              Text(buttonText,style: TextStyle(color:  fontColor,fontSize: 13),)] ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(baground),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(0xff57cc2e),width: 1)
                    )
                )
            )

        ),
      ),

    );
  }
}


class customField extends StatelessWidget {
  const customField({
    Key? key,
    required this.hint, required this.label, required this.controller,  required this.type,required this.long,
  }) : super(key: key);

  final String hint;
  final String label;
  final TextEditingController controller;
  final TextInputType type;
  final double long;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      width: long,

      child: Padding(
        padding: const EdgeInsets.only(right: 21,left: 21),
        child: TextFormField(
          //onSaved: (String? value) => setState(() => this.valeur = valeur!),
          controller: controller,
          cursorColor: Color(0xff9A9FB7),
          decoration: InputDecoration(
            hintText: hint,
            labelText: label,
            labelStyle: TextStyle(fontSize: 14,color: Color(0xff9A9FB7)),
            hintStyle: TextStyle(fontSize: 14,color: Color(0xff9A9FB7)),
            enabledBorder:  OutlineInputBorder(
              borderSide: BorderSide(color :Color(0xffDBE2E4)),
            ),
            focusedBorder:  OutlineInputBorder(
              borderSide: BorderSide(color :Color(0xffDBE2E4)),
            ),

          ),
          keyboardType: type,
          textInputAction: TextInputAction.next,
          validator:(String? value){
            if(value!.isEmpty || value.length < 4 ){
              return 'Enter at least 4 characters';
            }else{
              return null;
            }

          },


        ),
      ),
    );
  }
}


class customInk extends StatelessWidget {
  const customInk({
    Key? key, required this.smart, required this.onTap, required this.nameIcon,
  }) : super(key: key);

  final Color smart;
  final String nameIcon;

  final VoidCallback onTap;



  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.black,
        shape: CircleBorder(),
      ),
      child:
      IconButton(
        iconSize: 40,

        icon:  ImageIcon(
          AssetImage(nameIcon),
          // color: Colors.black,
          //  color: Color(0xFF7B61F9),
          color: smart ,
        ),
        // color: Colors.white,
        onPressed:onTap,

      ),
    );
  }
}
class StreamBuilderInvi extends StatelessWidget {
   StreamBuilderInvi({
    Key? key, this.emailAdd, this.uidAdd, this.cercleUidAA, this.userNameAdd, this.myName, this.myUid1, this.cercleName, this.CercleOwnerId,
  }) : super(key: key);


  final String? emailAdd;
  final String? uidAdd;
  final String? cercleUidAA;
  final String? userNameAdd;
  final String? myName;
  late  String? myUid1;
  final String? cercleName;
  final String? CercleOwnerId;




  @override
  Widget build(BuildContext context) {
    _getMyUid();
    DatabaseReference refer = FirebaseDatabase(
        databaseURL: 'https://smartowl-2f856-default-rtdb.europe-west1.firebasedatabase.app/')
    ////uuuuuuuuuuuuuuuuuuuuuuuuuuuuu
        .ref("users/${myUid1}");
    DatabaseReference ref = FirebaseDatabase(databaseURL:'https://smartowl-2f856-default-rtdb.europe-west1.firebasedatabase.app/').ref();

    return StreamBuilder(
        stream: refer.onValue,
        builder: (context, AsyncSnapshot snap) {
          if (snap.hasData &&
              !snap.hasError &&
              snap.data.snapshot.value != null) {
            Map data = snap.data.snapshot.value;

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
                            SizedBox(height:44 ,),

                            Container(
                                width: 95.0,
                                height: 95.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                            "https://i.imgur.com/BoN9kdC.png")))),
                            SizedBox(height:10 ,),
                            Text(data['userName'],style: TextStyle(fontSize: 15),),
                            Text("Av.14 Janvier, Sfax el jadida, 3000",style: TextStyle(fontSize: 13,color: Color(0xffA8B0BE)),),
                            SizedBox(height:38 ,),
                            Padding(
                              padding: const EdgeInsets.only(right: 46.0,left: 46),
                              child: Text("Quelqu’un veut rejoindre ",style: TextStyle(fontSize: 22),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 46.0,left: 46),
                              child: Text("votre cercle",style: TextStyle(fontSize: 22),),
                            ),
                            SizedBox(height:10 ,),
                            Text("Vérifier l’identité de cette personne",style: TextStyle(fontSize: 16,color: Color(0xff58687F)),),
                            SizedBox(height:53 ,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AccRef(smart: Color(0xFFF00014).withOpacity(0.1), fontColor: Color(0xFFF00014), onTap: () {
                                  ref.remove();

                                }, buttonText: 'REFUSER',),
                                AccRef(smart: Color(0xFF57CC2E), fontColor: Colors.white, onTap: () {

                                  postDetailsToFirestore1(context,data['email'],data['uid'],data['userName'],data['cercleUid']);
                                  ref.remove();

                                }, buttonText: 'ACCEPTER',)
                              ],
                            )



                          ]
                      ),
                    ],
                  ),
                ),
              ),

              offset: Offset(0, 200),
            );
          }else {
            return Container();
          }

        });
  }

  void postDetailsToFirestore1(data0,data, data2, data3, data4) async {
    final prefs = await SharedPreferences.getInstance();

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    //User? user = _auth.currentUser;
    // postDetailsToFirestore1(data['email'],data['uid'],data['userName'],data['cercleUid']);
    final String? myName = prefs.getString('myName');
    final String? myUid = prefs.getString('myUid');

    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = data;
    userModel.uid = data2;
    userModel.userName = data3;

    // writing all the values
    await firebaseFirestore
        .collection("users")
        .doc(myUid)
        .collection("cercle")
        .doc(data4)
        .collection("usersCercle")
    //.doc("message1");

    // .doc(user.uid)
        .add(userModel.toMap());
    const snackBar = SnackBar(
      content: Text(
        "Place created successfully ) ",
        style: TextStyle(fontSize: 20),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(data0).showSnackBar(snackBar);
  }
  _getMyUid() async {
    final prefs = await SharedPreferences.getInstance();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) async {
      //FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      if (user != null) {
        await prefs.setString('myUid', "${user.uid}");
        await prefs.setString('myEmail', "${user.email}");
      }
    });
     myUid1 = prefs.getString('myUid');


  }

}


