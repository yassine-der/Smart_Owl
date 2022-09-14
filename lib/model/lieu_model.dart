class Lieu{
  // String? uid;
  String? placeName;
  String? lat;
  String? long;
  String? userName;
  String? type;
  String? cercleCode;


  Lieu({ this.placeName,this.lat, this.long, this.userName, this.type, this.cercleCode, });

  // receiving data from server
  factory Lieu.fromMap(map) {
    return Lieu(
      // uid: map['uid'],
      lat: map['lat'],
      placeName: map['placeName'],

      long: map['long'],
      userName: map['userName'],
      type: map['type'],
      cercleCode: map['cercleCode'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      // 'uid': uid,
      'placeName': placeName,
      'lat': lat,
      'long': long,
      'userName': userName,
      'type': type,
      'cercleCode': cercleCode,
    };
  }

}
