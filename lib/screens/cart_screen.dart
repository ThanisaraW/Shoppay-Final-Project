import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isEditMode = false;
  final Set<String> _selectedForDelete = {};

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final totalPrice = ref.watch(cartTotalPriceProvider);
    final selectedCount = ref.watch(selectedItemsCountProvider);

    // จัดกลุ่มสินค้าตามร้านค้า
    final groupedItems = <String, List<dynamic>>{};
    for (var item in cartItems) {
      final shopKey = item.shopName ?? (item.isMall ? 'Mall' : 'Unknown Shop');
      if (!groupedItems.containsKey(shopKey)) {
        groupedItems[shopKey] = [];
      }
      groupedItems[shopKey]!.add(item);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text('รถเข็น (${cartItems.length})', style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (_isEditMode) {
                  _selectedForDelete.clear();
                }
                _isEditMode = !_isEditMode;
              });
            },
            child: Text(
              _isEditMode ? 'สำเร็จ' : 'แก้ไข',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('Your cart is empty', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Start Shopping'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Header with voucher info
                Container(
                  color: Colors.orange.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.local_offer, color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'ได้ส่วนลดของ Shopee',
                          style: TextStyle(fontSize: 13, color: Colors.orange),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'กดใช้โค้ด >',
                          style: TextStyle(fontSize: 13, color: Colors.orange, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                
                // Cart items
                Expanded(
                  child: ListView.builder(
                    itemCount: groupedItems.length,
                    itemBuilder: (context, index) {
                      final shopName = groupedItems.keys.elementAt(index);
                      final items = groupedItems[shopName]!;
                      
                      return _buildShopSection(context, shopName, items);
                    },
                  ),
                ),
                
                // Bottom bar with total and checkout
                if (!_isEditMode)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Checkbox(
                            value: selectedCount == cartItems.length && cartItems.isNotEmpty,
                            onChanged: (value) {
                              ref.read(cartProvider.notifier).selectAll(value ?? false);
                            },
                            activeColor: AppColors.primary,
                          ),
                          const Text('ทั้งหมด', style: TextStyle(fontSize: 14)),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                Formatters.formatCurrency(totalPrice),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: selectedCount > 0
                                ? () {
                                    final selectedItems = cartItems
                                        .where((item) => item.isSelected)
                                        .toList();
                                    
                                    // Debug log
                                    print('Selected items count: ${selectedItems.length}');
                                    print('Items: ${selectedItems.map((e) => e.name).toList()}');
                                    
                                    context.push('/checkout', extra: {
                                      'items': selectedItems,
                                      'totalPrice': totalPrice,
                                    });
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              disabledBackgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: Text('ชำระเงิน ($selectedCount)'),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Edit mode bottom bar
                if (_isEditMode)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Checkbox(
                            value: _selectedForDelete.length == cartItems.length && cartItems.isNotEmpty,
                            onChanged: (value) {
                              setState(() {
                                if (value == true) {
                                  _selectedForDelete.clear();
                                  _selectedForDelete.addAll(cartItems.map((item) => item.id));
                                } else {
                                  _selectedForDelete.clear();
                                }
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                          const Text('ทั้งหมด', style: TextStyle(fontSize: 14)),
                          const Spacer(),
                          OutlinedButton(
                            onPressed: _selectedForDelete.isEmpty
                                ? null
                                : () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('เพิ่มไปยังสินค้าที่ถูกใจแล้ว!'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: _selectedForDelete.isEmpty ? Colors.grey : AppColors.primary,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('ย้ายไปยังสินค้าที่ถูกใจ', style: TextStyle(fontSize: 12)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _selectedForDelete.isEmpty
                                ? null
                                : () {
                                    for (final id in _selectedForDelete) {
                                      ref.read(cartProvider.notifier).removeItem(id);
                                    }
                                    setState(() {
                                      _selectedForDelete.clear();
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('ลบสินค้าแล้ว'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              disabledBackgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('ลบ'),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildShopSection(BuildContext context, String shopName, List items) {
    final allSelected = items.every((item) => 
      _isEditMode ? _selectedForDelete.contains(item.id) : item.isSelected
    );
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Column(
        children: [
          // Shop header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Checkbox(
                  value: allSelected,
                  onChanged: (value) {
                    if (_isEditMode) {
                      setState(() {
                        for (var item in items) {
                          if (value == true) {
                            _selectedForDelete.add(item.id);
                          } else {
                            _selectedForDelete.remove(item.id);
                          }
                        }
                      });
                    } else {
                      // Toggle selection for all items in this shop
                      for (var item in items) {
                        if (value == true && !item.isSelected) {
                          ref.read(cartProvider.notifier).toggleSelection(item.id);
                        } else if (value == false && item.isSelected) {
                          ref.read(cartProvider.notifier).toggleSelection(item.id);
                        }
                      }
                    }
                  },
                  activeColor: AppColors.primary,
                ),
                if (shopName != 'Mall')
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.store, size: 16),
                  ),
                if (shopName == 'Mall')
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'Mall',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Expanded(
                  child: Text(
                    shopName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.chevron_right, size: 20, color: Colors.grey[400]),
              ],
            ),
          ),
          
          // Shop items
          ...items.map((item) => _buildCartItem(context, item)),
          
          // Shop voucher section
          if (items.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_offer, color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'ซื้อ 3 ชิ้น รับส่วนลด 1%',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 16, color: Colors.grey[400]),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, item) {
    final isSelectedForDelete = _selectedForDelete.contains(item.id);
    
    return Dismissible(
      key: Key(item.id),
      direction: _isEditMode ? DismissDirection.none : DismissDirection.endToStart,
      onDismissed: (direction) {
        ref.read(cartProvider.notifier).removeItem(item.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('ลบสินค้าแล้ว'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'เลิกทำ',
              onPressed: () {},
            ),
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: Colors.white, size: 28),
            SizedBox(height: 4),
            Text('ลบ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[100]!),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _isEditMode ? isSelectedForDelete : item.isSelected,
              onChanged: (value) {
                if (_isEditMode) {
                  setState(() {
                    if (value == true) {
                      _selectedForDelete.add(item.id);
                    } else {
                      _selectedForDelete.remove(item.id);
                    }
                  });
                } else {
                  ref.read(cartProvider.notifier).toggleSelection(item.id);
                }
              },
              activeColor: AppColors.primary,
            ),
            
            // Product image
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: item.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.image, size: 40, color: Colors.grey);
                        },
                      ),
                    )
                  : const Icon(Icons.image, size: 40, color: Colors.grey),
            ),
            
            // Product info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  if (item.variant != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              '# ${item.variant}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 16,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 8),
                  
                  if (item.isMall)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: const Text(
                              'ฟรีค่าส่ง',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: const Text(
                              'คืนเงิน',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Formatters.formatCurrency(item.price),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      if (!_isEditMode)
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (item.quantity > 1) {
                                  ref.read(cartProvider.notifier).updateQuantity(
                                    item.id,
                                    item.quantity - 1,
                                  );
                                } else {
                                  ref.read(cartProvider.notifier).removeItem(item.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('ลบสินค้าออกจากตะกร้าแล้ว'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: const Icon(Icons.remove, size: 16),
                              ),
                            ),
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                ref.read(cartProvider.notifier).updateQuantity(
                                  item.id,
                                  item.quantity + 1,
                                );
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: const Icon(Icons.add, size: 16),
                              ),
                            ),
                          ],
                        ),
                    ],
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