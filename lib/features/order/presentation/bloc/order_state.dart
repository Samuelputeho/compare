part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderLoaded extends OrderState {
  final OrderEntity order;

  const OrderLoaded({required this.order});

  @override
  List<Object> get props => [order];
}

final class OrderListLoaded extends OrderState {
  final List<OrderEntity> orders;

  const OrderListLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}

final class OrderCreating extends OrderState {}

final class OrderCreated extends OrderState {
  final OrderEntity order;

  const OrderCreated({required this.order});

  @override
  List<Object> get props => [order];
}

final class OrderError extends OrderState {
  final String message;

  const OrderError({required this.message});

  @override
  List<Object> get props => [message];
}
