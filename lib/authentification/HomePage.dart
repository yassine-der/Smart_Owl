import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_owl/authentification/seConnecter.dart';

import '../halper/createmMaterialColor.dart';
import 'inscription_par_mail.dart';
String userEmail = "";
GoogleSignIn _googleSignIn = GoogleSignIn(scopes : ['email']);

class HomePage extends StatelessWidget {

  const HomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final  createMaterialColor = CreateMaterialColor();
    Color smart =createMaterialColor.createMaterialColor(Color(0xff57cc2e));

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,
          elevation:0
      ),

      body:  SafeArea(
        child: Center(child: Align(
            alignment: Alignment.center, // or AlignmentDirectional.center,

            child: Column(
              children: [
                Text("Commencez absolument",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                Text(" gratuitement",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                SizedBox(height: 62,),
                Padding(
                  padding: const EdgeInsets.only(right: 20,left: 20),
                  child: Column(
                    children:[
                      Container(

                        height: 46,
                        width: size.width,
                        child: ElevatedButton(

                            onPressed: ()async{
                              try {
                                await _googleSignIn.signIn();
                              } catch (error) {
                                print(error);
                              }
                            }, child: Row(
                            children:[
                              SizedBox(width: 50,),
                              Container(
                                child:    SvgPicture.asset('assets/images/chercher.svg'),

                              ),
                              SizedBox(width: 10,),

                              Text("CONTINUER AVEC GOOGLE",style: TextStyle(color:  Colors.black,fontSize: 13),)] ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        side: BorderSide(color: Color(0xff9A9FB7),width: 1)
                                    )
                                )
                            )

                        ),

                      ),
                      SizedBox(height: 15,),
                      Container(

                        height: 46,
                        width: size.width,
                        child: ElevatedButton(

                            onPressed: (){
                              signInWithFacebook();

                            }, child: Row(
                            children:[
                              SizedBox(width: 50,),
                              Container(
                                child:    SvgPicture.asset('assets/images/facebook.svg'),

                              ),
                              SizedBox(width: 10,),

                              Text("CONTINUER AVEC FACEBOOK",style: TextStyle(color:  Colors.white,fontSize: 13),)] ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Color(0xff3A5693)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        side: BorderSide(color: Color(0xff9A9FB7),width: 1)
                                    )
                                )
                            )

                        ),

                      ),
                      SizedBox(height: 33,),
                      Container(

                        child:    SvgPicture.asset('assets/images/OR.svg'),

                      ),
                      SizedBox(height: 46,),

                      Container(
                        height: 46,

                        width: size.width,
                        child: ElevatedButton(

                            onPressed: (){

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const seConnecter()),
                              );

                            }, child: Text("S’INSCRIRE AVEC E-MAIL",style: TextStyle(color:  Colors.white,fontSize: 15),),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all( smart),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    )
                                )
                            )

                        ),

                      ),
                      SizedBox(height: 19,),

                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [

                            Text("Vous n’avez pas de compte ?",style: TextStyle(color: Color(0xff4C616B)),),
                            SizedBox(width: 5,),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: 'Créer un compte',
                                    style: TextStyle(
                                        fontSize: 12,
                                      color: Color(0xff3979F8),
                                    ),

                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const inscription()),
                                        );
                                      }),
                              ]),
                            ),

                           // Text("Créer un compte",style: TextStyle(color: Color(0xff3979F8)),)

                          ],
                        ),
                      )



                    ],
                  ),

                ),


              ],
            ))),
      ),

    );
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile', 'user_birthday']

    );

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    final userData = await FacebookAuth.instance.getUserData();

    userEmail = userData['email'];

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

}
/*        child: Column(
          children: [
            Center(
              child: Padding(

                padding: EdgeInsets.only(left: 20,right: 20,bottom: 15),
                child: Column(

                  mainAxisAlignment:MainAxisAlignment.end ,
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 46,

                      width: size.width,
                      child: ElevatedButton(

                          onPressed: (){

                          }, child: Text("C'EST PARTI !",style: TextStyle(color:  Colors.white,fontSize: 15),),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all( smart),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  )
                              )
                          )

                      ),

                    ),
                    SizedBox(height: 15,),


                    Container(

                      height: 46,
                      width: size.width,
                      child: ElevatedButton(

                          onPressed: (){}, child: Text("J'AI DÉJÀ UN COMPTE",style: TextStyle(color:  Colors.white,fontSize: 15,fontWeight: FontWeight.bold
                      ),),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Color(0xff3a5693)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(color: Color(0xff707070),width: 1)
                                  )
                              )
                          )

                      ),

                    ),
                  ],),
              ),
            ),
          ],
        ),
*/