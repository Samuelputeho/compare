import 'package:compareitr/core/common/entities/category_entity.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../repository/repo.dart';

class GetCategoriesUsecase implements UseCase<List<CategoryEntity>, NoParams> {
  final ShopsRepository repository;

  GetCategoriesUsecase(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) async {
    return repository.getAllCategories();
  }
}
