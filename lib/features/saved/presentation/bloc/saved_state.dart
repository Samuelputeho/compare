part of 'saved_bloc.dart';

@immutable
sealed class SavedState {}

final class SavedInitial extends SavedState {}

final class SavedLoading extends SavedState {}

final class SavedLoaded extends SavedState {
  final List<SavedEntity> savedItems;

  SavedLoaded({required this.savedItems});
}

final class SavedError extends SavedState {
  final String message;

  SavedError({required this.message});
}
