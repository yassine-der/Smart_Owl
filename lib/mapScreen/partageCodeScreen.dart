import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../authentification/encrypt.dart';
import '../halper/buttonHelp.dart';


import 'package:encrypt/encrypt.dart' as encrypt;


// encrypt.Encrypted? encrypted = EncryptData.encryptAES('${code!}-$myUid');
// print(encrypted);
// print("encryptedencryptedencryptedencryptedencryptedencryptedencryptedencryptedencryptedencryptedencryptedencrypted");



class PartageCode extends StatefulWidget {
  const PartageCode({Key? key, required this.userUid, required this.code, required this.CercleOwnerId}) : super(key: key);
  final String userUid;
  final String code;
  final String CercleOwnerId;

  @override
  _PartageCodeState createState() => _PartageCodeState();
}

class _PartageCodeState extends State<PartageCode> {

  String? encryp;
  String? cercleName;
  String? code;

  String? CercleOwnerId;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _getMyCercleName();
    // encryp = "${code}-${CercleOwnerId}";
    // print("${encryp}");


  }

  @override
  Widget build(BuildContext context) {


    _getMyCercleName();
    print("itemitemitemitemitemitemitemitemitemitemitemitemitemitemitemitemitemitemitemitemitemitemitemitem");
    print("${widget.CercleOwnerId}");
    print("${widget.code}");

    encryp = "${code}-${CercleOwnerId}";

print("zzzzzzzz${encryp}");



    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
          children: [Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 42,right: 42),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 64.5,),

                  SvgPicture.asset('assets/images/parents.svg'),
                  SizedBox(height: 15,),
                  Text("Partager ce code d’invitation avec votre famille",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 12,),
                  Text("vous pouvez partager ce code comme vous le souhaitez: par texto, par e-mail etc..",style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal,color: Color(0xFF4C616B)),),
                  SizedBox(height: 16,),
                  GestureDetector(
                    child: Container(
                      height: 77,
                      width: 236,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xFF57CC2E).withOpacity(0.1),
                      ),
                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${widget.code}-${widget.CercleOwnerId}",style: TextStyle(fontSize: 15,color: Color(0xFF21BA45)),),
                      )),
                    ),

                    onLongPress: (){
                      Clipboard.setData(ClipboardData(text: "${widget.code}-${widget.CercleOwnerId}")).then((_){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Code copied to clipboard")));
                      });

                    },
                  ),
                  SizedBox(height: 17,),

                  Text("Ce code est valable jusqu’à mai 10,2022",style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal,color: Color(0xFF4C616B)),),

                  SizedBox(height: size.height*0.2,),

                ],
              ),
            ),
          ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomContainer(onTap: () {

                  }, buttonText: "CRÉER UN LIEN DE PARTAGE", fontColor: Color(0xFF57CC2E), long: size.width, smart: Colors.white,),
                  SizedBox(height: 15,),
                  CustomContainer(onTap: () {
                    Clipboard.setData(ClipboardData(text: "${widget.code}-${widget.CercleOwnerId}")).then((_){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Code copiée")));
                    });

                  }, buttonText: "PARTAGEZ LE CODE", fontColor: Colors.white, long: size.width, smart: Color(0xFF57CC2E),),
                  // SizedBox(height: 15,),

                ],
              ),
            )

          ]
      ),
    );
  }
  _getMyCercleName() async {
    final prefs = await SharedPreferences.getInstance();

    cercleName = prefs.getString('CercleName');
    code = prefs.getString('code');
    CercleOwnerId = prefs.getString('CercleOwnerId');

    if (cercleName != null || CercleOwnerId != null|| code != null) {
      cercleName = prefs.getString('CercleName');
      CercleOwnerId = prefs.getString('CercleOwnerId');
      code = prefs.getString('code');

    } else {
      cercleName = "None";
      CercleOwnerId = "None";
      code = "None";

    }
  }


}








