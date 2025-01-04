import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/features/sales/domain/entity/sale_card_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SaleCardRepository {
  Future<Either<Failure, List<SaleCardEntity>>> getSaleCard();
}
