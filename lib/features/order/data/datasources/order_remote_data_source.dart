import 'package:compareitr/features/order/data/models/order_model.dart';
import 'package:compareitr/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class OrderRemoteDataSource {
  Future<OrderModel> createOrder({
    required String userId,
    required List<OrderItemModel> items,
    required double subtotal,
    required double deliveryFee,
    required double totalAmount,
    required DateTime orderDate,
    required String deliveryAddress,
    required String orderStatus,
  });

  Future<OrderModel> getOrderById(String orderId);
  Future<List<OrderModel>> getOrdersByUserId(String userId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final SupabaseClient supabaseClient;

  OrderRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<OrderModel> createOrder({
    required String userId,
    required List<OrderItemModel> items,
    required double subtotal,
    required double deliveryFee,
    required double totalAmount,
    required DateTime orderDate,
    required String deliveryAddress,
    required String orderStatus,
  }) async {
    try {
      final order = OrderModel(
        orderId: '', // Supabase will generate this automatically
        userId: userId,
        items: items,
        subtotal: subtotal,
        deliveryFee: deliveryFee,
        totalAmount: totalAmount,
        orderDate: orderDate,
        deliveryAddress: deliveryAddress,
        orderStatus: orderStatus,
      );

      final response = await supabaseClient.from('orders').insert(order.toJson()).single();

      if (response == null) {
        throw ServerException('Failed to create order: Unknown error');
      }

      return OrderModel.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      throw ServerException('Failed to create order: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final response = await supabaseClient.from('orders').select().eq('orderId', orderId).single();

      if (response == null) {
        throw ServerException('Failed to fetch order: Unknown error');
      }

      return OrderModel.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      throw ServerException('Failed to fetch order: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<List<OrderModel>> getOrdersByUserId(String userId) async {
    try {
      final List<dynamic> response = await supabaseClient.from('orders').select().eq('userId', userId);

      return response.map((item) => OrderModel.fromJson(item as Map<String, dynamic>)).toList();
    } on PostgrestException catch (e) {
      throw ServerException('Failed to fetch orders: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}
