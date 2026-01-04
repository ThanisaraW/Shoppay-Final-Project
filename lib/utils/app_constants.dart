class AppConstants {
  static const String appName = 'Shopee';
  static const String appVersion = '1.0.0';
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String categoriesCollection = 'categories';
  static const String keyCart = 'cart_items';
  static const String keyUser = 'user_data';
  static const String keyWishlist = 'wishlist';
  static const String routeHome = '/';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeProduct = '/product';
  static const String routeCategory = '/category';
  static const String routeCart = '/cart';
  static const String routeCheckout = '/checkout';
  static const String routeProfile = '/profile';
  static const String routeOrders = '/orders';
  static const String routeSearch = '/search';
  static const String routeChat = '/chat';
  static const int productsPerPage = 20;
  static const String currencySymbol = '฿';
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const Duration mockApiDelay = Duration(milliseconds: 800);
}