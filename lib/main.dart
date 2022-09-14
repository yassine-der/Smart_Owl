import 'dart:typed_data';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/widgets.dart';
import 'package:location/location.dart';
import 'package:smart_owl/authentification/splashScreen.dart';
import 'dart:async';
import 'dart:convert' show json;
import 'dart:ui' as ui; // imported as ui to prevent conflict between ui.Image and the Image widget

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'authentification/HomePage.dart';
import 'authentification/inscription_par_mail.dart';
import 'authentification/loginPage.dart';
import 'halper/createmMaterialColor.dart';
import 'halper/formText.dart';
import 'halper/koko.dart';
import 'halper/place.dart';
import 'mapScreen/add_place.dart';
import 'mapScreen/listLieu.dart';
import 'mapScreen/realTimeMap.dart';
import 'authentification/onBordingScreen.dart';
// Import the generated file
//import 'firebase_options.dart';



import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    //options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();


  runApp(const MyApp());

}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final  createMaterialColor = CreateMaterialColor();

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },

      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        //navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        theme: ThemeData(

          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          fontFamily: 'Din',
        primarySwatch:createMaterialColor.createMaterialColor(Color(0xff57cc2e)),
        ),
        routes: {
          '/': (context) => Splashscreen(),
          '/first': (context) => onBording(),
          '/addPlace': (context) => addPlace(),
          '/signup': (context) => inscription(),
          '/signin': (context) => loginPage(),
          '/map': (context) => realTime(),
          // '/listLieu': (context) => listLieu(),
        },

        // home: MyHomePage(title: 'map',),
        // home: ImageUploads(),
      ),
    );
  }
}



class HomePage1 extends StatefulWidget {
  const HomePage1({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage1> {


  int _currentIndex = 0;
  ThemeStyle _currentStyle = ThemeStyle.NotificationBadge;

  List<int> _badgeCounts = List<int>.generate(5, (index) => index);

  List<bool> _badgeShows = List<bool>.generate(5, (index) => true);

  Completer<GoogleMapController> _controller = Completer();
  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );
  //
  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);
  //
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _userLocation;



  Future<void> _getUserLocation() async {
    Location location = Location();

    // Check if location service is enable
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final _locationData = await location.getLocation();
    setState(() {
      _userLocation = _locationData;
    });
    location.onLocationChanged.listen((newLoc) {
      _userLocation = newLoc;
      setState(() {

      });
    });


  }
  late BitmapDescriptor myIcon;


  @override
   initState()  {

    // TODO: implement initState
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48.0, 48.0)), 'assets/images/current.png',)
        .then((onValue) {
      myIcon = onValue;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    _getUserLocation();
    // print("${_userLocation!.latitude!} +++++ ${_userLocation!.longitude!}");

    if(_userLocation != null){
      return Scaffold(

        extendBody: true,

        body:  GoogleMap(

          zoomControlsEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(_userLocation!.latitude!,_userLocation!.longitude!),
            zoom: 14.4746,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: {

        Marker(
                markerId: MarkerId('SomeId'),
                position: LatLng(_userLocation!.latitude!,_userLocation!.longitude!),
                icon: myIcon,
                infoWindow: InfoWindow(
                    title: 'The title of the marker',
                  snippet: 'Start Marker',

                )
            )
          },
        ),
        bottomNavigationBar:_buildFloatingBar() ,
      );
    }
else{
      return Scaffold(
        body:Center(child: Text("Loading"),),
      );
    }
  }

  Widget _buildFloatingBar() {
    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: Color(0xff57CC2E),
      strokeColor: Color(0xff57CC2E),
      unSelectedColor: Color(0xff4C616B),
      backgroundColor: Colors.white,

      borderRadius: Radius.circular(20.0),

      items: [
        CustomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          title: Text("Home",style: TextStyle(color: Color(0xff57CC2E)),),


        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.add_box_rounded ),
          title: Text("Home",style: TextStyle(color: Color(0xff57CC2E)),),
          badgeCount: _badgeCounts[1],
          showBadge: _badgeShows[1],


        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.add_box_rounded ),
          title: Text("Home",style: TextStyle(color: Color(0xff57CC2E)),),

        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("Home",style: TextStyle(color: Color(0xff57CC2E)),),

        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.reorder_sharp),
          title: Text("MENU",style: TextStyle(color: Color(0xff57CC2E)),),


        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
          _badgeShows[index] = false;
        });
      },
      isFloating: true,
      opacity: 0.8,


    );
  }


}

enum ThemeStyle {
  Dribbble,
  Light,
  NoElevation,
  AntDesign,
  BorderRadius,
  FloatingBar,
  NotificationBadge,
  WithTitle,
  BlurEffect
}






