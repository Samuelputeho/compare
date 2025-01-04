import 'package:compareitr/core/common/models/recently_viewed_model.dart';
import 'package:hive/hive.dart';

abstract class RecentlyViewedLocalDataSource {
  void uploadLocalRecent({required List<RecentlyViewedModel> recent});
  List<RecentlyViewedModel> loadRecent();
}

class RecentlyViewedLocalDataSourceImpl implements RecentlyViewedLocalDataSource {
  final Box box;

  RecentlyViewedLocalDataSourceImpl(this.box);

  @override
  List<RecentlyViewedModel> loadRecent() {
    List<RecentlyViewedModel> recentItems = [];
    for (int i = 0; i < box.length; i++) {
      final recentItem = box.get('recent_$i'); // Use the correct key name
      if (recentItem != null && recentItem is Map<String, dynamic>) {
        recentItems.add(RecentlyViewedModel.fromJson(recentItem));
      }
    }
    print('Loaded recently viewed items from local storage: $recentItems');
    return recentItems;
  }

  @override
  void uploadLocalRecent({required List<RecentlyViewedModel> recent}) {
    print('Uploading recently viewed items to local storage: $recent');
    Map<String, dynamic> recentData = {};
    for (int i = 0; i < recent.length; i++) {
      recentData['recent_$i'] = {
        'id': recent[i].id,
        'name': recent[i].name,
        'image': recent[i].image,
        'measure': recent[i].measure,
        'shopName': recent[i].shopName,
        'recentId': recent[i].recentId,
        'price': recent[i].price,
      };
    }
    box.putAll(recentData); // Batch write
    print('Recently viewed items uploaded to local storage');
  }
}
