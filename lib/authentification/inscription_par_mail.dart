import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart'as Im hide Color;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_owl/authentification/seConnecter.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../halper/createmMaterialColor.dart';
import '../halper/buttonHelp.dart';
import '../mapScreen/realTimeMap.dart';
import '../model/cercle_model.dart';
import '../model/user_model.dart';
import 'loginPage.dart';

class inscription extends StatefulWidget {
  const inscription({Key? key}) : super(key: key);

  @override
  _inscriptionState createState() => _inscriptionState();
}

class _inscriptionState extends State<inscription> {

  final _auth = FirebaseAuth.instance;
  //Form_variable
  final userNameControllerUp = TextEditingController();
  final emailControllerUp = TextEditingController();
  final passwordControllerUp = TextEditingController();
  String? fileName;
  @override
  void dispose() {
    // TODO: implement dispose
    userNameControllerUp.dispose();
    emailControllerUp.dispose();
    passwordControllerUp.dispose();
    super.dispose();
  }
  //key Form
  final GlobalKey<FormState> _formKeyUp = GlobalKey<FormState>();

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 25);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        // uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }
  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera,imageQuality: 25);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        // uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }
  Future uploadFile() async {
    if (_photo == null) return;
     fileName = path.basename(_photo!.path);
    try {
      await firebase_storage.FirebaseStorage.instance
        .ref(fileName).putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }
  @override
  Widget build(BuildContext context) {
    final  createMaterialColor = CreateMaterialColor();
    Color smart =createMaterialColor.createMaterialColor(Color(0xff57cc2e));

    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(backgroundColor: Colors.white,
            elevation:0
        ),

        body: SafeArea(
          //child: Center(
            child: Align(
              alignment: Alignment.center,
              child: Form(
                key: _formKeyUp,
                child: ListView(
                  children: [
                    Align(
                      alignment: Alignment.center,
                        child: Text("Créez votre compte" ,style: TextStyle(fontSize: 22),)),
                    SizedBox(height: 26,),
                    Padding(
                      padding: const EdgeInsets.only(left: 28.0,right: 28),
                      child: Row(children: [Text("En m’inscrivant, j’adhère à la ",style: TextStyle(fontSize: 12,color:Color(0xff707070) ),),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'politique de confidentialité',
                                style: TextStyle(
                                    fontSize: 12,
                                  color: Color(0xff3979F8),
                                ),

                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                  }),
                          ]),
                        ),
                      ],),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 70.0,right: 60),
                      child: Row(children: [
                        Text("et aux ",style: TextStyle(fontSize: 12,color:Color(0xff707070) ),),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'conditions de service',
                                style: TextStyle(
                                    fontSize: 12,
                                  color: Color(0xff3979F8),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                  }),
                          ]),
                        ),
                        Text(" de Smart Owl",style: TextStyle(fontSize: 12,color:Color(0xff707070) ),),
                      ],),
                    ),
                    SizedBox(height:20 ,),

                    Align(
                      // alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xff57CC2E),
                          child: _photo != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.file(
                              _photo!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.fitHeight,
                            ),
                          )
                              : Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(50)),
                            width: 100,
                            height: 100,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                    ),
                SizedBox(height:20 ,),
                    customField(controller: userNameControllerUp, label: 'Nom', hint: 'Votre nom', long: size.width, type: TextInputType.text,),
                    SizedBox(height:15 ,),
                    customField(controller: emailControllerUp, label: 'Email', hint: 'Votre email', long: size.width, type: TextInputType.emailAddress,),
                    SizedBox(height:15 ,),
                    customField(controller: passwordControllerUp, label: 'Mot de passe', hint: 'Votre mot de passe', long: size.width, type: TextInputType.text,),
                    SizedBox(height:40 ,),
                    CustomContainer(long: size.width, smart: const Color(0xff57cc2e), onTap: onPressed2, buttonText: 'S’INSCRIRE',fontColor :Colors.white),
                    SizedBox(height:29 ,),
                    Padding(padding: const EdgeInsets.only(left: 70,right: 60),
                      child: Row(children: [Text("Vous avez déjà un compte ? ",style: TextStyle(fontSize: 12,color:Color(0xff707070) ),),
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: 'Se connecter',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff3979F8),
                                ),

                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => seConnecter()),
                                    );
                                  }),
                          ]),
                        ),
                      ],),
                    ),
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }
   void  onPressed2 (){
  final isvalidateUp = _formKeyUp.currentState!.validate();
  if(isvalidateUp){
  _formKeyUp.currentState?.save();

  signUp(emailControllerUp.text.trim(),passwordControllerUp.text.trim()); }

  }
  void signUp(String email,String password) async {
    uploadFile();
    if(_formKeyUp.currentState!.validate() && fileName!=null){
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e){
        const snackBar = SnackBar(
          content: Text(
            "Bien Yassine",
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      });
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values
    var url = Uri.parse('https://api.voucherjet.com/api/v1/p/generator');
    final msg = jsonEncode({"count": 1, "pattern": "D##-####", "characters" : "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890" });
    var response = await http.post(url, body: msg,    headers: <String, String>{
      "Content-Type": "application/json",},);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    Map<String, dynamic> temp = json.decode(response.body);

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();
    Room room = Room();
    room.myListUser = [];
    room.name ="Familly";
    room.code = temp['codes'][0];
    room.ownerUid = user?.uid;
    await firebaseFirestore
        .collection("cercle")
        // .add(room.toFirestore());
    .add({"myListUser":[
      {'email':user?.email,
        'uid':user?.uid,
        'fileName':fileName,
        'userName':userNameControllerUp.text,}
    ],"myLieuUser":[],"name":"Familly","code":temp['codes'][0],"ownerUid":'${user?.uid}','ownerUid${user?.uid}':'${user?.uid}'});
    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.fileName = fileName;
    userModel.ListCercles = [];
    userModel.userName = userNameControllerUp.text;
    // await firebaseFirestore
    //     .collection("users")
    //     .doc(user.uid).update({'ListCercles':FieldValue.arrayUnion([
    //   {room.}
    // ])});
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    const snackBar = SnackBar(
      content: Text(
        "Account created successfully",
        style: TextStyle(fontSize: 20),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);


    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => realTime()),
            (route) => false);

  }
}
