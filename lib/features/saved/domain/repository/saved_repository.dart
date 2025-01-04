import 'package:compareitr/core/common/entities/saved_entity.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SavedRepository {
  Future<Either<Failure, SavedEntity>> addSavedItem({
    required String name,
    required String image,
    required String measure,
    required String shopName,
    required String savedId,
    required double price,
  });
  Future<Either<Failure, void>> removeSavedItem(String id);
  Future<Either<Failure, List<SavedEntity>>> getSavedItems(String savedId);
}
