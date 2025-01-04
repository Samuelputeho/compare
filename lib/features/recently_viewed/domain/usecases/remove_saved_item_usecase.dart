import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/saved/domain/repository/saved_repository.dart';
import 'package:fpdart/fpdart.dart';

class RemoveSavedItemUsecase implements UseCase<void, RemoveSavedItemParams> {
  final SavedRepository savedRepository;

  const RemoveSavedItemUsecase(this.savedRepository);

  @override
  Future<Either<Failure, void>> call(RemoveSavedItemParams params) async {
    return await savedRepository.removeSavedItem(params.id);
  }
}

class RemoveSavedItemParams {
  final String id;

  RemoveSavedItemParams({required this.id});
}
