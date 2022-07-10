import 'package:asallah_fruits/screens/home_screen.dart';
import 'package:asallah_fruits/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'cart/cart_screen.dart';
import 'categories_screen.dart';
import 'package:badges/badges.dart';

class BottomBarScreen extends StatefulWidget {
  static const routeName = '/BottomBarScreen';
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen>
{
  int selectedIndex = 0 ;
  final List<Map<String, dynamic>> pages =
  [
    {'page' : const HomeScreen(), 'title' : 'الصفحة الرئيسية'},
    {'page' :  CategoriesScreen(), 'title' : 'الأقسام'},
    {'page' : const CartScreen(), 'title' : 'سلة المشتريات'},
    {'page' : const UserScreen(), 'title' : 'الصفحة الشخصية'},
  ];
  void selectedPage(int index)
  {
    setState(()
    {
      selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: pages[selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        onTap: selectedPage,
        items: <BottomNavigationBarItem>
        [
          BottomNavigationBarItem(
              icon: Icon(
                  selectedIndex == 0 ? IconlyBold.home : IconlyLight.home,
              ),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                selectedIndex == 0 ? IconlyBold.category : IconlyLight.category,

              ),
              label: 'الأقسام',
          ),
          BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (_, myCart, ch) {
                  return Badge(
                  toAnimate: true,
                  shape: BadgeShape.circle,
                  badgeColor: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                  position: BadgePosition.topEnd(top: -7, end: -7),
                  badgeContent: FittedBox(
                      child: Text(
                          myCart.getCartItems.length.toString(),
                          style: const TextStyle(color: Colors.white))),
                  child: Icon(
                  selectedIndex == 0 ? IconlyBold.buy : IconlyLight.buy,
                    ),
                  );
                }
              ),
            label: 'سلة المشتريات',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                selectedIndex == 0 ? IconlyBold.user2 : IconlyLight.user2,
              ),
              label: 'الصفحة الشخصية',
          ),
        ],
      ),
    );
  }
}
