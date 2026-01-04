import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartItem {
  final String id;
  final String productId;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final bool isSelected;
  final String? variant; // เช่น "120mL", "Face Cream 35mL"
  final String? shopName;
  final bool isMall;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    this.isSelected = true,
    this.variant,
    this.shopName,
    this.isMall = false,
  });

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
    bool? isSelected,
    String? variant,
    String? shopName,
    bool? isMall,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
      variant: variant ?? this.variant,
      shopName: shopName ?? this.shopName,
      isMall: isMall ?? this.isMall,
    );
  }
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem({
    required String productId,
    required String name,
    required String imageUrl,
    required double price,
    String? variant,
    String? shopName,
    bool isMall = false,
    int quantity = 1,
  }) {
    // ตรวจสอบว่ามีสินค้าตัวเดียวกัน (productId + variant) อยู่แล้วหรือไม่
    final existingIndex = state.indexWhere(
      (item) => item.productId == productId && item.variant == variant,
    );

    if (existingIndex >= 0) {
      // ถ้ามีอยู่แล้ว เพิ่มจำนวน
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            state[i].copyWith(quantity: state[i].quantity + quantity)
          else
            state[i],
      ];
    } else {
      // ถ้ายังไม่มี สร้างใหม่
      state = [
        ...state,
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: productId,
          name: name,
          imageUrl: imageUrl,
          price: price,
          quantity: quantity,
          variant: variant,
          shopName: shopName,
          isMall: isMall,
        ),
      ];
    }
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void updateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeItem(id);
      return;
    }
    
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(quantity: quantity)
        else
          item,
    ];
  }

  void toggleSelection(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(isSelected: !item.isSelected)
        else
          item,
    ];
  }

  void selectAll(bool selected) {
    state = [
      for (final item in state)
        item.copyWith(isSelected: selected),
    ];
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

final cartTotalPriceProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems
      .where((item) => item.isSelected)
      .fold(0.0, (sum, item) => sum + (item.price * item.quantity));
});

final selectedItemsCountProvider = Provider<int>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.where((item) => item.isSelected).length;
});

final cartItemsCountProvider = Provider<int>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.length;
});