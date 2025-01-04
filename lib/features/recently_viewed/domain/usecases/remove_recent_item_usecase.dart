import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/cart/domain/repository/cart_repository.dart';
import 'package:compareitr/features/recently_viewed/domain/repository/recent_repo.dart';
import 'package:fpdart/fpdart.dart';

class RemoveRecentItemUsecase implements UseCase<void, RemoveRecentItemParams> {
  final RecentRepository recentRepository;

  const RemoveRecentItemUsecase(this.recentRepository);

  @override
  Future<Either<Failure, void>> call(RemoveRecentItemParams params) async {
    return await recentRepository.removeRecentlyItem(params.id);
  }
}

class RemoveRecentItemParams {
  final String id;

  RemoveRecentItemParams({required this.id});
}
