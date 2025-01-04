part of 'saved_bloc.dart';

@immutable
sealed class SavedEvent {}

final class AddSavedItem extends SavedEvent {
  final String name;
  final String image;
  final String measure;
  final String shopName;
  final String savedId;
  final double price;

  AddSavedItem({
    required this.name,
    required this.image,
    required this.measure,
    required this.shopName,
    required this.savedId,
    required this.price,
  });
}

class RemoveSavedItem extends SavedEvent {
  final String id; // ID of the item to delete
  final String savedId; // ID of the user/group

  RemoveSavedItem({required this.id, required this.savedId});
}

final class GetSavedItems extends SavedEvent {
  final String savedId;

  GetSavedItems({required this.savedId});
}
