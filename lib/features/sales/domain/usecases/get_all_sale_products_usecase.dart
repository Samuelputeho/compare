import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/sales/domain/entity/sale_products_entity.dart';
import 'package:compareitr/features/sales/domain/repository/sale_product_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllSaleProductsUsecase
    implements UseCase<List<SaleProductsEntity>, NoParams> {
  final SaleProductRepository saleProductRepository;

  const GetAllSaleProductsUsecase(this.saleProductRepository);

  @override
  Future<Either<Failure, List<SaleProductsEntity>>> call(
      NoParams params) async {
    return await saleProductRepository.getSaleProducts();
  }
}
