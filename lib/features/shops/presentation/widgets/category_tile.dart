import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/all_products/all_products_bloc.dart';
import '../pages/product_page.dart';

class CategoryTile extends StatelessWidget {
  final String catName;
  final String imageUrl;
  final String storeName;

  const CategoryTile({
    super.key,
    required this.catName,
    required this.imageUrl,
    required this.storeName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<AllProductsBloc>().add(
              GetProductsByCategoryEvent(
                shopName: storeName,
                category: catName,
              ),
            );
        //push to productsPage
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(
              shopName: storeName,
              categoryName: catName,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      )
                    : Image.asset(
                        imageUrl,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                catName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
