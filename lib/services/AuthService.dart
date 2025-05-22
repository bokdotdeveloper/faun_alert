import 'package:firebase_auth/firebase_auth.dart';


class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance; 

Future deleteUser(String email, String password) async {
  // try{
  //   FirebaseUser user = _auth.currentUser!;
  // }catch(e){
  //   print('Error deleting user: $e');
  // }
}
}