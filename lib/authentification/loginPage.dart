import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../halper/buttonHelp.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  String userEmail = "";

  var loading = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes : ['email']);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  final GlobalKey<FormState> _formKeyIn = GlobalKey<FormState>();

  String? emailIn ='';
  String? pwdIn= '';

  Widget build(BuildContext context) {

    GoogleSignInAccount?  user = _googleSignIn.currentUser;
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
        child:Align(
        alignment: Alignment.topCenter,
        child: Form(
            key: _formKeyIn,
            child: ListView(
              //padding: const EdgeInsets.only(right: 21.0,left: 21),
              //shrinkWrap:true,
              children: [
                const Align(
                    alignment: Alignment.center,
                    child: Text("Se connecter à votre compte" ,style: TextStyle(fontSize: 22),)),
                const SizedBox(height: 33,),
                   CustomContainerArg(smart: const Color(0xff57cc2e), buttonText: "CONTINUER AVEC GOOGLE", onTap: () async {
                    try {
                    await _googleSignIn.signIn();
                    setState(() {
                    });
                  } catch (error) {
                    print(error);
                  }
                  }, long: size.width, path: 'assets/images/chercher.svg',fontColor :Colors.black, baground: Colors.white,),


                SizedBox(height: 15,),
                CustomContainerArg(smart: const Color(0xff57cc2e), buttonText: "CONTINUER AVEC FACEBOOK", onTap: () async {
                  signInWithFacebook();}, long: size.width, path: 'assets/images/facebook.svg',fontColor :Colors.white,baground: Color(0xff3A5693)),
                SizedBox(height: 33,),
                Container(

                  child:    SvgPicture.asset('assets/images/OR.svg'),

                ),
                SizedBox(height: 33,),
                customField(controller: emailController, label: 'Email', hint: 'Votre email', long: size.width, type: TextInputType.emailAddress,),
                SizedBox(height: 15,),
                customField(controller: passwordController, label: 'Mot de passe', hint: 'Votre mot de passe', long: size.width, type: TextInputType.visiblePassword,),
                SizedBox(height: 17,),
                Padding(
                  padding: const EdgeInsets.only(right: 21),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'Mot de passe oublié ?',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff3979F8),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                              }),
                      ]),
                    ),
                  ),
                ),
                SizedBox(height: 48,),
                CustomContainer(long: size.width, smart: const Color(0xff57cc2e), onTap: onPressed2, buttonText: "CONNEXION",fontColor :Colors.white),

                SizedBox(height: 29,),

                Padding(
                  padding: const EdgeInsets.only(left: 70.0,),
                  child: Row(children: [Text("Vous n’avez pas de compte ? ",style: TextStyle(fontSize: 12,color:Color(0xff707070) ),),
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
                                Navigator.pushNamed(context, "/signup");
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(builder: (_) => inscription()),
                                // );
                              }),
                      ]),
                    ),
                  ],),
                ),
              ],
            )),
        ),
        ),
      ),
    );
  }
  onPressed2(){
    {
      final isvalidate = _formKeyIn.currentState!.validate();
      if(isvalidate){
        _formKeyIn.currentState?.save();
        //final message =  'Username: $username\n';
        signIn();
      }
    }
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
  Future signIn() async{
    //showDialog(context: context,barrierDismissible: false, builder: (context) =>Center(child: CircularProgressIndicator(),),);
    try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
        //Navigator.of(context).pop();
        Navigator.pushNamed(context, "/map");
        Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}

