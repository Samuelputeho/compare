import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class SavedTile extends StatelessWidget {
  final String foodName;
  final String foodImage;
  final String foodPrice;
  final String foodQuantity;
  final String foodShop;
  final VoidCallback onDelete;
  final VoidCallback onPlusTap;
  final bool isInCart;

  const SavedTile({
    super.key,
    required this.foodName,
    required this.foodImage,
    required this.foodPrice,
    required this.foodQuantity,
    required this.foodShop,
    required this.onDelete,
    required this.onPlusTap,
    required this.isInCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.7,
      width: MediaQuery.of(context).size.width * 0.43,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.35,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Image.network(foodImage, fit: BoxFit.contain),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: onDelete,
                    child: const Icon(
                      IconlyLight.delete,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onPlusTap,
                    child: isInCart
                        ? Icon(
                            IconlyBold.plus, // Bold "Add" icon if in cart
                            color: Colors.green, // Green color if in cart
                          )
                        : Icon(
                            IconlyLight.plus, // Regular "Add" icon if not in cart
                            color: Colors.grey, // Regular grey color
                          ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    foodName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  foodQuantity,
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  foodShop,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(foodPrice),
          ),
        ],
      ),
    );
  }
}
