import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../halper/buttonHelp.dart';
import 'seConnecter.dart';
import '../halper/createmMaterialColor.dart';
import 'onBordingScreen.dart';

class Splashscreen extends StatelessWidget {
  const Splashscreen({Key? key}) : super(key: key);
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
          body:  Stack(
                  children: [
                     Image.asset('assets/images/first.png',fit: BoxFit.cover,width: size.width,height: size.height,),
                    Center(
                      child: Padding(

                        padding: EdgeInsets.only(left: 20,right: 20,bottom: 15),
                        child: Column(

                          mainAxisAlignment:MainAxisAlignment.end ,
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            child: Image.asset('assets/images/logo.png'),
                          ),
                          SizedBox(height: 280),
                          Container(
                            height: 46,

                            width: size.width,
                            child: ElevatedButton(

                                onPressed: (){

                                  Navigator.pushReplacementNamed(context, "/signin");


                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const onBording()),
                                  );

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

                                onPressed: (){
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) => seConnecter()));


                                  // Navigator.of(context).push(
                                  //   MaterialPageRoute(builder: (_) => seConnecter()),
                                  // );

                                  //Navigator.pushNamed(context, "/first");

                                }, child: Text("J'AI DÉJÀ UN COMPTE",style: TextStyle(color:  smart,fontSize: 15),),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          side: BorderSide(color: smart,width: 1)
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

      ),
    );
  }

  onPressed2(BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => seConnecter()),
    );

  }
}
