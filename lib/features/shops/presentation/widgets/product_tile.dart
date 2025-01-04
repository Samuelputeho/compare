import 'package:compareitr/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:compareitr/features/recently_viewed/presentation/bloc/recent_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/entities/product_entity.dart';
import '../../presentation/pages/product_details_page.dart'; // Import the ProductDetailsPage

class ProductTile extends StatelessWidget {
  final ProductEntity product;

  const ProductTile({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Wrap the Container with GestureDetector
      onTap: () {
        final recentId =
            (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

        // Check if the product already exists in the recently viewed list
        context.read<RecentBloc>().add(GetRecentItems(recentId: recentId));

        // Handle the action after the list is fetched
        context.read<RecentBloc>().stream.listen((state) {
          if (state is RecentLoaded) {
            // Check if the product exists in the recently viewed list
            bool productExists = state.recentItems.any((item) =>
                item.name == product.name &&
                item.shopName == product.shopName &&
                item.measure == product.measure);

            if (!productExists) {
              // If the product doesn't exist, add it to the recently viewed list
              context.read<RecentBloc>().add(AddRecentItem(
                name: product.name,
                image: product.imageUrl,
                measure: product.measure,
                shopName: product.shopName,
                recentId: recentId,
                price: product.price,
              ));
            }
          }
        });

        // Navigate to the ProductDetailsPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error));
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                product.name,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'N\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
