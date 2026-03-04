import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Obter usuário atual
  User? get currentUser => _auth.currentUser;

  // Stream para monitorar estado da autenticação
  Stream<User?> get userStream => _auth.authStateChanges();

  // Login com Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut(); 
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        await _saveUserToDatabase(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      print("Erro no Google Sign-In: $e");
      return null;
    }
  }

  // Função para salvar dados no Realtime Database
  Future<void> _saveUserToDatabase(User user) async {
    try {
      final DatabaseReference userRef = _database.ref('users/${user.uid}');
      await userRef.update({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'lastLogin': ServerValue.timestamp,
      });
    } catch (e) {
      print("Erro ao salvar no Realtime Database: $e");
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
