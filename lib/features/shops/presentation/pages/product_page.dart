import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/all_products/all_products_bloc.dart';
import '../bloc/all_categories/all_categories_bloc.dart';
import '../widgets/product_tile.dart';

class ProductPage extends StatefulWidget {
  final String categoryName;
  final String shopName;

  const ProductPage({
    super.key,
    required this.categoryName,
    required this.shopName,
  });

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? selectedSubCategory = 'All';

  @override
  void initState() {
    super.initState();
    context.read<AllProductsBloc>().add(
          GetProductsByCategoryEvent(
            shopName: widget.shopName,
            category: widget.categoryName,
          ),
        );
    context.read<AllCategoriesBloc>().add(
          GetCategoriesByShopNameEvent(shopName: widget.shopName),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AllCategoriesBloc, AllCategoriesState>(
          builder: (context, state) {
            if (state is CategoriesByShopNameSuccess) {
              return PopupMenuButton<String>(
                initialValue: widget.categoryName,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.categoryName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
                onSelected: (String newCategory) {
                  if (newCategory != widget.categoryName) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(
                          categoryName: newCategory,
                          shopName: widget.shopName,
                        ),
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return state.categories.map((category) {
                    return PopupMenuItem<String>(
                      value: category.categoryName,
                      child: Text(category.categoryName),
                    );
                  }).toList();
                },
              );
            }
            return Text(
              widget.categoryName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<AllProductsBloc, AllProductsState>(
            builder: (context, state) {
              final List<String> subCategories =
                  state is GetProductsByCategorySuccess
                      ? state.subCategories
                      : (state is GetProductsBySubCategorySuccess
                          ? AllProductsBloc.subCategories
                          : []);

              if (subCategories.isNotEmpty) {
                final allSubCategories = ['All', ...subCategories];

                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allSubCategories.length,
                    itemBuilder: (context, index) {
                      final subCategory = allSubCategories[index];
                      final isSelected = selectedSubCategory == subCategory;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSubCategory = subCategory;
                          });

                          if (subCategory == 'All') {
                            context.read<AllProductsBloc>().add(
                                  GetProductsByCategoryEvent(
                                    shopName: widget.shopName,
                                    category: widget.categoryName,
                                  ),
                                );
                          } else {
                            context.read<AllProductsBloc>().add(
                                  GetProductsBySubCategoryEvent(
                                    shopName: widget.shopName,
                                    category: widget.categoryName,
                                    subCategory: subCategory,
                                  ),
                                );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(3.0),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 3.0,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.green
                                : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              subCategory,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox(height: 0);
            },
          ),
          Expanded(
            child: BlocBuilder<AllProductsBloc, AllProductsState>(
              builder: (context, state) {
                if (state is GetProductsByCategorySuccess ||
                    state is GetProductsBySubCategorySuccess) {
                  final products = state is GetProductsByCategorySuccess
                      ? state.products
                      : (state as GetProductsBySubCategorySuccess).products;

                  if (products.isEmpty) {
                    return const Center(
                      child: Text('No products found'),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.60,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductTile(product: products[index]);
                    },
                  );
                } else if (state is GetProductsByCategoryLoading ||
                    state is GetProductsBySubCategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetProductsByCategoryFailure ||
                    state is GetProductsBySubCategoryFailure) {
                  final message = state is GetProductsByCategoryFailure
                      ? (state as GetProductsByCategoryFailure).message
                      : (state as GetProductsBySubCategoryFailure).message;
                  return Center(child: Text(message));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
