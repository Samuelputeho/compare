import 'package:compareitr/core/common/models/card_swiper_pictures_model.dart';
import 'package:compareitr/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_const.dart';

abstract interface class CardSwiperRemoteDataSource {
  Future<List<CardSwiperPicturesModel>> getAllPictures();
}

class CardSwiperRemoteDataSourceImpl implements CardSwiperRemoteDataSource {
  final SupabaseClient client;

  CardSwiperRemoteDataSourceImpl(this.client);

  @override
  Future<List<CardSwiperPicturesModel>> getAllPictures() async {
    try {
      final response =
          await client.from(AppConstants.cardSwiperCollection).select();

      // Check if the response is empty or has an error
      if (response.isEmpty) {
        return []; // Return an empty list if no data is found
      }

      return response
          .map((json) => CardSwiperPicturesModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
