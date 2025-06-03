import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthFunctions {
  // Firebase Authentication örneği oluşturma.
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // E-posta ve şifre ile giriş fonksiyonu.
  static Future<UserCredential?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  // Google ile giriş fonksiyonu.
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      // Google hesabı seçilmesini sağlar.
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Kullanıcı giriş yapmazsa null döner.
      if (googleUser == null) return null;

      // Kimlik doğrulama bilgileri alınır.
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Google kimlik bilgileriyle bir Firebase kimlik bilgisi oluşturulur.
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase'e kimlik bilgileriyle giriş yapılır.
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw e;
    }
  }
}
