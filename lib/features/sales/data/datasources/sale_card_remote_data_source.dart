import 'package:compareitr/core/error/exceptions.dart';
import 'package:compareitr/features/sales/data/models/sale_card_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class SaleCardRemoteDataSource {
  Future<List<SaleCardModel>> getSaleCard();
}

class SaleCardRemoteDataSourceImpl implements SaleCardRemoteDataSource {
  final SupabaseClient supabaseClient;

  SaleCardRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<SaleCardModel>> getSaleCard() async {
   
    try {
      final List<dynamic> response =
          await supabaseClient.from('salecard').select("*");

      

      return response.map((item) => SaleCardModel.fromJson(item)).toList();
    } on PostgrestException catch (e) {
      // Print the specific exception message
      print("PostgrestException: Failed to fetch salecard items: ${e.message}");
      throw ServerException('Failed to fetch salecard items: ${e.message}');
    } catch (e, stackTrace) {
      // Print the generic exception and stack trace for debugging
      print("Unexpected error: $e");
      print("Stack trace: $stackTrace");
      throw ServerException('Unexpected error: $e');
    }
  }
}
