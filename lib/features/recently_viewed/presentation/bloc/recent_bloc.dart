import 'package:compareitr/core/common/entities/recently_viewed_entity.dart';

import 'package:compareitr/features/recently_viewed/domain/usecases/add_recent_item_usecase.dart';
import 'package:compareitr/features/recently_viewed/domain/usecases/get_recent_items_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'recent_event.dart';
part 'recent_state.dart';

class RecentBloc extends Bloc<RecentEvent, RecentState> {
  final AddRecentItemUsecase _addRecentItemUsecase;

  final GetRecentItemsUsecase _getRecentItemsUsecase;

  RecentBloc({
    required AddRecentItemUsecase addRecentItemUsecase,
    required GetRecentItemsUsecase getRecentItemsUsecase,
  })  : _addRecentItemUsecase = addRecentItemUsecase,
        _getRecentItemsUsecase = getRecentItemsUsecase,
        super(RecentInitial()) {
    on<AddRecentItem>(_onAddRecentItem);
    on<GetRecentItems>(_onGetRecentItems);
    on<CheckIfProductExists>(_onCheckIfProductExists);
  }

  Future<void> _onAddRecentItem(
      AddRecentItem event, Emitter<RecentState> emit) async {
    emit(RecentLoading());
    final result = await _addRecentItemUsecase(
      AddRecentItemParams(
        name: event.name,
        image: event.image,
        measure: event.measure,
        shopName: event.shopName,
        recentId: event.recentId,
        price: event.price,
      ),
    );

    result.fold(
      (failure) => emit(RecentError(message: failure.message)),
      (_) => add(GetRecentItems(
          recentId: event.recentId)), // Fetch updated recent items after adding
    );
  }

  Future<void> _onGetRecentItems(
      GetRecentItems event, Emitter<RecentState> emit) async {
    emit(RecentLoading());
    final recentId = event.recentId;
    final result = await _getRecentItemsUsecase(recentId);

    result.fold(
      (failure) => emit(RecentError(message: failure.message)),
      (recentItems) => emit(RecentLoaded(recentItems: recentItems)),
    );
  }

  Future<void> _onCheckIfProductExists(
    CheckIfProductExists event, Emitter<RecentState> emit) async {
  emit(RecentLoading());

  // Get the list of recently viewed items
  final result = await _getRecentItemsUsecase(event.recentId);

  result.fold(
    (failure) => emit(RecentError(message: failure.message)),
    (recentItems) {
      // Check if the product already exists in the list
      final existingProduct = recentItems.firstWhere(
        (item) =>
            item.name == event.name &&
            item.shopName == event.shopName &&
            item.measure == event.measure,
        orElse: () => RecentlyViewedEntity( 
          id: event.recentId,// Return a default value here
          name: '', 
          image: '',
          measure: '',
          shopName: '',
          price: 0.0,
          recentId: '', // Adjust according to the default values needed
        ),
      );

      if (existingProduct.name.isEmpty) { // Check if product was found
        // If the product doesn't exist, add it to the list
        add(AddRecentItem(
          name: event.name,
          image: '', // Add the correct image URL here
          measure: event.measure,
          shopName: event.shopName,
          recentId: event.recentId,
          price: 0.0, // Add the correct price here
        ));
      } else {
        // If the product exists, just emit the existing list
        emit(RecentLoaded(recentItems: recentItems));
      }
    },
  );
}

}
