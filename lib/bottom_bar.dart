import 'package:compareitr/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'features/likes/presentation/pages/like_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/shops/presentation/pages/home_page.dart';
import 'features/wallet/presentation/pages/wallet_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const WalletPage(),
    const WalletPage(),
    const LikePage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  IconData _getIconData(int index, bool isSelected) {
    switch (index) {
      case 0:
        return isSelected ? IconlyBold.home : IconlyLight.home;
      case 1:
        return isSelected ? IconlyBold.wallet : IconlyLight.wallet;
      case 2:
        return isSelected ? IconlyBold.bag : IconlyLight.notification;
      case 3:
        return isSelected ? IconlyBold.heart : IconlyLight.heart;
      case 4:
        return isSelected ? IconlyBold.profile : IconlyLight.profile;
      default:
        return IconlyLight.home; // Default icon
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Light mode background color
        elevation: 0,
        items: List.generate(5, (index) {
          return BottomNavigationBarItem(
            icon: Icon(
              _getIconData(index, index == _selectedIndex),
              size: 25, // Adjust the icon size as needed
              color: index == _selectedIndex ? Colors.green : Colors.grey,
            ),
            label: '',
          );
        }),
        currentIndex: _selectedIndex,
        selectedItemColor: AppPallete.primaryColor,
        unselectedItemColor: AppPallete.secondaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
