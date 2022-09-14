import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart' as slideDialog;
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_owl/mapScreen/usersss.dart';
import '../halper/buttonHelp.dart';
import '../model/cercle_model.dart';
import '../model/user_model.dart';
import 'InToCercle.dart';
import 'add_place.dart';
import 'listLieu.dart';
import 'listPersone.dart';



class activite extends StatefulWidget {
  const activite({Key? key}) : super(key: key);

  @override
  _activiteState createState() => _activiteState();
}

class _activiteState extends State<activite> {
  double? latt  ;
  double? longg  ;
  String? emailAdd;
  String? uidAdd;
  String? cercleUidAA;
  String? cercleUidajout;
  String? userNameAdd;
  List? item = [];
  List? itemId = [];
  List? items = [];
  List? itemPos = [];
  List? getCercles = [];
  List? Cercles = [];
  String? _currentAddress;
  List<String>? idList = [];

  final cercleController = TextEditingController();
  final GlobalKey<FormState> _formKeyCercle= GlobalKey<FormState>();

  Completer<GoogleMapController> _controller = Completer();
  //
  GoogleMapController? mapController;

  LocationData? _userLocation;
  double? longR;
  double? latR;
  String? myName;
  String? myImagePath;
  String? myUid;
  String? myEmail;
  String? cercleName;
  String? CercleUid;
  String? code;
  String? stringuri;
  String? CercleOwnerId;
  Set<Marker>? _markers = new Set<Marker>() ;

  late BitmapDescriptor myIcon;
  late BitmapDescriptor boxblue;
  late BitmapDescriptor boxhome;
  late BitmapDescriptor boxorange;
  late BitmapDescriptor boxgreen;
  late BitmapDescriptor boxpink;
  @override
  initState()  {
    // TODO: implement initState

    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48.0, 48.0),devicePixelRatio:100),
      'aassets/images/boxblue.png',)
        .then((onValue) {
      boxblue = onValue;
    });
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48.0, 48.0),devicePixelRatio:100),
      'assets/images/boxhome.png',)
        .then((onValue) {
      boxhome = onValue;
    });
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48.0, 48.0),devicePixelRatio:100),
      'assets/images/boxorange.png',)
        .then((onValue) {
      boxorange = onValue;
    });
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48.0, 48.0),devicePixelRatio:100),
      'assets/images/boxgreen.png',)
        .then((onValue) {
      boxgreen = onValue;
    });
    BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48.0, 48.0),devicePixelRatio:100),
      'assets/images/boxpink.png',)
        .then((onValue) {
      boxpink = onValue;
    });

    super.initState();

    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    _getMyUid()!;
    _getMyCercleName()!;
    _getUserLocation();
    _getAddressFromLatLng(_userLocation);
    // Stream<QuerySnapshot>? _usersStream = FirebaseFirestore.instance.collection('users').doc(myUid).collection("cercle").snapshots();
    lol();
    myNameBro();

  }

  @override
  Widget build(BuildContext context) {

    _getMyUid()!;
    _getMyCercleName()!;
    myNameBro();
    DatabaseReference refer = FirebaseDatabase(databaseURL: 'https://smartowl-2f856-default-rtdb.europe-west1.firebasedatabase.app/').ref("usersPositios/${myUid}");
    DatabaseReference ref = FirebaseDatabase(databaseURL: 'https://smartowl-2f856-default-rtdb.europe-west1.firebasedatabase.app/').ref("usersPositions/");
    final size = MediaQuery.of(context).size;
    _getAddressFromLatLng(_userLocation);
    if (_userLocation != null && cercleName!= null && CercleOwnerId!= null && CercleUid!= null && code!= null ) {
      getMyUserName(_userLocation!.latitude!, _userLocation!.longitude!);
      _getAddressFromLatLng(_userLocation);
      // animationmap();
      return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          drawer: Drawer(
              child: ListView(

                children: [
                  ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const addPlace()),);
                    },
                    leading: Icon(Icons.message),
                    title: Text('addPlace'),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  UserInformation(myUid: myUid!, CercleUid: CercleUid!,)),
                        // MaterialPageRoute(builder: (context) =>  listLieu(CercleUid:CercleUid!)),
                      );
                    },
                    leading: Icon(Icons.account_circle),
                    title: Text('List lieux'),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  UserList(myUid: myUid!, CercleUid: CercleUid!,)),
                        // MaterialPageRoute(builder: (context) =>  listLieu(CercleUid:CercleUid!)),
                      );
                    },
                    leading: Icon(Icons.account_circle),
                    title: Text('List Personnes'),
                  ),
                  ListTile(
                    onTap: (){
                      logOut();
                    },
                    leading: Icon(Icons.settings),
                    title: Text('LogOut'),
                  ),
                ],
              )),

          appBar: AppBar(backgroundColor: Colors.transparent,
              centerTitle: true,
              title: ElevatedButton(
                  onPressed: () {

                    setupAlertDialoadContainer(context,size.width);
                  },
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [Text(cercleName!,style: TextStyle(color: Colors.white,fontSize: 13),),
                        Icon( Icons.keyboard_arrow_down_rounded,color: Colors.white,)]),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color(
                          0xff57cc2e)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )
                      )
                  )
              ),
              elevation:0
          ),
          extendBodyBehindAppBar: true,
          extendBody: true,
          body: Stack(
              children: [
            StreamBuilder(
            stream: ref.onValue,
            builder: (context, AsyncSnapshot snap) {
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data.snapshot.value != null) {
                Map data = snap.data.snapshot.value;
                items?.clear();
                data.forEach(
                        (index, data) =>
                        items?.add({"key": index, ...data}));
                // print(items);
                itemPos?.clear();

                for (var i = 0; i < items!.length; i++) {
                  itemPos?.add({"uid":"${items![i]['key']}","position":LatLng(items![i]['lat'],
                      items![i]['long'])});
                }
                // print(itemPos);
                return Container();
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
                 FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("cercle")
                      .doc(CercleUid)
                      .get(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if(snapshot.hasData && item!.isEmpty&& itemPos!.isNotEmpty){
                      item?.clear();
                      for(var j =0 ;j<snapshot.data!['myListUser'].length;j++){
                        // print(snapshot.data!['myListUser'][j]["userName"]);
                        item?.add({"name":snapshot.data!['myListUser'][j]["userName"],"file":snapshot.data!['myListUser'][j]["fileName"],"uid":snapshot.data!['myListUser'][j]["uid"]});
                        itemId?.add(snapshot.data!['myListUser'][j]["uid"]);
                      }
                      loadImage(itemPos);
                      return Container();
                    }else if (snapshot.hasError){
                      return CircularProgressIndicator();
                    }

                    return CircularProgressIndicator();
                  },
                ),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("cercle")
                      .doc(CercleUid)
                      .get(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if(snapshot.hasData ){
                      print("snapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotot");
                      print(snapshot.data!['myLieuUser'].length);
                      print(snapshot.data?['myLieuUser'][0]['placeName']);//souna
                      for(var k =0;k<snapshot.data!['myLieuUser'].length;k++){
                        // switch("${snapshot.data?['myLieuUser'][k]['type']}") {
                          if("${snapshot.data?['myLieuUser'][k]['type']}" =='aassets/images/boxblue.png')
                           {
                            _markers?.add(Marker(
                              // icon: myIcon,
                              icon: boxblue,
                              markerId: MarkerId("${snapshot.data?['myLieuUser'][k]['placeName']}${snapshot.data?['myLieuUser'][k]['lat']}"),
                              position: LatLng(snapshot.data?['myLieuUser'][k]['lat'],snapshot.data?['myLieuUser'][k]['long']),
                              infoWindow: InfoWindow(
                                title: "${snapshot.data?['myLieuUser'][k]['placeName']}",
                                snippet: cercleName!,
                              ),
                            ));
                          }
                          else if("${snapshot.data?['myLieuUser'][k]['type']}" =='assets/images/boxhome.png') {
                            _markers?.add(Marker(
                              // icon: myIcon,
                              icon: boxhome,
                              markerId: MarkerId("${snapshot.data?['myLieuUser'][k]['placeName']}${snapshot.data?['myLieuUser'][k]['lat']}"),
                              position: LatLng(snapshot.data?['myLieuUser'][k]['lat'],snapshot.data?['myLieuUser'][k]['long']),
                              infoWindow: InfoWindow(
                                title: "${snapshot.data?['myLieuUser'][k]['placeName']}",
                                snippet: cercleName!,
                              ),
                            ));
                          }
                          else if("${snapshot.data?['myLieuUser'][k]['type']}" =='assets/images/boxorange.png') {
                            _markers?.add(Marker(
                              // icon: myIcon,
                              icon: boxorange,
                              markerId: MarkerId("${snapshot.data?['myLieuUser'][k]['placeName']}${snapshot.data?['myLieuUser'][k]['lat']}"),
                              position: LatLng(snapshot.data?['myLieuUser'][k]['lat'],snapshot.data?['myLieuUser'][k]['long']),
                              infoWindow: InfoWindow(
                                title: "${snapshot.data?['myLieuUser'][k]['placeName']}",
                                snippet: cercleName!,
                              ),
                            ));
                          }
                          else if("${snapshot.data?['myLieuUser'][k]['type']}" =='assets/images/boxgreen.png') {
                            _markers?.add(Marker(
                              // icon: myIcon,
                              icon: boxgreen,
                              markerId: MarkerId("${snapshot.data?['myLieuUser'][k]['placeName']}${snapshot.data?['myLieuUser'][k]['lat']}"),
                              position: LatLng(snapshot.data?['myLieuUser'][k]['lat'],snapshot.data?['myLieuUser'][k]['long']),
                              infoWindow: InfoWindow(
                                title: "${snapshot.data?['myLieuUser'][k]['placeName']}",
                                snippet: cercleName!,
                              ),
                            ));
                          }
                          else{
                          // case 'assets/images/boxpink.png': {
                            _markers?.add(Marker(
                              // icon: myIcon,
                              icon: boxpink,
                              markerId: MarkerId("${snapshot.data?['myLieuUser'][k]['placeName']}${snapshot.data?['myLieuUser'][k]['lat']}"),
                              position: LatLng(snapshot.data?['myLieuUser'][k]['lat'],snapshot.data?['myLieuUser'][k]['long']),
                              infoWindow: InfoWindow(
                                title: "${snapshot.data?['myLieuUser'][k]['placeName']}",
                                snippet: cercleName!,
                              ),
                            ));
                          }




                      }
                      return Container();
                      // }
                    }else if (snapshot.hasError){
                      return CircularProgressIndicator();
                    }

                    return CircularProgressIndicator();
                  },
                )    ,
                //  GoogleMap(
                //   zoomControlsEnabled: false,
                //   mapType: MapType.normal,
                //   myLocationEnabled: true,
                //   myLocationButtonEnabled: true,
                //
                //   initialCameraPosition: CameraPosition(
                //     target: LatLng(20, 20),
                //   ),
                //   onMapCreated: (GoogleMapController controller) {
                //     setState(() {
                //       mapController = controller;
                //     });
                //     _controller.complete(controller);
                //   },
                //   // markers: Set<Marker>.of(_markers),
                //   markers: _markers!,
                // ),
                 GoogleMap(
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,

                  initialCameraPosition: CameraPosition(
                    target: LatLng(20, 20),
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    setState(() {
                      mapController = controller;
                    });
                    _controller.complete(controller);
                  },
                  // markers: Set<Marker>.of(_markers),

                  markers: _markers!,
                ),
                Positioned(
                  bottom: size.height * 0.09,
                  left: size.width  * 0.05,
                  right: size.width * 0.05,
                  child: SizedBox(
                    width: size.width * 0.8,
                    height: size.width * 0.3,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),// radius of 10
                          // side: BorderSide(color: Color(0xffE5EAF2),width: 1),
                          border: Border.all(
                              width: 1,color:Color(0xffE5EAF2)  //                   <--- border width here
                          ),

                          color: Colors.white  // green as background color
                      ),
                      //color:  Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 8,),

                          Center(
                            child: Row(
                              children: [
                                SizedBox(width: 16,),
                                Text('$myName (moi)',style: TextStyle(fontSize: 16),),
                                SizedBox(width: size.width*0.35,),

                                StreamBuilder<AndroidBatteryInfo?>(
                                    stream: BatteryInfoPlugin().androidBatteryInfoStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),// radius of 10
                                              color: Color(0xffE5EAF2)  // green as background color
                                          ),
                                          child: Row(
                                              children: [
                                                SizedBox(width: 5,),
                                                Text(
                                                  " ${(snapshot.data?.batteryLevel)} %",style: TextStyle(fontSize: 10),),
                                                Icon(Icons.battery_charging_full_rounded ,size :20),
                                                SizedBox(width: 5,),

                                              ]
                                          ),
                                          height: 25,
                                        );
                                      }
                                      return CircularProgressIndicator();
                                    })


                              ],
                            ),
                          ),
                          Divider(thickness: 1,indent:15,endIndent: 15,),

                          Padding(
                            padding: const EdgeInsets.only(left: 15,right: 15),
                            child: Text('$_currentAddress',style: TextStyle(fontSize: 12,color: Color(0xffA8B0BE),),),
                          ),

                        ],
                      )
                      ,),
                  ),
                ),
                FutureBuilder(
                  future: refer.once(),
                  builder: (context, AsyncSnapshot snap) {
                    if (snap.hasData &&
                        snap.data != null &&
                        (snap.data! as DatabaseEvent).snapshot.value !=
                            null) {
                      Map data = snap.data.snapshot.value;
                      List item = [];

                      data.forEach(
                            (index, data) =>
                            item.add({"key": index, ...data}),
                      );
                      loadInviImage(item[0]['fileName']);
                          if(stringuri !=null ){
                        return Transform.translate(
                          child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            color: Colors.white,
                            child: Form(
                              // key: _formKeyCercle,
                              child: ListView(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      children: [
                                        SizedBox(height: 44,),

                                        Container(
                                            width: 95.0,
                                            height: 95.0,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: new NetworkImage(
                                                        stringuri!)

                                                ))),
                                        SizedBox(height: 10,),
                                        // Text(data["${i}aa"]['userName'],style: TextStyle(fontSize: 15),),
                                        Text(item[0]['userName'],
                                          style: TextStyle(fontSize: 15),),
                                        Text("${item[0]['_currentAddress']}", style: TextStyle(fontSize: 13, color: Color(0xffA8B0BE)),),
                                        SizedBox(height: 38,),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 46.0, left: 46),
                                          child: Text(
                                            "Quelqu’un veut rejoindre ",
                                            style: TextStyle(fontSize: 22),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 46.0, left: 46),
                                          child: Text("votre cercle",
                                            style: TextStyle(fontSize: 22),),
                                        ),
                                        SizedBox(height: 10,),
                                        Text(
                                          "Vérifier l’identité de cette personne",
                                          style: TextStyle(fontSize: 16,
                                              color: Color(0xff58687F)),),
                                        SizedBox(height: 53,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AccRef(smart: Color(0xFFF00014)
                                                .withOpacity(0.1),
                                              fontColor: Color(0xFFF00014),
                                              onTap: () {
                                                refer.child("${item}aa}")
                                                    .remove();
                                                item.clear();
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          activite()), //sans const svp

                                                );
                                              },
                                              buttonText: 'REFUSER',),
                                            AccRef(smart: Color(0xFF57CC2E),
                                              fontColor: Colors.white,
                                              onTap: () {
                                                // print(item);
                                                postDetailsToFirestore1(
                                                    item[0]['email'],
                                                    item[0]['uid'],
                                                    item[0]['userName'],
                                                    item[0]['cercleUid'],
                                                    item[0]['fileName']);
                                                refer.child(item[0]['key'])
                                                    .remove();
                                                item.clear();
                                              },
                                              buttonText: 'ACCEPTER',)
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
                          } else {
                            return Container();
                          }
                    } else {
                      return Container();
                    }
                  },
                ),
              ]
          ),
        ),
      );

    }
    else {

      return Scaffold(

      body: Center(child: CircularProgressIndicator()),
      );
    }
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> _getAddressFromLatLng( LocationData?  localisation) async {
    await placemarkFromCoordinates(
        localisation!.latitude!, localisation.longitude!)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      _currentAddress = '${place.street},${place.subLocality}, ${place.postalCode}';

      setState(() {
        _currentAddress = '${place.street},${place.subLocality}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void createData(double lat,double long,String userName) async {
    DatabaseReference dbRef = FirebaseDatabase(databaseURL: 'https://smartowl-2f856-default-rtdb.europe-west1.firebasedatabase.app/').ref("usersPositions/${myUid}");
    dbRef.set({
      'lat': lat,
      'long': long,
      'myName': myName!,
      'myImagePath': myImagePath!
    });
  }
  Future<void> _getUserLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    location.onLocationChanged.listen((newLoc) {
      setState(() {
        _userLocation = newLoc;
      });
    });
  }
  void animationmap(){
    LatLng newlatlang = LatLng(_userLocation!.latitude!,_userLocation!.longitude!);
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: newlatlang, zoom: 13.4746,bearing: 0,tilt: 50)
        //17 is new zoom level
      ),);
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void getMyUserName(double lat,double long){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) async {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      if (user != null) {

        await firebaseFirestore
            .collection("users")
            .doc(user.uid).get().then(
              (DocumentSnapshot doc) {
            final data = doc.data() as Map<String, dynamic>;
            createData(lat,long,data['userName']);
          },
          onError: (e) => print("Error getting document: $e"),
        );
      }
    });
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  postDetailsToFirestore() async {
    final prefs = await SharedPreferences.getInstance();

    var url = Uri.parse('https://api.voucherjet.com/api/v1/p/generator');
    final msg = jsonEncode({"count": 1, "pattern": "D##-####", "characters" : "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890" });

    var response = await http.post(url, body: msg,    headers: <String, String>{
      "Content-Type": "application/json",},);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    Map<String, dynamic> temp = json.decode(response.body);
    if(_formKeyCercle.currentState!.validate()){
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      Room room = Room();
      final String? myName = prefs.getString('myName');
      final String? myUid = prefs.getString('myUid');
      // writing all the values
      room.myListUser = [];
      room.name = cercleController.text;
      room.code = temp['codes'][0];
      room.ownerUid = myUid;
      await firebaseFirestore
          .collection("cercle")
          .add({"myListUser":[
        {'email':myEmail,
          'uid':myUid,
          'fileName':myImagePath,
          'userName':myName,}
      ],"myLieuUser":[],"name":cercleController.text,"code":temp['codes'][0],"ownerUid":'${myUid}','ownerUid${myUid}':'${myUid}'});
    // .add(room.toFirestore());
      const snackBar = SnackBar(
        content: Text(
          "Cercle created successfully ) ",
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      cercleController.clear();
    }
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
    myUid = prefs.getString('myUid');
    myEmail = prefs.getString('myEmail');
    myName = prefs.getString('myName');
    myImagePath = prefs.getString('myImagePath');
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  setupAlertDialoadContainer(context,double long) async {
    final prefs = await SharedPreferences.getInstance();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // if(Cercles!.isNotEmpty){
            return AlertDialog(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      child: buttonWidgetCercle(
                          Icons.keyboard_arrow_up_rounded, 'Cercle', pop)
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                //Center Row contents horizontally,
                crossAxisAlignment: CrossAxisAlignment.start,
                //.where('ownerUid$myUid', isEqualTo: myUid)
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 5, left: 5),
                    child: Container(
                        color: Colors.white,
                        height: 350.0,
                        // Change as per your requirement
                        width: long,
                        // Change as per your requirement
                        child:  StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection("cercle").where('ownerUid$myUid', isEqualTo: myUid).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading");
                            }
                            return ListView(
                              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                return Column(
                                    children: [ListTile(
                                      // isThreeLine: true,
                                      title: Text(data['name']),
                                      // subtitle: Text("data['userName']"),
                                      trailing:  Icon(Icons.keyboard_arrow_right),
                                      // dense: true,
                                      // // selected: false,
                                      // // enabled: true,
                                      onTap: () async {
                                        _markers!.clear();
                                        await prefs.setString('CercleUid', document.id);
                                        await prefs.setString('CercleName', "${data['name']}");
                                        await prefs.setString('CercleOwnerId', "${data['ownerUid']}");
                                        await prefs.setString('code', "${data['code']}");
                                        Navigator.pop(context);
                                      },),
                                      Divider(),]
                                );
                              }).toList(),)
                            ;}
                              ,),
                    ),),
                  CustomContainer(onTap: () {
                    pop();
                    _openCustomDialog(context, long);
                  },
                    buttonText: "CRÉER UNE CERCLE",
                    fontColor: Color(0xFF57CC2E),
                    long: long,
                    smart: Colors.white,),
                  SizedBox(height: 15,),
                  CustomContainer(long: long,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => InToCercle()),
                      );
                    },
                    buttonText: 'PARTICIPER',
                    smart: Color(0xFF57CC2E),
                    fontColor: Colors.white,)
                ],
              ),
            );
        }
    );
  }
//////////////////////////
  void pop(){
    Navigator.of(context).pop();
  }
////////////////////////////////
  Widget buttonWidgetCercle(IconData icon,String text,VoidCallback onClicked){
    return ElevatedButton(
        onPressed: onClicked,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
          crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
          children: [
            Text(text ,style: TextStyle(color: Colors.white),),
            Icon(icon,color: Colors.white,),
          ],
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all( Color(0xFF57CC2E)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                )
            )
        )
    );
  }
  void _openCustomDialog(BuildContext context,width) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.61),
        transitionBuilder: (context,  animation1, animation2, widget) {
          return Transform.translate(
            child:   Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),

              color: Colors.white,

              child: Form(
                key: _formKeyCercle,

                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height:36 ,),

                          Text("Nouveau cercle",style: TextStyle(fontSize: 22),),
                          SizedBox(height:13 ,),
                          Padding(
                            padding:  EdgeInsets.only(left: 20,right: 20),
                            child: Text("Saisissez un nom qui correspond ",style: TextStyle(fontSize: 16,color: Color(0xFF58687F)),),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(left: 20,right: 20),
                            child: Text("à votre nouveau cercle.",style: TextStyle(fontSize: 16,color: Color(0xFF58687F)),),
                          ),
                          SizedBox(height:13 ,),
                          customField(label: 'Cercle', type: TextInputType.text, hint: 'Cercle', long: width, controller: cercleController,),
                          SizedBox(height:38 ,),
                          CustomContainer(long: width, onTap: () {
                            final isvalidateUp = _formKeyCercle.currentState!.validate();
                            if(isvalidateUp ){
                              _formKeyCercle.currentState?.save();
                              postDetailsToFirestore();}
                            FocusScope.of(context).unfocus();
                          }, buttonText: 'ENREGISTRER', smart: Color(0xff57cc2e), fontColor: Colors.white,)
                        ]
                    ),
                  ],
                ),
              ),
            ),
            offset: Offset(0, 200),
          );
        },
        transitionDuration:  Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }
  postDetailsToFirestore1(String email,String uid,String userName,String cercleUid,String imagePath) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Room room = Room();
    // writing all the values
    room.myListUser != null?  uid : uid;

    // writing all the values
    await firebaseFirestore
        .collection("cercle").where("code", isEqualTo: cercleUid).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        cercleUidajout = doc.id;
      });

    });
    await firebaseFirestore
        .collection("cercle")
        .doc(cercleUidajout).update({"ownerUid${uid}":"${uid}"});
    await firebaseFirestore
        .collection("cercle")
        .doc(cercleUidajout).update({'myListUser':FieldValue.arrayUnion([
      {'email':email,
        'uid':uid,
        'fileName':imagePath,
        'userName':userName,}
    ])});

    const snackBar = SnackBar(
      content: Text(
        "Place created successfully ) ",
        style: TextStyle(fontSize: 20),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  lol() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection("cercle").where("code", isEqualTo: cercleUidAA).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        cercleUidajout = doc.id;
      });
    });
  }
  myNameBro() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final prefs = await SharedPreferences.getInstance();

    await firebaseFirestore
        .collection("users").where("uid", isEqualTo: myUid).get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        await prefs.setString('myName', "${doc['userName']}");
        await prefs.setString('myImagePath', "${doc['fileName']}");
        await prefs.setString('_currentAddress', _currentAddress!);

      });
    });
  }
  logOut() async{
    FirebaseAuth.instance.signOut();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  _getMyCercleName() async {
    final prefs = await SharedPreferences.getInstance();
    cercleName = prefs.getString('CercleName');
    code = prefs.getString('code');
    CercleOwnerId = prefs.getString('CercleOwnerId');
    CercleUid = prefs.getString('CercleUid');

    if (cercleName != null || CercleOwnerId != null|| code != null) {
      cercleName = prefs.getString('CercleName');
      CercleOwnerId = prefs.getString('CercleOwnerId');
      CercleUid = prefs.getString('CercleUid');
      code = prefs.getString('code');

    } else {
      //.where("ownerUid", isEqualTo: myUid)
      await FirebaseFirestore.instance
          .collection("cercle").where("ownerUid", isEqualTo: "${myUid}").where("name", isEqualTo: "Familly").get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          await prefs.setString('CercleName', "${doc['name']}");
          await prefs.setString('CercleOwnerId', "$myUid");
          await prefs.setString('CercleUid', "${doc.id}");
          await prefs.setString('code', "${doc['code']}");
          cercleName = prefs.getString('CercleName');
          CercleOwnerId = prefs.getString('CercleOwnerId');
          CercleUid = prefs.getString('CercleUid');
          code = prefs.getString('code');

        });
      });

    }
  }

  DatabaseReference ref = FirebaseDatabase(
      databaseURL: 'https://smartowl-2f856-default-rtdb.europe-west1.firebasedatabase.app/')
      .ref("usersPositions/");
   loadInviImage(String pathou)async{
  final storageRef = FirebaseStorage.instance.ref();
  final mountainsRef = storageRef.child(pathou);
  String stringurii;
  stringurii = await mountainsRef.getDownloadURL();
  stringuri = stringurii ;
}
  loadImage(List<dynamic>? lista) async{
      final storageRef = FirebaseStorage.instance.ref();
      for (var i = 0; i < item!.length; i++) {
            final mountainsRef = storageRef.child(item![i]['file']);
            String stringurii;
            Uri urii;

            stringurii = await mountainsRef.getDownloadURL();
            urii = Uri.parse(stringurii);
            var dataBytes;
            urii = Uri.parse(stringurii);
            var request = await http.get(urii);
            var bytes = await request.bodyBytes;
            ui.Image originalUiImage = await decodeImageFromList(bytes);
            ByteData? originalByteData = await originalUiImage.toByteData();
            var codec = await ui.instantiateImageCodec(bytes,
                targetHeight: 50, targetWidth: 50);
            var frameInfo = await codec.getNextFrame();
            ui.Image targetUiImage = frameInfo.image;

            ByteData? targetByteData = await targetUiImage.toByteData(
                format: ui.ImageByteFormat.png);
        setState(() {
          dataBytes = targetByteData;
        });
                // if (item![1]['key'] != myUid){
            final  index = lista?.indexWhere((element) =>
            element["uid"] == "${item![i]['uid']}");

            LatLng _lastMapPositionPoints = lista![index!]["position"];
            if("${item![i]['uid']}" != myUid){
        _markers?.add(Marker(
          // icon: myIcon,
          icon: BitmapDescriptor.fromBytes(dataBytes!.buffer.asUint8List()),
          markerId: MarkerId("${item![i]['uid']}"),
          position: _lastMapPositionPoints,
          infoWindow: InfoWindow(
            title: "${item![i]['name']}",
            snippet: cercleName!,
          ),
        ));
      }
    }
    //  FutureBuilder<DocumentSnapshot>(
    //   future: FirebaseFirestore.instance
    //       .collection("cercle")
    //       .doc(CercleUid)
    //       .get(),
    //   builder: (BuildContext context, snapshot) {
    //     if (snapshot.hasError) {
    //       return Text('Something went wrong');
    //     }
    //     if(snapshot.connectionState == ConnectionState.waiting){
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    //     if(snapshot.hasData && item!.isEmpty&& itemPos!.isNotEmpty){
    //       item?.clear();
    //       for(var j =0 ;j<snapshot.data!['myListUser'].length;j++){
    //         // print(snapshot.data!['myListUser'][j]["userName"]);
    //         item?.add({"name":snapshot.data!['myListUser'][j]["userName"],"file":snapshot.data!['myListUser'][j]["fileName"],"uid":snapshot.data!['myListUser'][j]["uid"]});
    //         itemId?.add(snapshot.data!['myListUser'][j]["uid"]);
    //       }
    //       loadImage(itemPos);
    //       return Container();
    //     }else if (snapshot.hasError){
    //       return CircularProgressIndicator();
    //     }
    //
    //     return CircularProgressIndicator();
    //   },
    // );

  }

   // Future<Widget> loadImage(String pathi,double lat ,double long ,String title,String id,Set<Marker>? _markers) async {

   //  loadImagea() async {
   //   // print(pathi);
   //   // print(lat);
   //   // print(long);
   //   item?.clear();
   //   final storageRef = FirebaseStorage.instance.ref();
   //   for (var i = 0; i < item!.length; i++) {
   //     final mountainsRef = storageRef.child(item![0]['myImagePath']);
   //     String stringurii;
   //     Uri urii;
   //
   //     stringurii = await mountainsRef.getDownloadURL();
   //     urii = Uri.parse(stringurii);
   //     // print("pathipathipathipathipathipathipathipathipathipathipathipathipathipathipathipathipathipathipathipathipathi");
   //
   //     print(urii);
   //     var dataBytes;
   //     var request = await http.get(urii);
   //     var bytes = await request.bodyBytes;
   //     ui.Image originalUiImage = await decodeImageFromList(bytes);
   //     // ByteData? originalByteData = await originalUiImage.toByteData();
   //     // print(
   //     //     'original image ByteData size is ${originalByteData
   //     //         ?.lengthInBytes}');
   //
   //     var codec = await ui.instantiateImageCodec(bytes,
   //         targetHeight: 50, targetWidth: 50);
   //     var frameInfo = await codec.getNextFrame();
   //     ui.Image targetUiImage = frameInfo.image;
   //
   //     ByteData? targetByteData = await targetUiImage.toByteData(
   //         format: ui.ImageByteFormat.png);
   //     // print('target image ByteData size is ${targetByteData?.lengthInBytes}');
   //     // targetlUinit8List = targetByteData?.buffer.asUint8List();
   //
   //     setState(() {
   //       dataBytes = targetByteData;
   //     });
   //
   //     LatLng _lastMapPositionPoints = LatLng(
   //         item![i]['lat'],
   //         item![i]['long']);
   //
   //     // if (item![0]['key'] != myUid){
   //
   //     _markers?.add(Marker(
   //       // icon: myIcon,
   //       icon: BitmapDescriptor.fromBytes(dataBytes.buffer.asUint8List()),
   //       markerId: MarkerId("${item![0]['key']}"),
   //       position: _lastMapPositionPoints,
   //       infoWindow: InfoWindow(
   //         title: "${item![0]['key']}",
   //         snippet:
   //         cercleName!,
   //       ),
   //     ));
   //   }
   // // }
   //  return _markers;
   //
   // }
  // loadImage(String pathi,double lat ,double long ,String title,String id,Set<Marker>? _markers) async {
  //   print("pathipathipathipathipathipathipathipathipathipathipathipathipathipathipathipathipathipathipathipathipathi");
  //   print(pathi);
  //   print(lat);
  //   print(long);
  //   final storageRef = FirebaseStorage.instance.ref();
  //   final mountainsRef = storageRef.child("96b8983b-77be-45e1-aa79-802e2dc223f02024646852551311902.jpg");
  //   String stringurii;
  //   Uri urii;
  //
  //   stringurii = await mountainsRef.getDownloadURL();
  //   urii = Uri.parse(stringurii);
  //
  //   var dataBytes;
  //   var request = await http.get(urii);
  //   var bytes = await request.bodyBytes;
  //   ui.Image originalUiImage = await decodeImageFromList(bytes);
  //   ByteData? originalByteData = await originalUiImage.toByteData();
  //   print('original image ByteData size is ${originalByteData?.lengthInBytes}');
  //
  //   var codec = await ui.instantiateImageCodec(bytes,
  //       targetHeight: 50, targetWidth: 50);
  //   var frameInfo = await codec.getNextFrame();
  //   ui.Image targetUiImage = frameInfo.image;
  //
  //   ByteData? targetByteData = await targetUiImage.toByteData(format: ui.ImageByteFormat.png);
  //   // print('target image ByteData size is ${targetByteData?.lengthInBytes}');
  //   // targetlUinit8List = targetByteData?.buffer.asUint8List();
  //
  //   setState(() {
  //     dataBytes = targetByteData;
  //   });
  //
  //   LatLng _lastMapPositionPoints = LatLng(
  //       37.076885,
  //       25.217025);
  //
  //
  //   _markers?.add(Marker(
  //     // icon: myIcon,
  //     icon: BitmapDescriptor.fromBytes(dataBytes.buffer.asUint8List()),
  //     markerId: MarkerId("id.toString()"),
  //     position: _lastMapPositionPoints,
  //     infoWindow: InfoWindow(
  //       title: "title",
  //       snippet:
  //       "My Position",
  //     ),
  //   ));
  //
  // }


  // loadImage() async{
  //   DatabaseReference ref = FirebaseDatabase(
  //       databaseURL: 'https://smartowl-2f856-default-rtdb.europe-west1.firebasedatabase.app/')
  //       .ref("usersPositions/");
  //   final snapshot = await ref.get();
  //   if (snapshot.exists) {
  //        print("urlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurl");
  //
  //     print(snapshot.value);
  //   } else {
  //     print('No data available.');
  //   }
  //
  // }





  // loadImage(String pathi) async{
  //    // Reference ref = FirebaseStorage.instanceFor(bucket: "gs://smartowl-2f856.appspot.com").child("6b0f15ce-cd80-4c8f-8070-1041bc6ec4172568089117014079973.jpg");
  //    // final storage = FirebaseStorage.instanceFor(bucket: "gs://smartowl-2f856.appspot.com");
  //    final storage = FirebaseStorage.instance;
  //
  //    final ref = storage.ref().child("6b0f15ce-cd80-4c8f-8070-1041bc6ec4172568089117014079973.jpg");
  //
  //    //get image url from firebase storage
  //   //  print("markersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkersmarkers");
  //
  //    var url = await ref.getDownloadURL();
  //
  //    // var iconurl ="url";
  //   var dataBytes;
  //    print(url);
  //    print("urlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurlurl");
  //
  //    Uri myUri = Uri.parse(url);
  //
  //
  //    var request = await http.get(myUri );
  //    var bytes = await request.bodyBytes;
  //   setState(() {
  //     dataBytes = bytes;
  //   });
  //
  //   // print('url: ' + url);
  //   setState(() {
  //
  //     myIcon=  BitmapDescriptor.fromBytes(dataBytes.buffer.asUint8List());
  //   });
  //   // return BitmapDescriptor.fromBytes(dataBytes.buffer.asUint8List());
  // }

  // _customMarker(String symbol, Color color) {
  //   return Stack(
  //     children: [
  //       Icon(
  //         Icons.add_location,
  //         color: color,
  //         size: 50,
  //       ),
  //       Positioned(
  //           left: 15,
  //           top: 8,
  //           child: Container(
  //             width: 20,
  //             height: 20,
  //             decoration: BoxDecoration(
  //                 color: Colors.white, borderRadius: BorderRadius.circular(10)),
  //             child: ClipOval(child: Image.network("https://i.imgur.com/BoN9kdC.png",
  //               width: 10,
  //               height: 10,
  //               fit: BoxFit.cover,
  //             )),
  //           ))
  //     ],
  //   );
  // }
  // _customMarker2(String symbol, Color color) {
  //   return Container(
  //     width: 30,
  //     height: 30,
  //     margin: const EdgeInsets.all(8),
  //     decoration: BoxDecoration(
  //         border: Border.all(color: color, width: 2),
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(15),
  //         boxShadow: [BoxShadow(color: color, blurRadius: 6)]),
  //     child: Center(child: Text(symbol)),
  //   );
  // }
  //
  // _customMarker3(String text, Color color) {
  //   return Container(
  //     margin: const EdgeInsets.all(8),
  //     padding: const EdgeInsets.all(8),
  //     decoration: BoxDecoration(
  //         border: Border.all(color: color, width: 2),
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(4),
  //         boxShadow: [BoxShadow(color: color, blurRadius: 6)]),
  //     child: Center(
  //         child: Text(
  //           text,
  //           textAlign: TextAlign.center,
  //         )),
  //   );
  // }

//   Future<void> _buildMarkers() async {
//     //final bitMapDescriptors = await createBitmapDescriptors(stops.length);
//     final bitmapDescriptor = await MarkerGenerator(70)
//         .createBitmapDescriptorFromIconData(Icons.info, Colors.white, Colors.teal, Colors.transparent);
//
//     final markers = Set<Marker>();
//
//     final marker = Marker(
//       markerId: MarkerId('markerA'),
//       position: LatLng(-36.7704774, 174.8618268),
//       icon: bitmapDescriptor,
//     );
//
//     markers.add(marker);
// // print(markers);
//     setState(() => _markers = markers);
//   }
}
// class Common {
//   static Future<Uint8List?> getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
//   }
// }
//
// class MarkerGenerator {
//   final double _markerSize;
//   double? _circleStrokeWidth;
//   double? _circleOffset;
//   double? _outlineCircleWidth;
//   double? _fillCircleWidth;
//   double? _iconSize;
//   double? _iconOffset;
//
//   MarkerGenerator(this._markerSize) {
//     // calculate marker dimensions
//     _circleStrokeWidth = _markerSize / 10.0;
//     _circleOffset = _markerSize / 2;
//     _outlineCircleWidth = (_circleOffset! - (_circleStrokeWidth! / 2));
//     _fillCircleWidth = _markerSize / 2;
//     final outlineCircleInnerWidth = _markerSize - (2 * _circleStrokeWidth!);
//     _iconSize = sqrt(pow(outlineCircleInnerWidth, 2) / 2);
//     final rectDiagonal = sqrt(2 * pow(_markerSize, 2));
//     final circleDistanceToCorners = (rectDiagonal - outlineCircleInnerWidth) / 2;
//     _iconOffset = sqrt(pow(circleDistanceToCorners, 2) / 2);
//   }
//
//   /// Creates a BitmapDescriptor from an IconData
//   Future<BitmapDescriptor> createBitmapDescriptorFromIconData(
//       IconData iconData, Color iconColor, Color circleColor, Color backgroundColor) async {
//     final pictureRecorder = ui.PictureRecorder();
//     final canvas = Canvas(pictureRecorder);
//
//     _paintCircleFill(canvas, backgroundColor);
//     _paintCircleStroke(canvas, circleColor);
//     _paintIcon(canvas, iconColor, iconData);
//
//     final picture = pictureRecorder.endRecording();
//     final image = await picture.toImage(_markerSize.round(), _markerSize.round());
//     final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
//
//     return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
//   }
//
//   /// Paints the icon background
//   void _paintCircleFill(Canvas canvas, Color color) {
//     final paint = Paint()
//       ..style = PaintingStyle.fill
//       ..color = color;
//     canvas.drawCircle(Offset(_circleOffset!, _circleOffset!), _fillCircleWidth!, paint);
//   }
//   // Future<void> _paintimage(Canvas canvas, Color color) async {
//   //   // final imager = Image(image: Image.asset("boxhome.png"),);
//   //   final ui.Image image = await  getImage('https://picsum.photos/250?image=9',);
//   //
//   //   final paint = Paint()
//   //     ..style = PaintingStyle.fill
//   //     ..color = color;
//   //
//   //   canvas.drawImage(image,Offset(_circleOffset!, _circleOffset!),  paint);
//   // }
//   /// Paints a circle around the icon
//   void _paintCircleStroke(Canvas canvas, Color color) {
//     final paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..color = color
//       ..strokeWidth = _circleStrokeWidth!;
//     canvas.drawCircle(Offset(_circleOffset!, _circleOffset!), _outlineCircleWidth!, paint);
//   }
//
//   /// Paints the icon
//   void _paintIcon(Canvas canvas, Color color, IconData iconData) {
//     final textPainter = TextPainter(textDirection: TextDirection.ltr);
//     textPainter.text = TextSpan(
//         text: String.fromCharCode(iconData.codePoint),
//         style: TextStyle(
//           letterSpacing: 0.0,
//           fontSize: _iconSize,
//           fontFamily: iconData.fontFamily,
//           color: color,
//         ));
//     textPainter.layout();
//     textPainter.paint(canvas, Offset(_iconOffset!, _iconOffset!));
//   }
//
//
//
//
//
//
//
//







  // Future<ui.Image> getImage(String path) async {
  //
  //   var completer = Completer<ImageInfo>();
  //   var img = new NetworkImage(path);
  //   img.resolve(const ImageConfiguration()).addListener(ImageStreamListener((info, _) {
  //     completer.complete(info);
  //   }));
  //   ImageInfo imageInfo = await completer.future;
  //   return imageInfo.image;
  // }
  //
// void _paintimage(Canvas canvas, Color color) async {
//   // final imager = Image(image: Image.asset("boxhome.png"),);
//   final ui.Image image = await  getImage("https://i.imgur.com/BoN9kdC.png",);
//
//   final paint = Paint()
//     ..style = PaintingStyle.fill
//     ..color = color;
//
//   canvas.drawImage(image,Offset(50, 50),  paint);
// }


//Transform.translate(
//   décalage : Offset(0,200),
//   enfant : RepeindreBoundary(
//     clé : iconKey,
//     enfant : IconButton(icon : Icon(Icons. star ),
//         onPressed : () {
//           // Faire quelque chose
//         }),
//   ),
// ),


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   void readData(){
//     DatabaseReference ref = FirebaseDatabase(databaseURL:'https://smartowl-2f856-default-rtdb.europe-west1.firebasedatabase.app/').ref("usersPositios/${myUid}/");
//
//       print(ref.parent!.key); // "users"
//
//     DatabaseReference long = ref.child('1');
//     // DatabaseReference lat = ref.child("lat");
//     Stream<DatabaseEvent> streamLong = long.onValue;
//     // Stream<DatabaseEvent> streamLat = lat.onValue;
//     // Subscribe to the stream!
//     streamLong.listen((DatabaseEvent event) {
//       // print(ref.key); // "123"
//       // print(ref.parent!.key); // "users"
//       //print('Event Type: ${event.type}'); // DatabaseEventType.value;
//       print('Snapshot: ${event.snapshot.value}'); // DataSnapshot
//       DatabaseReference long = ref.child('1').child('uid');
//       Stream<DatabaseEvent> streamLong = long.onValue;
//
//       streamLong.listen((DatabaseEvent event) {
//         print('Snapshot: ${event.snapshot.value}'); // DataSnapshot
//       });
//
//
//       // longR = event.snapshot.value as double? ;
//     });
//     // streamLat.listen((DatabaseEvent event) {
//     //   latR = event.snapshot.value as double?;
//     // });
//   }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
