import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shoppay/screens/favorites_screen.dart';
import 'package:shoppay/screens/order_success_screen.dart';
import 'package:shoppay/screens/payment_screen.dart';
import '../providers/auth_provider.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/otp_verification_screen.dart';
import '../screens/account_check_screen.dart';
import '../screens/register_details_screen.dart';
import '../screens/home_screen.dart';
import '../screens/mall_screen.dart';
import '../screens/live_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/search_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/chat_list_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/voucher_selection_screen.dart';
import '../screens/shipping_selection_screen.dart';
import '../screens/payment_method_screen.dart';
import '../screens/splash_screen.dart';
import '../utils/app_constants.dart';

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(currentUserProvider);
  return authState.value != null;
});

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(currentUserProvider);
  
  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = authState.value != null;
      
      if (state.matchedLocation == '/splash') {
        return null;
      }
      
      final requiresAuth = state.matchedLocation == AppConstants.routeCart ||
                          state.matchedLocation == '/checkout';
      
      if (requiresAuth && !isAuthenticated) {
        return '${AppConstants.routeLogin}?redirect=${state.matchedLocation}';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      GoRoute(
        path: AppConstants.routeLogin,
        builder: (context, state) {
          final redirect = state.uri.queryParameters['redirect'];
          return LoginScreen(redirectTo: redirect);
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          final redirect = state.uri.queryParameters['redirect'];
          return RegisterScreen(redirectTo: redirect);
        },
      ),
      
      GoRoute(
        path: '/register/otp',
        builder: (context, state) => OtpVerificationScreen(
          phoneNumber: state.extra as String,
        ),
      ),
      GoRoute(
        path: '/register/account-check',
        builder: (context, state) => AccountCheckScreen(
          phoneNumber: state.extra as String,
          hasExistingAccount: true,
          maskedPhone: 'n*****k',
        ),
      ),
      GoRoute(
        path: '/register/details',
        builder: (context, state) => RegisterDetailsScreen(
          phoneNumber: state.extra as String,
        ),
      ),
      
      GoRoute(
        path: AppConstants.routeSearch,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: AppConstants.routeCart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: AppConstants.routeChat,
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id'] ?? '';
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: '/payment',
        builder: (context, state) {
          final orderData = state.extra as Map<String, dynamic>;
          return PaymentScreen(orderData: orderData);
        },
      ),
      GoRoute(
        path: '/order-success',
        builder: (context, state) {
          final orderData = state.extra as Map<String, dynamic>;
          return OrderSuccessScreen(orderData: orderData);
        },
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          
          // ตรวจสอบว่ามาจาก cart (มี items) หรือ Buy Now (มี productId)
          if (extra != null && extra['items'] != null) {
            // มาจาก cart
            return CheckoutScreen(
              items: extra['items'] as List<dynamic>,
              cartTotalPrice: extra['totalPrice'] as double?,
            );
          } else {
            // มาจาก Buy Now
            return CheckoutScreen(
              productId: extra?['productId'] as String?,
              productName: extra?['productName'] as String?,
              productImage: extra?['productImage'] as String?,
              productPrice: extra?['productPrice'] as double?,
              quantity: extra?['quantity'] as int? ?? 1,
            );
          }
        },
      ),
      GoRoute(
        path: '/voucher-selection',
        builder: (context, state) => const VoucherSelectionScreen(),
      ),
      GoRoute(
        path: '/shipping-selection',
        builder: (context, state) => const ShippingSelectionScreen(),
      ),
      GoRoute(
        path: '/payment-method',
        builder: (context, state) => const PaymentMethodScreen(),
      ),
      
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationScreen(child: child);
        },
        routes: [
          GoRoute(
            path: AppConstants.routeHome,
            pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/mall',
            pageBuilder: (context, state) => const NoTransitionPage(child: MallScreen()),
          ),
          GoRoute(
            path: '/live',
            pageBuilder: (context, state) => const NoTransitionPage(child: LiveScreen()),
          ),
          GoRoute(
            path: '/notifications',
            pageBuilder: (context, state) => const NoTransitionPage(child: NotificationsScreen()),
          ),
          GoRoute(
            path: AppConstants.routeProfile,
            pageBuilder: (context, state) => const NoTransitionPage(child: ProfileScreen()),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
        ],
      ),
    ],
  );
});