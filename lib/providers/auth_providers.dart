import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Method Providers
final registerUserProvider = Provider<Future<UserModel?> Function({
required String name,
required String email,
required String password,
required String role,
})>((ref) {
  final authService = ref.watch(authServiceProvider);
  return ({
    required String name,
    required String email,
    required String password,
    required String role,
  }) {
    return authService.registerUser(
      name: name,
      email: email,
      password: password,
      role: role,
    );
  };
});

final loginUserProvider = Provider((ref) {
  return ({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      // Fetch user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User record not found in Firestore.',
        );
      }

      // Convert Firestore data to UserModel
      return UserModel.fromMap(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      throw e; // rethrow to be handled in UI
    }
  };
});

final resetPasswordProvider = Provider<Future<void> Function(String email)>((ref) {
  final authService = ref.watch(authServiceProvider);
  return (email) => authService.sendPasswordResetEmail(email);
});
