import 'package:bb_application/screens/homescreen.dart';
import 'package:bb_application/screens/login.dart';
import 'package:bb_application/screens/navscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  try {
    await FirebaseFirestore.instance.clearPersistence();
    print("Firestore cache cleared.");
  } catch (e) {
    print("Error clearing Firestore cache: $e");
  }
 Widget startPage = await getStartScreen();
 
 bool isloggedin=await checkFirebaseAuthStatus();
await dotenv.load(fileName: ".env");

runApp(MyApp(startPage:startPage));
 


 
  }
    Future<Widget> getStartScreen() async {
  User? user = FirebaseAuth.instance.currentUser;
  
  if (user == null) {
    return login(); 
  }

  // Check if the user is an admin or a normal user
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isAdmin = prefs.getBool('isadmin') ?? false;

  return Navscreen(role: isAdmin ? "admin" : "user"); // Redirect accordingly
}

bool checkFirebaseAuthStatus() {
  User? user = FirebaseAuth.instance.currentUser;
  return user != null; // Returns true if a user is logged in
}

class MyApp extends StatelessWidget {
 
final Widget startPage;
const MyApp({Key? key, required this.startPage}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home:startPage,
    );
  }
}

