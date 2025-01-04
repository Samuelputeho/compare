import 'package:compareitr/core/common/entities/saved_entity.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/saved/domain/repository/saved_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetSavedItemsUsecase implements UseCase<List<SavedEntity>, String> {
  final SavedRepository savedRepository;

  const GetSavedItemsUsecase(this.savedRepository);

  @override
  Future<Either<Failure, List<SavedEntity>>> call(String savedId) async {
    return await savedRepository.getSavedItems(savedId);
  }
}
