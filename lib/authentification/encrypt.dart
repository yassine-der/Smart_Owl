import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class EncryptData{
//for AES Algorithms


  static Encrypted? encrypted;
  static var decrypted;


  static Encrypted? encryptAES(plainText){
    final keyz = Key.fromUtf8('my32lengthsupermo5ekknoones3ibe1');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(keyz));
    encrypted = encrypter.encrypt(plainText, iv: iv);
    print(encrypted!.base64);
    return encrypted;
  }

  static decryptAES(plainText){
    final keyz = Key.fromUtf8('my32lengthsupermo5ekknoones3ibe1');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(keyz));
    decrypted = encrypter.decrypt(plainText, iv: iv);




  //      final keyz = Key.fromUtf8('my32lengthsupermo5ekknoones3ibe1');
    //     final iv = IV.fromLength(16);
    //     final encrypter = Encrypter(AES(keyz));
    //     decrypted = encrypter.decrypt(cipher!, iv: iv);
    //     print("decrypteddecrypteddecrypteddecrypteddecrypteddecrypteddecrypteddecrypteddecrypted");
    //     print(decrypted);
    //     return decrypted;
  }

}
//                overflow: TextOverflow.ellipsis,