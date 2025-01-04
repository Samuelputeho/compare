import 'package:compareitr/core/common/models/recently_viewed_model.dart';
import 'package:compareitr/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RecentlyViewedRemoteDataSource {
  Future<void> addRecentItem({
    required String name,
    required String image,
    required String measure,
    required String shopName,
    required String recentId,
    required double price,
  });

  Future<void> removeRecentlyItem(String id);

  Future<List<RecentlyViewedModel>> getRecentItems(String recentId);
}

class RecentlyViewedRemoteDataSourceImpl
    implements RecentlyViewedRemoteDataSource {
  final SupabaseClient supabaseClient;

  RecentlyViewedRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<void> addRecentItem({
    required String name,
    required String image,
    required String measure,
    required String shopName,
    required String recentId,
    required double price,
  }) async {
    try {
      final recentItem = RecentlyViewedModel(
          name: name,
          image: image,
          measure: measure,
          shopName: shopName,
          recentId: recentId,
          price: price);

      await supabaseClient.from('recent').insert(recentItem.toJson());
    } on PostgrestException catch (e) {
      throw ServerException('Failed to add recent item: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<void> removeRecentlyItem(String id) async {
    try {
      // Delete the recent item by id
      await supabaseClient.from('recent').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw ServerException('Failed to remove recent item: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  @override
  Future<List<RecentlyViewedModel>> getRecentItems(String recentId) async {
    try {
      // Fetch all recent items
      final List<dynamic> response =
          await supabaseClient.from('recent').select().eq('recentId', recentId);
      return response
          .map((item) => RecentlyViewedModel.fromJson(item))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException('Failed to fetch recent items: ${e.message}');
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }
}
