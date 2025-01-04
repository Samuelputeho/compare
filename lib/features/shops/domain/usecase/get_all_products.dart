import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/product_entity.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repository/repo.dart';

class GetAllProductsUseCase implements UseCase<List<ProductEntity>, NoParams> {
  final ShopsRepository repository;

  GetAllProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) async {
    return repository.getAllProducts();
  }
}
