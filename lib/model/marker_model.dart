class Marker_moodel {
  String userName;
  late double latitude;
  late double longitude;

  Marker_moodel(
      {required this.userName, required this.latitude, required this.longitude});

  Marker_moodel.fromJson(this.userName, Map data) {
    latitude = data['lat'];
    longitude = data['long'];
  }
}