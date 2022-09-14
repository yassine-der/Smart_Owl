package com.example.smart_owl

import io.flutter.embedding.android.FlutterActivity
import com.google.firebase.FirebaseApp
import com.google.firebase.appcheck.FirebaseAppCheck
//import com.google.firebase.appcheck.debug.DebugAppCheckProviderFactory
import com.google.firebase.appcheck.safetynet.SafetyNetAppCheckProviderFactory

import android.os.Bundle

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FirebaseApp.initializeApp( this)
        val firebaseAppCheck = FirebaseAppCheck.getInstance()
//        firebaseAppCheck.installAppCheckProviderFactory(
//            DebugAppCheckProviderFactory.getInstance())
    }

}
