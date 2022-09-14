import 'package:smart_owl/model/lieu_model.dart';

class UserModel{
  String? uid;
  String? userName;
  String? email;
  String? fileName;
  List<String>? ListCercles = []
  ;
  //List<Lieu>? lieux;



  UserModel({this.uid, this.email, this.userName, this.fileName,this.ListCercles});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      userName: map['userName'] ?? '',
      fileName: map['fileName'] ?? '',
      ListCercles : map[['ListCercles']] ,

      //lieux: map['lieux'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'fileName': fileName,
      'ListCercles': ListCercles,
    };
  }

}

/*
*   static UserModel fromJson( Map<String, dynamic> json) => UserModel(
  uid: json['uid'],
  email: json['email'],
  userName: json['userName'],

);
*/