import 'package:compareitr/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/shop_entity.dart';
import '../../../../core/error/failures.dart';
import '../repository/repo.dart';

class GetAllShopsUsecase implements UseCase<List<ShopEntity>, NoParams> {
  final ShopsRepository repository;

  GetAllShopsUsecase(this.repository);

  @override
  Future<Either<Failure, List<ShopEntity>>> call(NoParams params) async {
    return repository.getAllShops();
  }
}
