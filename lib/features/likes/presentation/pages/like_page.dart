import 'package:compareitr/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:compareitr/features/likes/presentation/widgets/saved_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:compareitr/features/saved/presentation/bloc/saved_bloc.dart';

class LikePage extends StatefulWidget {
  const LikePage({super.key});

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  @override
  void initState() {
    super.initState();
    final savedId = (context.read<AppUserCubit>().state as AppUserLoggedIn)
        .user
        .id; // Get user ID
    context
        .read<SavedBloc>()
        .add(GetSavedItems(savedId: savedId)); // Dispatch event with userId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Items"),
      ),
      body: BlocBuilder<SavedBloc, SavedState>(
        builder: (context, state) {
          if (state is SavedLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SavedError) {
            return Center(child: Text(state.message));
          } else if (state is SavedLoaded) {
            if (state.savedItems.isEmpty) {
              return const Center(child: Text('No saved items'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: state.savedItems.length,
              itemBuilder: (context, index) {
                final item = state.savedItems[index];
                return SavedTile(
                  foodImage: item.image,
                  foodName: item.name,
                  foodPrice: 'N\$${item.price.toStringAsFixed(2)}',
                  foodQuantity: item.measure,
                  foodShop: item.shopName,
                  onDelete: () {
                    final savedId =
                        (context.read<AppUserCubit>().state as AppUserLoggedIn)
                            .user
                            .id;
                    context
                        .read<SavedBloc>()
                        .add(RemoveSavedItem(id: item.id, savedId: savedId));
                  },
                );
              },
            );
          }
          return const Center(child: Text('No saved items'));
        },
      ),
    );
  }
}
