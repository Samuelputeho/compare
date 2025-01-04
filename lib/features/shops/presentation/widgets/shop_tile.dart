import 'package:flutter/material.dart';

class ShopTile extends StatelessWidget {
  final String shopName;
  final String shopLogo;
  final GestureTapCallback? onTap; // Changed to GestureTapCallback?

  const ShopTile({
    super.key,
    required this.shopName,
    required this.shopLogo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  shopLogo,
                  height: 100,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error,
                        size: 100, color: Colors.red); // Handle image errors
                  },
                ),
              ),
              const SizedBox(
                  height: 10), // Reduced height for a more compact look
              Text(
                shopName,
                style: const TextStyle(
                  fontSize: 18, // Slightly smaller font size
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center, // Center align text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
