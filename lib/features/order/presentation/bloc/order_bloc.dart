// Add the new use case
import 'package:compareitr/features/order/domain/usecases/create_order.dart';
import 'package:compareitr/features/order/domain/usecases/get_order_by_id.dart';
import 'package:compareitr/features/order/domain/usecases/get_user_order.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:compareitr/features/order/domain/entities/order_entity.dart';
part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrder _createOrderUsecase;
  final GetUserOrders _getUserOrdersUsecase;
  final GetOrderById _getOrderByIdUsecase;

  OrderBloc({
    required CreateOrder createOrderUsecase,
    required GetUserOrders getUserOrdersUsecase,
    required GetOrderById getOrderByIdUsecase,
  })  : _createOrderUsecase = createOrderUsecase,
        _getUserOrdersUsecase = getUserOrdersUsecase,
        _getOrderByIdUsecase = getOrderByIdUsecase,
        super(OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
    on<GetUserOrdersEvent>(_onGetUserOrders);
    on<GetOrderByIdEvent>(_onGetOrderById);
  }

  // Handle the CreateOrderEvent
  Future<void> _onCreateOrder(
      CreateOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading()); // Show loading before creating order
    final result = await _createOrderUsecase(CreateOrderParams(
      userId: event.userId,
      items: event.items,
      subtotal: event.subtotal,
      deliveryFee: event.deliveryFee,
      totalAmount: event.totalAmount,
      deliveryAddress: event.deliveryAddress,
    ));

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (order) {
        emit(OrderCreated(order: order)); // Emit created order state
      },
    );
  }

  // Handle the GetUserOrdersEvent
  Future<void> _onGetUserOrders(
      GetUserOrdersEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading()); // Show loading before fetching orders
    final result = await _getUserOrdersUsecase(event.userId);

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (orders) => emit(OrderListLoaded(orders: orders)), // Emit orders list state
    );
  }

  // Handle the GetOrderByIdEvent
  Future<void> _onGetOrderById(
      GetOrderByIdEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading()); // Show loading before fetching specific order
    final result = await _getOrderByIdUsecase(event.orderId);

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (order) => emit(OrderLoaded(order: order)), // Emit loaded order state
    );
  }
}
