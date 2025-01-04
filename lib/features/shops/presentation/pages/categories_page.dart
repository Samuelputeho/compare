import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/all_categories/all_categories_bloc.dart';
import '../widgets/category_tile.dart';

class CategoriesPage extends StatelessWidget {
  final String storeName;

  const CategoriesPage({
    super.key,
    required this.storeName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              iconSize: 20,
            ),
          ),
        ),
        title: Text(storeName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz_outlined),
                iconSize: 20,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<AllCategoriesBloc, AllCategoriesState>(
        builder: (context, state) {
          if (state is AllCategoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AllCategoriesFailure) {
            return Center(child: Text(state.message));
          }

          if (state is CategoriesByShopNameSuccess) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final category = state.categories[index];
                  return CategoryTile(
                    catName: category.categoryName,
                    imageUrl: category.categoryUrl,
                    storeName: category.shopName,
                  );
                },
              ),
            );
          }

          return const Center(child: Text('No categories found'));
        },
      ),
    );
  }
}
