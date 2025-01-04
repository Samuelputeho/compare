import 'package:compareitr/core/error/exceptions.dart';
import 'package:compareitr/features/sales/data/models/sale_product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class SaleProductRemoteDataSource {
  Future<List<SaleProductModel>> getSaleProducts();
}

class SaleProductRemoteDataSourceImpl implements SaleProductRemoteDataSource {
  final SupabaseClient supabaseClient;

  SaleProductRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<SaleProductModel>> getSaleProducts() async {
    print("Supabase called");
    try {
      final List<dynamic> response =
          await supabaseClient.from('saleproducts').select("*");

      // Print the response for debugging
      print('Supabase response: $response');

      return response.map((item) => SaleProductModel.fromJson(item)).toList();
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
