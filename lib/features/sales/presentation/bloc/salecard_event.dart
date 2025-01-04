part of 'salecard_bloc.dart';

@immutable
sealed class SalecardEvent {}

final class GetAllSaleCardEvent extends SalecardEvent {}
