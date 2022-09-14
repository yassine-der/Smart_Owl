import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
   String? name;
   String? code;
   String? ownerUid;
   List<String>? myListUser = [];

  Room({this.name,this.code, this.ownerUid,this.myListUser});

  factory Room.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Room(
      name: data?['name'] ?? '',
      code: data?['code'] ?? '',
      ownerUid: data?['ownerUid'] ?? '',
      myListUser : data?[['myListUser']],
      // lieu: data?['lieu'] is Iterable ? List.from(data?['lieu']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
       "name": name,
       "code": code,
       "ownerUid": ownerUid,
      'myListUser': myListUser,

      // if (lieu != null) "lieu": lieu,
    };
  }
}