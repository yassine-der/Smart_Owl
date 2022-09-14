import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/lieu_model.dart';

class listLieu extends StatefulWidget {
  const listLieu({Key? key, required this.CercleUid}) : super(key: key);
  final String CercleUid;


  @override
  _listLieuState createState() => _listLieuState();
}

class _listLieuState extends State<listLieu> {


String? myUid;
String? _currentAddress;
String? CercleUid;
List<Object>? dataList ;
 late   Stream<QuerySnapshot> _usersStream ;
 Future<QuerySnapshot<Map<String, dynamic>>>? _futureSnapshot;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMyUid();
    myNLieubor();
    _usersStream = getdata();
    _futureSnapshot = _getDocs();
    print('data '+ _usersStream.toString());


}


 getdata (){
  return FirebaseFirestore.instance.collection("users")
      .doc(myUid)
      .collection("cercle")
      .doc(widget.CercleUid)
      .collection('lieux').snapshots(includeMetadataChanges: true);
}


@override
  Widget build(BuildContext context) {
    //_getMyUid();
    myNLieubor();
  _usersStream = getdata ();
  // print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa${_usersStream.first.toString()}");
  //
  // CollectionReference users = FirebaseFirestore.instance.collection("users")
  //     .doc(myUid)
  //     .collection("cercle")
  //     .doc(widget.CercleUid)
  //     .collection('lieux');
  //
    _futureSnapshot = _getDocs();

    if(widget.CercleUid != null){
      _usersStream = getdata ();
      return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(backgroundColor: Colors.white,
                  elevation:1
              ),

          // body: FutureBuilder<DocumentSnapshot>(
          //   future: users.doc(documentId).get(),
          //   builder:
          //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          //
          //     if (snapshot.hasError) {
          //       return Text("Something went wrong");
          //     }
          //
          //     if (snapshot.hasData && !snapshot.data!.exists) {
          //       return Text("Document does not exist");
          //     }
          //
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          //       return Text("Full Name: ${data['full_name']} ${data['last_name']}");
          //     }
          //
          //     return Text("loading");
          //   },
          // ),

      // body: _buildDocs()
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("cercle")
              .doc(widget.CercleUid)
              .get(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.data!['myLieuUser'].length == 0) {
              print("snapshot.data!['myLieuUser'].sizesnapshot.data!['myLieuUser'].sizesnapshot.data!['myLieuUser'].sizesnapshot.data!['myLieuUser'].size");
              print(snapshot.data!['myLieuUser'].size);

              return Center(child: Text("Ajouter un Lieu"));
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.hasData){
              ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              // print("snapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshot");
              // print(snapshot.data!['myListUser'].length);
              return ListView.separated(
                itemCount: snapshot.data!['myListUser'].length,
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      snapshot.data?['myLieuUser'][index]['userName'],
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(snapshot.data?['myLieuUser'][index]['uid'],
                        style: TextStyle(
                          fontSize: 12,
                        )),
                  );
                },
              );
              // }
            }else if (snapshot.hasError){
              Text('no data');
            }else if (snapshot.data!['myLieuUser'].size == 0) {
              return Center(child: Text("Ajouter un lieu"));
            }

            return CircularProgressIndicator();
          },
        ),
          );
    }else{
      print("RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
      print(widget.CercleUid);

      return Scaffold(
          appBar: AppBar(backgroundColor: Colors.white,
              centerTitle: true,
              title: Text("Lieux"),

              elevation:1
          ),

          body: Center(child: Text("Choisir une cercle"),));
    }
  }

  _getMyUid() async {
    final prefs = await SharedPreferences.getInstance();
    myUid = prefs.getString('myUid');
    CercleUid = prefs.getString('CercleUid');

  }
_getMyCercleUid() async {
  final prefs = await SharedPreferences.getInstance();

  CercleUid = prefs.getString('CercleUid');

}
Future<void> _getAddressFromLatLng( double  lati,double  longi) async {
  await placemarkFromCoordinates(
      lati, longi)
      .then((List<Placemark> placemarks) {

    Placemark place = placemarks[0];

    setState(() {
      _currentAddress =
      '${place.street},${place.subLocality}, ${place.postalCode}';

    });
  }).catchError((e) {
    debugPrint(e);
  });
}


//
myNLieubor()  {
   FirebaseFirestore.instance.collection("users")
      .doc(myUid)
      .collection("cercle")
      .doc(widget.CercleUid)
      .collection('lieux').get().then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) async {
      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
      print(data);
      print(doc.data()!);
      dataList!.add(doc.data()!);

      print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
      print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");

      print(dataList);
      // data!.addEntries(doc['lat']);
      // data!['lat'] = doc['lat'];
      // data!['long'] = doc['long'];
      // data!['userName'] = doc['userName'];
      // data!['placeName'] = doc['placeName'];
      // data!['type'] = doc['type'];
    });
  });
}
  Future<QuerySnapshot<Map<String, dynamic>>> _getDocs() async {

    return await   FirebaseFirestore.instance.collection("users")
        .doc(myUid)
        .collection("cercle")
        .doc(widget.CercleUid)
        .collection('lieux').get();
  }
  Widget _buildDocs() {
    return FutureBuilder<QuerySnapshot>(
      future: _futureSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          final docs = snapshot.data?.docs;
          print("ddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd$docs");
          return Expanded(
            child: ListView(
              children: docs!.map((DocumentSnapshot doc) {
                final data = doc.data() as Map?;
                return Text(
                  '${data!['placeName']}  ',
                  textAlign: TextAlign.center,
                );
              }).toList(),
            ),
          );
        }

        return const CircularProgressIndicator();
      },
    );
  }

}
