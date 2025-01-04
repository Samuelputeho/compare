part of 'recent_bloc.dart';

@immutable
sealed class RecentEvent {}

final class AddRecentItem extends RecentEvent {
  final String name;
  final String image;
  final String measure;
  final String shopName;
  final String recentId;
  final double price;

  AddRecentItem({
    required this.name,
    required this.image,
    required this.measure,
    required this.shopName,
    required this.recentId,
    required this.price,
  });
}

final class RemoveRecentlyItem extends RecentEvent {
  final String recentId;
  final String id;

  RemoveRecentlyItem({required this.recentId,required this.id});
}

final class GetRecentItems extends RecentEvent {
  final String recentId;

  GetRecentItems({required this.recentId});
}

// Add a new event to check if the product exists in the recent list


class CheckIfProductExists extends RecentEvent {
  final String name;
  final String shopName;
  final String measure;
  final String recentId;

  CheckIfProductExists({
    required this.name,
    required this.shopName,
    required this.measure,
    required this.recentId,
  });
}

