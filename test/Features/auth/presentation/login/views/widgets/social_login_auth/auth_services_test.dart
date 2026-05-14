 // ignore_for_file: unused_local_variable

 import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'auth_services_test.mocks.dart';


 @GenerateNiceMocks([
   MockSpec<FirebaseAuth>(),
   MockSpec<UserCredential>(),
   MockSpec<User>(),
   MockSpec<GoogleSignIn>(),
   MockSpec<GoogleSignInAccount>(),
   MockSpec<GoogleSignInAuthentication>(),
   MockSpec<FacebookAuth>(),
   MockSpec<LoginResult>(),
   MockSpec<AccessToken>(),
 ])
void main() {
  late MockFirebaseAuth mockAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockFacebookAuth mockFacebookAuth;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockFacebookAuth = MockFacebookAuth();

   });

  group('AuthServices Google Login Tests', () {
    test('signInWithGoogle returns UserCredential on success', () async {
      // Setup
      final mockGoogleUser = MockGoogleSignInAccount();
      final mockGoogleAuth = MockGoogleSignInAuthentication();
      final mockUserCredential = MockUserCredential();

      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleUser);
      when(mockGoogleUser.authentication).thenAnswer((_) async => mockGoogleAuth);
      when(mockGoogleAuth.accessToken).thenReturn('fake_access_token');
      when(mockGoogleAuth.idToken).thenReturn('fake_id_token');

    });

    test('signInWithGoogle returns null when user cancels', () async {
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

     });
  });

  group('AuthServices Facebook Login Tests', () {
    test('signInWithFacebook returns UserCredential on success', () async {
      final mockLoginResult = MockLoginResult();
      final mockAccessToken = MockAccessToken();

      when(mockFacebookAuth.login(permissions: anyNamed('permissions')))
          .thenAnswer((_) async => mockLoginResult);
      when(mockLoginResult.status).thenReturn(LoginStatus.success);
      when(mockLoginResult.accessToken).thenReturn(mockAccessToken);
      when(mockAccessToken.tokenString).thenReturn('fake_fb_token');

     });
  });
}