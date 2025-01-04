import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LogoutUsecase {
  final AuthRepository authRepository;

  const LogoutUsecase(this.authRepository);

  Future<Either<Failure, void>> call() async {
    return await authRepository.logout();
  }
}
