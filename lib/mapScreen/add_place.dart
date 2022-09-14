import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../halper/buttonHelp.dart';
import '../halper/createmMaterialColor.dart';
import '../model/lieu_model.dart';

import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart' as slideDialog;



class addPlace extends StatefulWidget {
  const addPlace({Key? key}) : super(key: key);

  @override
  _addPlaceState createState() => _addPlaceState();
}

class _addPlaceState extends State<addPlace> {

  final placeController = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();

  GoogleMapController? mapController;

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  LatLng? latlangi;
  double? longR;
  double? latR;
  String? myName;
  String? cercleCode;
  String? CercleUid;
  String? iconIm;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};



  late BitmapDescriptor myIcon;



  //key Form
  final GlobalKey<FormState> _formKeyPlace = GlobalKey<FormState>();


  final passwordFocusNode = FocusNode();



  @override
  initState()  {
    // TODO: implement initState

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48.0, 48.0)),
      'assets/images/foisx.png',)
        .then((onValue) {
      myIcon = onValue;
    });

    super.initState();
    _getMyCercleUid();
  }


  @override
  Widget build(BuildContext context) {
    _getMyCercleUid();

    final size = MediaQuery
        .of(context)
        .size;

    // _getUserLocation();
    late List<Marker> _markers = [];
    // if (_userLocatio != null) {
      return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(backgroundColor: Colors.transparent,
              centerTitle: true,
              elevation:0
          ),

          extendBodyBehindAppBar: true,
          extendBody: true,
          body: Stack(
              children: [
                GoogleMap(

                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,

                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(20, 20),
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    setState(() {
                      mapController = controller;
                    });
                    _controller.complete(controller);
                  },
                  markers: Set<Marker>.of(markers.values), //all markers are here
                  compassEnabled: true,
                  tiltGesturesEnabled: false,
                  onLongPress: (latlang) {
                    _addMarkerLongPressed(latlang); //we will call this function when pressed on the map
                  },
                  //onCameraMove: _onCameraMove,
                ),

          Positioned(
                  bottom: size.height * 0.025,
                  left: size.width  * 0.05,
                  right: size.width * 0.05,
                  child: SizedBox(
                    width: size.width * 0.8,
                    height: size.width * 0.6,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),  // radius of 10
                          color: Colors.white  // green as background color
                      ),
                      //color:  Colors.white,
                      child: Form(
                        key: _formKeyPlace,

                        child: Column(
                          children: [
                            SizedBox(height: 21,),
                            Row(
                              children: [SizedBox(width: 21,),
                                customInk(onTap: () {iconIm = "assets/images/boxblue.png";}, smart: const Color(0xFF00BDFB), nameIcon: "assets/images/maison.png",),
                                customInk(onTap: () {iconIm = "assets/images/boxhome.png";}, smart: const Color(0xFF7B61F9), nameIcon: "assets/images/homee.png",),
                                customInk(onTap: () {iconIm = "assets/images/boxorange.png";}, smart: const Color(0xFFFD5129), nameIcon: "assets/images/orange.png",),
                                customInk(onTap: () {iconIm = "assets/images/boxgreen.png";}, smart: const Color(0xFF21BA45), nameIcon: "assets/images/green.png",),
                                customInk(onTap: () {iconIm = "assets/images/boxpink.png";}, smart: const Color(0xFFF810A8), nameIcon: "assets/images/pink.png",),
                              ],),
                            SizedBox(height:21 ,),
                            customField(controller: placeController, label: 'Maison', hint: 'Maison', long: size.width, type: TextInputType.text,),
                            SizedBox(height:19 ,),
                            CustomContainer(smart: Color(0xff57cc2e), onTap: () {
                              final isvalidateUp = _formKeyPlace.currentState!.validate();
                              if(isvalidateUp && cercleCode != null ){
                                _formKeyPlace.currentState?.save();
                                postDetailsToFirestore();
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Choisir une Cercle")));

                              }
                              // else if(CercleUid == null){
                              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Choisir une Cercle")));
                              //
                              // }
                              FocusScope.of(context).unfocus();

                            }, buttonText:"CRÉER UN LIEU", long: size.width,fontColor :Colors.white)
                          ],
                        ),
                      )
                      ,),
                  ),
                )
              ]
          ),
        ),
      );
    // }else{
    //   return Scaffold(
    //     body: Center(child: CircularProgressIndicator()),
    //   );
    // }
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future _addMarkerLongPressed(LatLng latlang) async {
    setState(() {
      final MarkerId markerId = MarkerId("RANDOM_ID");
      Marker marker = Marker(
        markerId: markerId,
        draggable: false,
        position: latlang, //With this parameter you automatically obtain latitude and longitude
        infoWindow: InfoWindow(
          title: "Marker here",
          snippet: 'This looks good',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );
      latlangi =latlang;
      markers[markerId] = marker;
    });

    //This is optional, it will zoom when the marker has been created
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(latlang, 17.0));
  }

  _getMyCercleUid() async {
    final prefs = await SharedPreferences.getInstance();

    cercleCode = prefs.getString('code');
    CercleUid = prefs.getString('CercleUid');
    print("tttTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
    print(cercleCode);
    print(CercleUid);

  }

  postDetailsToFirestore() async {
    final prefs = await SharedPreferences.getInstance();
    if(_formKeyPlace.currentState!.validate() && iconIm != null && latlangi !=null){

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Lieu lieu = Lieu();
    final String? myName = prefs.getString('myName');
    final String? myUid = prefs.getString('myUid');

    // writing all the values
    lieu.placeName = placeController.text;
    lieu.userName = myName!;
    lieu.lat = latlangi!.latitude.toString();
    lieu.long = latlangi!.longitude.toString();
    lieu.type = iconIm;
    lieu.cercleCode = iconIm;
    // await firebaseFirestore
    //     // .collection("users")
    //     // .doc(myUid)
    //     // .collection("cercle")
    //     // .doc(CercleUid)
    //     .collection("lieux")
    //     .add(lieu.toMap());
    await firebaseFirestore
    // .collection("users")
    // .doc(myUid)
        .collection("cercle")
        .doc(CercleUid).update({'myLieuUser':FieldValue.arrayUnion([
      {'placeName':placeController.text,
        'lat':latlangi!.latitude,
        'long':latlangi!.longitude,
        'type':iconIm,}
    ])});
      const snackBar = SnackBar(
      content: Text(
        "Place created successfully ) ",
        style: TextStyle(fontSize: 20),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    placeController.clear();
    }
  }

}
