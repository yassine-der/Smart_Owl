
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'HomePage.dart';
import '../halper/createmMaterialColor.dart';

class onBording extends StatefulWidget {
  const onBording({Key? key}) : super(key: key);

  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<onBording> {

  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage( double width,double height ) {

    //return Image.asset('assets/images/$assetName', width: width);

    return Container(
      height: height* 0.5,
      child: Stack(
        children: [
          //Image.asset('assets/images/first.png'),

          Image.asset('assets/images/map.png', width: width,fit: BoxFit.cover),
          Align(
              alignment: Alignment.center, // or AlignmentDirectional.center,
              //Alignment(0.0,0.0) value must be 1 to -1
              child:           Image.asset('assets/images/top.png', width: width*0.6,fit: BoxFit.fitWidth),

          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final  createMaterialColor = CreateMaterialColor();
    Color smart =createMaterialColor.createMaterialColor(Color(0xff57cc2e));

    final size = MediaQuery.of(context).size;

    //const bodyStyle = TextStyle(fontSize: 19.0)

    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 20.0),
      bodyTextStyle: TextStyle(fontSize: 14,color: Color.fromRGBO(84, 104, 114, 0.38)),
      titlePadding: EdgeInsets.fromLTRB(0.0,0,0.0,0),
      bodyPadding: EdgeInsets.fromLTRB(48.0, 0.0, 16.0, 48.0),
      //contentMargin:EdgeInsets.zero,
      //pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
      //fullScreen: true,

    );
    Widget title(){
      return Container(
        width: size.width,
        //height: 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.grey, spreadRadius: 3),
          ],
        ),

        child: Text("Localiser votre famille et vos amis",style: TextStyle(fontSize: 20.0),),
      );
    }
    Widget Header(){
      return  Container(

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey, spreadRadius: 3),
              ],
            ),

          height: size.height* 0.55,

          child: Text( "Affichez la position en temps réel des proches sur une carte familiale privée uniquement visible")
      );
    }

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
/*
      globalHeader: Align(
        alignment: Alignment.bottomCenter,
        //child:_buildImage('first.png', size.width,size.height),
      ),
*/

      globalFooter: Padding(
        padding: EdgeInsets.only(left: 20,right: 20,bottom: 15),
        child: Container(

          height: 46,

          width: size.width,
            child: ElevatedButton.icon(

              label: const Text(

                'SUIAVNT',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              onPressed: () => _onIntroEnd(context),
              icon:  Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 24.0,
              ),
              style: ElevatedButton.styleFrom(
              shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(8.0),
              ),
              ),
        ),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Localiser votre famille et vos amis",
          body: "Affichez la position en temps réel des proches sur une carte familiale privée uniquement visible",
          image: _buildImage( size.width,size.height),
          decoration: pageDecoration,
        ),

        PageViewModel(
          title: "Suivez le parcours de votre enfant",
          body:
          "Vérifiez que l’enfant est arrivé à l’école à l’heure - recevez des notifications lorsque il va à l’école, ses activités et à quelle heure il rentre",
          image: _buildImage( size.width,size.height),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Protégez votre famille notification SOS",
          body:
          "Recevez des alertes intelligentes en temps réel lorsque l’un de vos proches est en danger et a besoin d’aide",
          image: _buildImage( size.width,size.height),
          decoration: pageDecoration,
        ),
        /*
        PageViewModel(
          title: "Full Screen Page",
          body:
          "Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          image: _buildFullscreenImage(),
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
        ),

        PageViewModel(
          title: "Another title page",
          body: "Another beautiful body text for this example onboarding",
          image: _buildImage('first.png', size.width,size.height),

          footer: ElevatedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            child: const Text(
              'FooButton',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),

          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Title of last page - reversed",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Click on ", style: bodyStyle),
              Icon(Icons.edit),
              Text(" to edit a post", style: bodyStyle),
            ],
          ),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          image: _buildImage('first.png', size.width,size.height),
          //reverse: true,
        ),
                */

      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
      /*
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
      */
    );
  }
}

