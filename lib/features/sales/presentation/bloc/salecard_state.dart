part of 'salecard_bloc.dart';

@immutable
sealed class SalecardState {}

final class SalecardInitial extends SalecardState {}

final class SalecardLoading extends SalecardState {}

final class SalecardSuccess extends SalecardState {
  final List<SaleCardEntity> saleCard;

  SalecardSuccess({required this.saleCard});
}

final class SalecardFailure extends SalecardState {
  final String message;

  SalecardFailure({required this.message});
}
