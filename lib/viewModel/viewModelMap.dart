import 'package:firebase_database/firebase_database.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class HomePageViewModel extends GetxController{


  late DatabaseReference dbRef ;



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    dbRef = FirebaseDatabase.instance.ref();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  createdb(double long,double lat){
    dbRef.child("yassine").set({
      "latitude": lat,
      "longitude": long
    });
  }
}