import 'package:flutter/material.dart';
import 'package:compareitr/core/common/entities/cart_entity.dart';

class CartTile extends StatelessWidget {
  final CartEntity cartItem;
  final Function() onRemove;
  final Function() onIncrease;
  final Function() onDecrease;

  const CartTile({
    Key? key,
    required this.cartItem,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate total price for this item
    double totalPrice = cartItem.price * cartItem.quantity;

    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Product Image
          SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              cartItem.imageUrl, // Display the product image
              width: 80, // Set a fixed width for the image
              height: 95, // Set a fixed height for the image
              fit: BoxFit.fitHeight, // Ensure the image covers the area
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: Text(
        cartItem.itemName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    ),
    IconButton(
      icon: const Icon(Icons.close, color: Colors.grey),
      onPressed: onRemove,
    ),
  ],
),
                  Text(cartItem.shopName),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'N\$ ${totalPrice.toStringAsFixed(2)}'), // Display total price
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: onDecrease,
                              child: Container(
                                width: 22,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Center(child: Text('-')),
                              ),
                            ),
                            SizedBox(width: 4),
                            Text('${cartItem.quantity}'),
                            SizedBox(width: 4),
                            GestureDetector(
                              onTap: onIncrease,
                              child: Container(
                                width: 22,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    '+',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
