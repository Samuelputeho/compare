import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/core/common/entities/user_entity.dart';
import 'package:compareitr/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<UserEntity, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);
  @override
  Future<Either<Failure, UserEntity>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      street: params.street,
      location: params.location,
      phoneNumber: params.phoneNumber,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;
  final String street;
  final String location;
  final int phoneNumber;
  UserSignUpParams(
      {required this.email,
      required this.password,
      required this.name,
      required this.street,
      required this.location,
      required this.phoneNumber,
      });
}
