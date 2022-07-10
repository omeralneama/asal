
import 'package:asallah_fruits/const/theme_data.dart';
import 'package:asallah_fruits/inner_screens/feed_screen.dart';
import 'package:asallah_fruits/inner_screens/on_sale_screen.dart';
import 'package:asallah_fruits/providers/cart_provider.dart';
import 'package:asallah_fruits/providers/dark_theme_provider.dart';
import 'package:asallah_fruits/providers/order_provider.dart';
import 'package:asallah_fruits/providers/products_provider.dart';
import 'package:asallah_fruits/providers/viewed_provider.dart';
import 'package:asallah_fruits/providers/wishlist_provider.dart';
import 'package:asallah_fruits/screens/auth/forget_password.dart';
import 'package:asallah_fruits/screens/auth/login_screen.dart';
import 'package:asallah_fruits/screens/auth/phone_auth.dart';
import 'package:asallah_fruits/screens/auth/register.dart';
import 'package:asallah_fruits/screens/btm_bar_screen.dart';
import 'package:asallah_fruits/screens/order/order_screen.dart';
import 'package:asallah_fruits/screens/viewed_recently/viewed_recently_screen.dart';
import 'package:asallah_fruits/screens/wishlist/wishlist_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'fetch_screen.dart';
import 'inner_screens/cat_screen.dart';
import 'inner_screens/prouducts_details.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey = "pk_test_51L9RoTF5WLBxNUMV8PvDqTmb09vESHLaOg5V6PlYar5FQbL77wU4lQjpnWzno0AR3sqLmeyirBFXUVqbmqu4Ef5D00VdYlPl1i";
  Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget
{
   const MyApp({ Key? key }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
{
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async
  {
    themeChangeProvider.setDarkTheme =
    await themeChangeProvider.darkThemePrefs.getTheme();
  }
  @override
  void initState()
  {
    getCurrentAppTheme();
    super.initState();
  }
  final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context)
   {
    return FutureBuilder(
      future: firebaseInitialization,
      builder: (context, snapshot,)
        {
          if(snapshot.connectionState == ConnectionState.waiting)
            {
              return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              );
            } else if(snapshot.hasError)
              {
                 const MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Directionality (
                    textDirection: TextDirection.rtl,
                    child: Scaffold(
                    body: Center(
                      child: Text('حدث خطأ',),
                    ),
                  ),
                  ),
                );
              }
          return MultiProvider(
            providers:
            [
              ChangeNotifierProvider(create: (_)
              {
                return themeChangeProvider;
              }),

              ChangeNotifierProvider(create: (_)
              => ProductsProvider(),
              ),

              ChangeNotifierProvider(create: (_)
              => CartProvider(),
              ),

              ChangeNotifierProvider(create: (_)
              => WishlistProvider(),
              ),

              ChangeNotifierProvider(create: (_)
              => ViewedProductProvider(),
              ),

              ChangeNotifierProvider(create: (_)
              => OrdersProvider(),
              ),
            ],
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child)
                {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'أصالة الثمار',
                    theme: Styles.themeData(
                        themeProvider.getDarkTheme, context
                    ),
                    home:const Directionality(
                      textDirection: TextDirection.rtl,
                      child: FetchScreen(),
                    ),
                    routes:
                    {
                      FetchScreen.routeName : (ctx) => const Directionality(
                          textDirection: TextDirection.rtl,
                          child: FetchScreen()),

                      OnSaleScreen.routeName : (ctx) => const Directionality(
                          textDirection: TextDirection.rtl,
                          child: OnSaleScreen()),

                      FeedScreen.routeName : (ctx) => const Directionality(
                          textDirection: TextDirection.rtl,
                          child: FeedScreen()),

                      ProductDetails.routeName : (ctx) => const Directionality(
                          textDirection: TextDirection.rtl,
                          child: ProductDetails()),

                      WishListScreen.routeName : (ctx) => const Directionality(
                          textDirection: TextDirection.rtl,
                          child: WishListScreen()),

                      OrdersScreen.routeName : (ctx) => const Directionality(
                          textDirection: TextDirection.rtl,
                          child: OrdersScreen()),

                      ViewedRecentlyScreen.routeName : (ctx) => const Directionality(
                          textDirection: TextDirection.rtl,
                          child: ViewedRecentlyScreen()),

                      RegisterScreen.routeName : (ctx) => const Directionality(
                          textDirection: TextDirection.rtl,
                          child: RegisterScreen()),

                      LoginScreen.routeName : (ctx) => const Directionality(
                          textDirection: TextDirection.rtl,
                          child: LoginScreen()),

                      ForgetPasswordScreen.routeName : (ctx) => const Directionality(
                          textDirection: TextDirection.rtl,
                          child: ForgetPasswordScreen()),

                      BottomBarScreen.routeName : (ctx) => const Directionality(
                          textDirection: TextDirection.rtl,
                          child: BottomBarScreen()),

                      CategoryScreen.routeName : (ctx) => const Directionality(
                          textDirection: TextDirection.rtl,
                          child: CategoryScreen()),

                      PhoneAuthScreen.routeName : (ctx) => const Directionality(
                          textDirection: TextDirection.rtl,
                          child: PhoneAuthScreen()),
                    },
                  );
                }
            ),
          );
        }
    );
  }
}
