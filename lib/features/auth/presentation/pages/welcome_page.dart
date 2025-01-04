import 'package:flutter/material.dart';
import 'package:compareitr/core/theme/app_pallete.dart';
import 'package:compareitr/bottom_bar.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> welcomeData = [
    {
      'title': 'Compare Prices',
      'description': 'Find the best deals by comparing prices across different stores',
      'image': 'assets/lemon.png',
    },
    {
      'title': 'Save Your Favorites',
      'description': 'Save your favorite items and track their prices',
      'image': 'assets/house.png',
    },
    {
      'title': 'Fast Deliveries',
      'description': 'Order your groceries now, and recieve them within an hour',
      'image': 'assets/clothing.png',
    },
    {
      'title': 'Start Shopping',
      'description': 'Get the best value for your money',
      'image': 'assets/mama2.png',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onGetStarted() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: welcomeData.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        welcomeData[index]['image']!,
                        height: 300,
                      ),
                      const SizedBox(height: 50),
                      Text(
                        welcomeData[index]['title']!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppPallete.authColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          welcomeData[index]['description']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Page indicators
                  Row(
                    children: List.generate(
                      welcomeData.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 6),
                        height: 8,
                        width: _currentPage == index ? 20 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppPallete.primaryColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  // Next/Get Started button
                  ElevatedButton(
                    
                    onPressed: () {
                      if (_currentPage < welcomeData.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        _onGetStarted();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppPallete.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      _currentPage < welcomeData.length - 1
                          ? 'Next'
                          : 'Get Started',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}