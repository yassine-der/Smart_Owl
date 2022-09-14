import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInformation extends StatefulWidget {
  final String myUid;
  final String CercleUid;

  const UserInformation(
      { Key? key, required this.myUid, required this.CercleUid})
      : super(key: key);

  // String? myUid;
  // String? CercleUid;

  @override
  _UserInformationState createState() => _UserInformationState();

}

class _UserInformationState extends State<UserInformation> {


  @override
  Widget build(BuildContext context) {

    if (widget.CercleUid != "None" && widget.CercleUid != null) {
      final size = MediaQuery
          .of(context)
          .size;

      return Material(
        child: Scaffold(
          // backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text("Lieux"),
              elevation: 1),

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
                // print("snapshot.data!['myLieuUser'].sizesnapshot.data!['myLieuUser'].sizesnapshot.data!['myLieuUser'].sizesnapshot.data!['myLieuUser'].size");
                // print(snapshot.data!['myLieuUser'].size);

                return Center(child: Text("Ajouter un Lieu"));
              }
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(snapshot.hasData ){
                print("snapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotot");
                print(snapshot.data!['myLieuUser'].length);
                print(snapshot.data?['myLieuUser'][0]['placeName']);
                // print("snapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshotsnapshot");
                // print(snapshot.data!['myListUser'].length);
                return ListView.separated(
                  itemCount: snapshot.data!['myLieuUser'].length,
                  separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 16.0,
                        child: ClipRRect(
                          child: Image.asset(snapshot.data?['myLieuUser'][index]['type']),
                          borderRadius: BorderRadius.circular(50.0),
                        ),

                      ),

                      title: Text(
                        snapshot.data?['myLieuUser'][index]['placeName'],
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(snapshot.data?['myLieuUser'][index]['placeName'],
                          style: TextStyle(
                            fontSize: 12,
                          )),
                    );
                  },
                );
                // }
              }else if (snapshot.hasError){
                return CircularProgressIndicator();
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      );
    }
    else {
      return Material(
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text("Lieux"),
              elevation: 1),
          body: Center(child: Text("Ajouter un lieu"),),

        ),
      );
    }
  }
}