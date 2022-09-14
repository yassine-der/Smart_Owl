import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../halper/buttonHelp.dart';

class UserList extends StatefulWidget {
  final String myUid;
  final String CercleUid;

  const UserList(
      { Key? key, required this.myUid, required this.CercleUid})
      : super(key: key);

  // String? myUid;
  // String? CercleUid;

  @override
  _UserListState createState() => _UserListState();

}

class _UserListState extends State<UserList> {


  @override
  Widget build(BuildContext context) {

    if (widget.CercleUid != "None" && widget.CercleUid != "None") {
      final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
          .collection("users")
          .doc(widget.myUid)
          .collection("cercle")
          .doc(widget.CercleUid)
          .collection('usersCercle')
          .snapshots(includeMetadataChanges: true);
      final size = MediaQuery
          .of(context)
          .size;

      return Material(
        child: Scaffold(
          // backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text("Personnes ",style: TextStyle(fontSize: 16),),
              elevation: 1),
          body: Column(
            children: [
              SizedBox(
              height: size.height*0.76,
                  child:FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection("cercle")
                        .doc(widget.CercleUid)
                        .get(),
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.data!['myListUser'].length == 1  && snapshot.data?['ownerUid'] == widget.myUid) {
                        return Center(child: Text("Ajouter un person"));
                      }
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if(snapshot.hasData){
                          return ListView.separated(
                            itemCount: snapshot.data!['myListUser'].length,
                            separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(
                                  snapshot.data?['myListUser'][index]['userName'],
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                subtitle: Text(snapshot.data?['myListUser'][index]['uid'],
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                              );
                            },
                          );
                        // }
                      }else if (snapshot.hasError){
                        Text('no data');
                      }else if (snapshot.data!['myListUser'].size == 0) {
                    return Center(child: Text("Ajouter un person"));
                  }

                      return CircularProgressIndicator();
                    },
                  ),
              )
//                StreamBuilder<QuerySnapshot>(
//                 stream: _usersStream,
//                 builder:
//                     (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.hasError) {
//                     return Text('Something went wrong');
//                   }
//
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Text("Loading");
//                   }
//                   if (snapshot.data!.size == 0) {
//                     return Center(child: Text("Ajouter un person"));
//                   }
//                   print(snapshot.data!.size);
//                   return ListView.separated(
//                     itemCount: snapshot.data!.size,
//                     separatorBuilder: (BuildContext context, int index) =>
//                     const Divider(),
//                     itemBuilder: (BuildContext context, int index) {
//                       // final titre= snapshot.data[];  // for example
// //Text(snapshot.data?.docs[index!]['placeName']
//
//                       return ListTile(
//                         // trailing: Icon(Icons.keyboard_arrow_right_rounded),
//                         // leading: CircleAvatar(
//                         //   radius: 20.0,
//                         //   backgroundColor: Colors.transparent,
//                         //   child: Image(
//                         //     image: AssetImage(snapshot.data?.docs[index]['type']),
//                         //   ),
//                         // ),
//                         title: Text(
//                           snapshot.data?.docs[index]['userName'],
//                           style: TextStyle(
//                             fontSize: 14,
//                           ),
//                         ),
//                         subtitle: Text(snapshot.data?.docs[index]['uid'],
//                             style: TextStyle(
//                               fontSize: 12,
//                             )),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),

              //  Padding(
              //   padding: const EdgeInsets.only(top: 10),
              //   child: SizedBox(
              //     height: 46,
              //
              //     child: Padding(
              //       padding: const EdgeInsets.only(right: 21,left: 21),
              //       child: ElevatedButton(
              //
              //           onPressed: (){
              //
              //           }
              //           , child: Row(mainAxisAlignment: MainAxisAlignment.center,
              //           children: [Icon(Icons.add,color: Colors.white, ),Text('AJOUTER UN NOUVEAU MEMBRE',style: TextStyle(color: Colors.white ,fontSize: 15),)]),
              //           style: ButtonStyle(
              //               backgroundColor: MaterialStateProperty.all( Color(0xff57CC2E)),
              //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //                   RoundedRectangleBorder(
              //                       borderRadius: BorderRadius.circular(8.0),
              //
              //                   )
              //               )
              //           )
              //
              //       ),
              //     ),
              //   ),
              // )
            ]
          ),
        ),
      );
    } else {
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

  // FirebaseFirestore.instance
  //     .collection("users")
  //     .doc(widget.myUid)
  //     .collection("cercle")
  //     .doc(widget.CercleUid).snapshots().listen(
  // (event) => print("current dataeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee: ${event.data()!["myListUser"][1]}"),
  // onError: (error) => print("Listen failed: $error"),
  // );

  Future<DocumentSnapshot<Map<String, dynamic>>> getEmail() async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.myUid)
        .collection("cercle")
        .doc(widget.CercleUid)
        .get();
  }

  // Future<String> getEmail() async {
  //   // String _email = (await FirebaseAuth.instance.currentUser()).email;
  //   var a = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(widget.myUid)
  //       .collection("cercle")
  //       .doc(widget.CercleUid).snapshots();
  //   return a.documents[0]['email'];
  // }

}