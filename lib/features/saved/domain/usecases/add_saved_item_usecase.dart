import 'package:compareitr/core/common/entities/saved_entity.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/saved/domain/repository/saved_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddSavedItemUsecase implements UseCase<SavedEntity, AddSavedItemParams> {
  final SavedRepository savedRepository;

  const AddSavedItemUsecase(this.savedRepository);

  @override
  Future<Either<Failure, SavedEntity>> call(AddSavedItemParams params) async {
    return await savedRepository.addSavedItem(
      name: params.name,
      image: params.image,
      measure: params.measure,
      shopName: params.shopName,
      savedId: params.savedId,
      price: params.price,
    );
  }
}

class AddSavedItemParams {
  final String name;
  final String image;
  final String measure;
  final String shopName;
  final String savedId;
  final double price;

  AddSavedItemParams({
    required this.name,
    required this.image,
    required this.measure,
    required this.shopName,
    required this.savedId,
    required this.price,
  });
}
