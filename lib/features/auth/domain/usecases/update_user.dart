import 'dart:io';

import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateUserProfile implements UseCase<void, UpdateUserProfileParams> {
  final AuthRepository authRepository;
  const UpdateUserProfile(this.authRepository);

  @override
  Future<Either<Failure, void>> call(UpdateUserProfileParams params) async {
    return await authRepository.updateUserProfile(
      userId: params.userId,
      name: params.name,
      email: params.email,
      street: params.street,
      location: params.location,
      phoneNumber: params.phoneNumber,
      imagePath: params.imagePath,
    );
  }
}

class UpdateUserProfileParams {
  final String userId;
  final String name;
  final String email;
  final String street;
  final String location;
  final int phoneNumber;
  final File imagePath;

  UpdateUserProfileParams({
    required this.userId,
    required this.name,
    required this.email,
    required this.street,
    required this.location,
    required this.phoneNumber,
    required this.imagePath,
  });
}
