import 'dart:io';

import 'package:compareitr/core/error/exceptions.dart';
import 'package:compareitr/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String street,
    required String location,
    required int phoneNumber,
    required String email,
    required String password,
  });

  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
  Future<void> logout();

  Future<void> updateUserProfile({
    required String userId,
    required String email,
    required String name,
    required String street,
    required String location,
    required int phoneNumber,
    required File imagePath, // Path to the local image file
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  AuthRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<UserModel> logInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw ServerException("User is null!");
      }
      return UserModel.fromJson(
        response.user!.toJson(),
      );
    } catch (e) {
      throw ServerException(
        e.toString(),
      );
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String street,
    required String location,
    required String email,
    required String password,
    required int phoneNumber,
  }) async {
    try {
      final response = await supabaseClient.auth
          .signUp(password: password, email: email, data: {
        'name': name,
        'email': email,
        'street': street,
        'location': location,
        'phoneNumber': phoneNumber,
      });
      if (response.user == null) {
        throw ServerException("User is null!");
      }
      return UserModel.fromJson(
        response.user!.toJson(),
      );
    } catch (e) {
      throw ServerException(
        e.toString(),
      );
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }

      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    required String name,
    required String email,
    required String street,
    required String location,
    required int phoneNumber,
    required File imagePath,
  }) async {
    try {
      // 1. Upload image to bucket
      final fileName = "${DateTime.now().millisecondsSinceEpoch}_$userId.jpg";
      final storageResponse = await supabaseClient.storage
          .from('profile-pictures') // Replace with your bucket name
          .upload(fileName, imagePath);

      if (storageResponse.isEmpty) {
        throw ServerException("Image upload failed.");
      }
      // 2. Get public URL for the uploaded image
      final publicURL = supabaseClient.storage
          .from('profile-pictures')
          .getPublicUrl(fileName);

      if (publicURL == null || publicURL.isEmpty) {
        throw ServerException("Failed to retrieve public URL for image.");
      }

      // 3. Update user's profile in the database
      final updateResponse = await supabaseClient.from('profiles').update({
        'name': name,
        'street': street,
        'location': location,
        'email': email,
        'phoneNumber': phoneNumber,
        'proPic': publicURL,
      }).eq('id', userId);

      if (updateResponse.error != null) {
        throw ServerException(
            "Failed to update profile: ${updateResponse.error!.message}");
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
