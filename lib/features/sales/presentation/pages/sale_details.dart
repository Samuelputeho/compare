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
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top part with image and save amount in a separate container
            Stack(
              children: [
                // Image section
                Container(
                  
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ), // Light grey background for the top part
                  child: product.image != null
                      ? Image.network(
                          product.image!,
                          fit: BoxFit.fitHeight,
                          width: double.infinity,
                          height: 125,
                        )
                      : const Icon(Icons.image, size: 100),
                ),
                // Save text positioned at the top-left of the container
                Positioned(
                  left: 10,
                  top: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Colors.black.withOpacity(0.7), // Semi-transparent orange background
                    child: Text(
                      'Save: N\$${saveAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2),

            // Bottom part with name, old price, description, and + button
            Container(
              color: Colors.white, // Dark grey background for the bottom part
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    product.name ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Old price (struck-through)
                  
                  // Description
                  Text(
                    product.description ?? 'No Description',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Add to Cart button replaced with a + sign in a grey container
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Column(
                        children: [
                          Text(
                    'N\$${oldPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                          Text(
                            'N\$${price.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400, // Light grey background for the + button
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
      body: BlocBuilder<SaleProductBloc, SaleproductsState>(
        builder: (context, state) {
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
                childAspectRatio: 0.65,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return buildProductCard(filteredProducts[index]);
              },
            );
          }
          return const Center(child: Text('No products available.'));
        },
      ),
    );
  }
}
