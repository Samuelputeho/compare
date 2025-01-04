import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:compareitr/features/shops/presentation/bloc/all_products/all_products_bloc.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _hasTyped = false; // Tracks whether the user has started typing

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Products'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _hasTyped = value.isNotEmpty; // Update typing state
                });

                if (value.isNotEmpty) {
                  context
                      .read<AllProductsBloc>()
                      .add(SearchProductsEvent(value));
                  _scrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                } else {
                  context.read<AllProductsBloc>().add(GetAllProductsEvent());
                }
              },
            ),
          ),
          Expanded(
            child: _hasTyped
                ? BlocBuilder<AllProductsBloc, AllProductsState>(
                    builder: (context, state) {
                      if (state is GetAllProductsSuccess) {
                        final products = state.products;

                        if (products.isEmpty) {
                          return Center(
                            child: Text(
                              'No results found for "${_searchController.text}".',
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ListTile(
                              contentPadding: EdgeInsets.all(10),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(product.imageUrl),
                                radius: 30, // Size of the logo
                              ),
                              title: Text(product.name),
                              subtitle: Text(
                                  '${product.measure} - ${product.shopName}'),
                              trailing: Image.network(
                                product
                                    .imageUrl, // Assuming your product has an image URL
                                width: 50, // Adjust based on your needs
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              onTap: () {
                                print('Selected: ${product.name}');
                              },
                            );
                          },
                        );
                      } else if (state is GetAllProductsFailure) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Failed to load products: ${state.message}'),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<AllProductsBloc>()
                                      .add(GetAllProductsEvent());
                                },
                                child: Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      return Center(child: CircularProgressIndicator());
                    },
                  )
                : Center(
                    child: Text(
                      'Start typing to search for products.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
