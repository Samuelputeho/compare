import 'package:compareitr/core/error/exceptions.dart';
import 'package:compareitr/core/error/failures.dart';
import 'package:compareitr/features/sales/data/datasources/sale_card_remote_data_source.dart';
import 'package:compareitr/features/sales/domain/entity/sale_card_entity.dart';
import 'package:compareitr/features/sales/domain/repository/sale_card_repository.dart';
import 'package:fpdart/src/either.dart';

class SaleCardRepositoryImpl implements SaleCardRepository {
  final SaleCardRemoteDataSource remoteDataSource;

  SaleCardRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, List<SaleCardEntity>>> getSaleCard() async {
    try {
      final saleModels = await remoteDataSource.getSaleCard();

      // Convert RecentModel list to CartEntity list.
      final saleEntities = saleModels.map((model) {
        return SaleCardEntity(
          storeName: model.storeName,
          image: model.image,
          startDate: model.startDate,
          endDate: model.endDate,
        );
      }).toList();

      return right(saleEntities);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure('Unexpected error: $e'));
    }
  }
}
