import 'package:firebase_auth/firebase_auth.dart';
import 'package:frooyd/model/user.dart';

class AuthService {
  String name;
  String email;
  String username;
  String userID;

  // User _currentUser;
  // User get currentUser => _currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  Future<bool> isUserLoggedIn() async {
    var user = await _auth.currentUser();
    return user != null;
  }

  //register with e mail /password

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final FirebaseUser user = result.user;

      assert(user != null);
      assert(await user.getIdToken() != null);

      return user;
    } catch (e) {
      print(e);
    }
  }

  //sign in with e mail /password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      //firebaseUser = await _auth.currentUser();
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  returnID() async {
    FirebaseUser user = await _auth.currentUser();
    userID = user.uid;
    return userID;
    //userID=userID.toString();
  }
}
