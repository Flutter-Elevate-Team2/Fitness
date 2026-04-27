import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// coverage:ignore-file

class AuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
    //  print("Google error: $e");
      return null;
    }
  }

  static Future<UserCredential?> signInWithFacebook()async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
         final AccessToken accessToken = result.accessToken!;

        final OAuthCredential credential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );

        return await _auth.signInWithCredential(credential);
      } else {

        throw Exception("Facebook login failed: ${result.message}");

      }
    } catch (e) {
       return null;
    }
  }
}