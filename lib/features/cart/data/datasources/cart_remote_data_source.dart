import 'package:compareitr/core/common/models/cart_model.dart';
import 'package:compareitr/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CartRemoteDataSource {
  Future<void> addCartItem({
    required String cartId,
    required String itemName,
    required String shopName,
    required String imageUrl,
    required double price,
    required int quantity,
  });
  Future<void> removeCartItem(String productId);
  Future<List<CartModel>> getCartItems(String cartId);
  // New method to update the cart item's quantity
  Future<void> updateCartItem({
    required String cartId,
    required String productId,
    required int quantity,
  });
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final SupabaseClient supabaseClient;

  CartRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<void> addCartItem({
    required String cartId,
    required String itemName,
    required String shopName,
    required String imageUrl,
    required double price,
    required int quantity,
  }) async {
    try {
      // Create a CartModel instance from the parameters
      final cartItem = CartModel(
        cartId: cartId,
        itemName: itemName,
        shopName: shopName,
        imageUrl: imageUrl,
        price: price,
        quantity: quantity,
      );

      // Insert item into the cart table
      await supabaseClient.from('cart').insert(cartItem.toJson());
    } on PostgrestException catch (e) {
      throw ServerException('Failed to add cart item: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> removeCartItem(String id) async {
    try {
      // Delete the cart item by cartId
      await supabaseClient.from('cart').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerException('Failed to remove cart item: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<List<CartModel>> getCartItems(String cartId) async {
    try {
      // Fetch cart items for the specific user
      final List<dynamic> response = await supabaseClient
          .from('cart')
          .select()
          .eq('cartId', cartId); // Filter by user ID
      return response.map((item) => CartModel.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      throw ServerException('Failed to fetch cart items: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  // Update cart item quantity
  @override
  Future<void> updateCartItem({
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    try {
      final response = await supabaseClient
          .from('cart')
          .update({'quantity': quantity}) // Update quantity
          .eq('id', productId); // Use the product ID to identify the item

      if (response.error != null) {
        throw ServerException('Failed to update cart item: ${response.error!.message}');
      }
    } on PostgrestException catch (e) {
      throw ServerException('Failed to update cart item: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}
