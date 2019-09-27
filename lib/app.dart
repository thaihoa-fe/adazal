import 'package:adazal_app/providers/auth.dart';
import 'package:adazal_app/providers/cart.dart';
import 'package:adazal_app/providers/products.dart';
import 'package:adazal_app/screens/cart.dart';
import 'package:adazal_app/screens/edit_product.dart';
import 'package:adazal_app/screens/orders.dart';
import 'package:adazal_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/product_detail.dart';
import './screens/product_overview.dart';
import './screens/user_products.dart';
import './screens/auth.dart';
import './providers/orders.dart';

final themeData = ThemeData(
  primarySwatch: Colors.lightBlue,
  accentColor: Colors.green,
  fontFamily: 'Lato',
  textTheme: TextTheme(
    title: TextStyle(
      fontSize: 20,
      color: Colors.grey,
    ),
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          builder: (context, auth, prevProducts) => ProductsProvider(
            auth.token,
            auth.userId,
            prevProducts == null ? [] : prevProducts.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: CartProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          builder: (context, auth, prevOrdersProvider) => OrdersProvider(
            auth.token,
            auth.userId,
            prevOrdersProvider == null ? [] : prevOrdersProvider.orders,
          ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authProvider, _) {
          return MaterialApp(
            title: 'ADAZAL App',
            theme: themeData,
            home: !authProvider.isAuth
                ? FutureBuilder(
                    future: authProvider.tryAutoLogin(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SplashScreen();
                      }
                      return AuthScreen();
                    },
                  )
                : ProductsOverviewScreen(),
            routes: {
              ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
              CartScreen.routeName: (_) => CartScreen(),
              OrdersScreen.routeName: (_) => OrdersScreen(),
              UserProductsScreen.routeName: (_) => UserProductsScreen(),
              EditProductScreen.routeName: (_) => EditProductScreen(),
            },
          );
        },
      ),
    );
  }
}
