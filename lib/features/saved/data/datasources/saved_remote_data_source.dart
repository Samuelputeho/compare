import 'package:compareitr/core/common/models/saved_model.dart';
import 'package:compareitr/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class SavedRemoteDataSource {
  Future<void> addSavedItem({
    required String name,
    required String image,
    required String measure,
    required String shopName,
    required String savedId,
    required double price,
  });
  Future<void> removeSavedItem(String id);
  Future<List<SavedModel>> getSavedItems(String savedId);
}

class SavedRemoteDataSourceImpl implements SavedRemoteDataSource {
  final SupabaseClient supabaseClient;

  SavedRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<void> addSavedItem({
    required String name,
    required String image,
    required String measure,
    required String shopName,
    required String savedId,
    required double price,
  }) async {
    try {
      final savedItem = SavedModel(
          name: name,
          image: image,
          measure: measure,
          shopName: shopName,
          savedId: savedId,
          price: price);

      await supabaseClient.from('saved').insert(savedItem.toJson());
    } on PostgrestException catch (e) {
      throw ServerException('Failed to add saved item: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> removeSavedItem(String id) async {
    try {
      // Delete the saved item by id
      await supabaseClient.from('saved').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerException('Failed to remove saved item: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<List<SavedModel>> getSavedItems(String savedId) async {
    try {
      final List<dynamic> response =
          await supabaseClient.from('saved').select().eq('savedId', savedId);
      // Print the raw response
      return response.map((item) => SavedModel.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      throw ServerException('Failed to fetch saved items: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}
