import 'package:compareitr/features/sales/presentation/bloc/saleproducts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaleDetailsPage extends StatefulWidget {
  final String? storeName;
  final DateTime? startDate;
  final DateTime? endDate;

  const SaleDetailsPage({
    Key? key,
    required this.storeName,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  _SaleDetailsPageState createState() => _SaleDetailsPageState();
}

class _SaleDetailsPageState extends State<SaleDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Dispatch the event to get products when the page is initialized
    context.read<SaleProductBloc>().add(GetAllSaleProductsEvent());
  }

  // Helper function to check if date ranges exactly match
  bool isDateRangeExactMatch(
      DateTime productStartDate, DateTime productEndDate) {
    final widgetStartDate = widget.startDate ?? DateTime.now();
    final widgetEndDate = widget.endDate ?? DateTime.now();

    // Debugging exact date match logic
    debugPrint('Checking exact match: Product startDate = $productStartDate, '
               'product endDate = $productEndDate, '
               'Widget startDate = $widgetStartDate, '
               'Widget endDate = $widgetEndDate');

    // Check if the product's start and end dates exactly match the widget's selected dates
    return productStartDate.isAtSameMomentAs(widgetStartDate) &&
           productEndDate.isAtSameMomentAs(widgetEndDate);
  }

  Widget buildProductCard(dynamic product) {
    final double price = product.price?.toDouble() ?? 0.0;
    final double oldPrice = product.oldprice?.toDouble() ?? 0.0;
    final double saveAmount = oldPrice - price;

    return GestureDetector(
      onTap: () {
        // Navigate to product details or other functionality
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product.image != null
                ? Image.network(
                    product.image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  )
                : const Icon(Icons.image, size: 100),
            Text(
              product.name ?? 'No Name', // If name is null, show 'No Name'
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Price: N\$${price.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.green),
            ),
            Text(
              'Old Price: N\$${oldPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.red,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            Text(
              'Save: N\$${saveAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              product.description ?? 'No Description', // Handle null description
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            ElevatedButton(
              onPressed: () {
                // Add to Cart functionality
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storeName ?? 'Sale Details'),
      ),
      body: BlocBuilder<SaleProductBloc, SaleproductsState>(builder: (context, state) {
        if (state is SaleproductsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SaleproductsFailure) {
          return Center(child: Text(state.message));
        } else if (state is SaleproductsSuccess) {
          final filteredProducts = state.saleProducts.where((product) {
            debugPrint('Checking product: ${product.name}');

            // Ensure the store name matches or is null
            if (product.storeName != widget.storeName) {
              debugPrint('Product store mismatch: ${product.storeName}');
              return false; // Skip product if store name does not match
            }

            // Ensure the product's date range is valid and exactly matches
            if (product.startDate == null || product.endDate == null) {
              debugPrint('Product has missing date range: ${product.name}');
              return false; // Skip product if dates are missing
            }

            // Check if the product's sale period exactly matches the selected date range
            if (!isDateRangeExactMatch(product.startDate!, product.endDate!)) {
              debugPrint('Date range does not exactly match for product: ${product.name}');
              return false; // Skip product if date range doesn't exactly match
            }

            return true; // If both store and date range match exactly, include the product
          }).toList();

          if (filteredProducts.isEmpty) {
            return const Center(child: Text('No matching products available.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.55,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              return buildProductCard(filteredProducts[index]);
            },
          );
        }
        return const Center(child: Text('No products available.'));
      }),
    );
  }
}
