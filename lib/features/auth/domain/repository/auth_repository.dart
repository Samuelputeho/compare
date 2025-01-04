import 'dart:io';

import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/common/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, UserEntity>> signUpWithEmailPassword({
    required String name,
    required String street,
    required String location,
    required int phoneNumber,
    required String email,
    required String password,
  });
  Future<Either<Failure, UserEntity>> logInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> currentUser();
  Future<Either<Failure, void>> logout();

  // New method to update user profile
  Future<Either<Failure, void>> updateUserProfile({
    required String userId,
    required String name,
    required String email,
    required String street,
    required String location,
    required int phoneNumber,
    required File imagePath,
  });
}
