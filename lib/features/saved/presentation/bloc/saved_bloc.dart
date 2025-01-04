import 'package:compareitr/features/saved/domain/usecases/add_saved_item_usecase.dart';
import 'package:compareitr/features/saved/domain/usecases/get_saved_items_usecase.dart';
import 'package:compareitr/features/saved/domain/usecases/remove_saved_item_usecase.dart';
import 'package:compareitr/core/common/entities/saved_entity.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'saved_event.dart';
part 'saved_state.dart';

class SavedBloc extends Bloc<SavedEvent, SavedState> {
  final AddSavedItemUsecase _addSavedItemUsecase;

  final GetSavedItemsUsecase _getSavedItemsUsecase;

  final RemoveSavedItemUsecase _removeSavedItemUsecase;

  SavedBloc({
    required AddSavedItemUsecase addSavedItemUsecase,
    required GetSavedItemsUsecase getSavedItemsUsecase,
    required RemoveSavedItemUsecase removeSavedItemUsecase,
  })  : _addSavedItemUsecase = addSavedItemUsecase,
        _getSavedItemsUsecase = getSavedItemsUsecase,
        _removeSavedItemUsecase = removeSavedItemUsecase,
        super(SavedInitial()) {
    on<AddSavedItem>(_onAddSavedItem);
    on<GetSavedItems>(_onGetSavedItems);
    on<RemoveSavedItem>(_onRemoveSavedItem);
  }

  Future<void> _onAddSavedItem(
      AddSavedItem event, Emitter<SavedState> emit) async {
    emit(SavedLoading());
    final result = await _addSavedItemUsecase(
      AddSavedItemParams(
        name: event.name,
        image: event.image,
        measure: event.measure,
        shopName: event.shopName,
        savedId: event.savedId,
        price: event.price,
      ),
    );

    result.fold(
      (failure) => emit(SavedError(message: failure.message)),
      (_) => add(GetSavedItems(
          savedId: event.savedId)), // Fetch updated saved items after adding
    );
  }

  Future<void> _onRemoveSavedItem(
      RemoveSavedItem event, Emitter<SavedState> emit) async {
    emit(SavedLoading());
    final result =
        await _removeSavedItemUsecase(RemoveSavedItemParams(id: event.id));

    result.fold(
      (failure) => emit(SavedError(message: failure.message)),
      (_) {
        // Ensure we fetch the updated list for the correct user/group
        add(GetSavedItems(savedId: event.savedId)); // Use the correct savedId
      },
    );
  }

  Future<void> _onGetSavedItems(
      GetSavedItems event, Emitter<SavedState> emit) async {
    emit(SavedLoading());
    final savedId = event.savedId;
    final result = await _getSavedItemsUsecase(savedId);

    result.fold(
      (failure) => emit(SavedError(message: failure.message)),
      (savedItems) => emit(SavedLoaded(savedItems: savedItems)),
    );
  }
}
