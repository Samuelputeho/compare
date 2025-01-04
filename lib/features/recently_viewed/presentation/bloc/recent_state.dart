part of 'recent_bloc.dart';

@immutable
sealed class RecentState {}

final class RecentInitial extends RecentState {}

final class RecentLoading extends RecentState {}

final class RecentLoaded extends RecentState {
  final List<RecentlyViewedEntity> recentItems;

  RecentLoaded({required this.recentItems});
}

final class RecentError extends RecentState {
  final String message;

  RecentError({required this.message});
}
