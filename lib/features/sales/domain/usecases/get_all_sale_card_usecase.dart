import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/features/sales/domain/entity/sale_card_entity.dart';
import 'package:compareitr/features/sales/domain/repository/sale_card_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetSaleCardAllUsecase implements UseCase<List<SaleCardEntity>, NoParams> {
  final SaleCardRepository saleRepository;

  const GetSaleCardAllUsecase(this.saleRepository);

  @override
  Future<Either<Failure, List<SaleCardEntity>>> call(NoParams params) async {
    return await saleRepository.getSaleCard();
  }
}
