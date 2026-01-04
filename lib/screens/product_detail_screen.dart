import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_products.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _currentImageIndex = 0;
  int _quantity = 1;
  String _selectedVariant = '120mL';
  bool _showAllReviews = false;

  @override
  Widget build(BuildContext context) {
    final product = getProductById(widget.productId);
    final cartItemsCount = ref.watch(cartItemsCountProvider);
    final isFavorite = ref.watch(isFavoriteProvider(widget.productId));

    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: Text('Product not found')),
      );
    }

    final isMall = product.category == 'flash_sale' || product.category == 'health' || product.category == 'beauty';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  pinned: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => context.pop(),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.black),
                      onPressed: () {},
                    ),
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
                          onPressed: () => context.push('/cart'),
                        ),
                        if (cartItemsCount > 0)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                cartItemsCount > 99 ? '99+' : '$cartItemsCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

                // Product Images
                SliverToBoxAdapter(
                  child: Container(
                    height: 400,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        PageView.builder(
                          itemCount: product.imageUrls.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Center(
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.white,
                                child: Image.network(
                                  product.imageUrls[index],
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.image, size: 100, color: Colors.grey);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('${_currentImageIndex + 1}/${product.imageUrls.length}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Color/Size Options (for Mall products)
                if (isMall)
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('# $_selectedVariant', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildOptionButton('120mL', _selectedVariant == '120mL'),
                              const SizedBox(width: 8),
                              _buildOptionButton('60mL', _selectedVariant == '60mL'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                // Price Section with Favorite Button
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text('฿', style: TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold)),
                                      Text(product.price.toStringAsFixed(0), style: const TextStyle(fontSize: 28, color: Colors.red, fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red[50],
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: const Text('ราคาหลังได้ส่วนลด', style: TextStyle(fontSize: 10, color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                  if (product.originalPrice != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text('฿${product.originalPrice!.toStringAsFixed(2)} x 5 เดือนกับ SPayLater >', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('ขายแล้ว ${(product.sold / 1000).toStringAsFixed(1)}k+ ชิ้น', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                const SizedBox(height: 8),
                                // Favorite Button
                                GestureDetector(
                                  onTap: () {
                                    ref.read(favoritesProvider.notifier).toggleFavorite(widget.productId);
                                    
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(isFavorite ? 'ลบออกจากรายการโปรดแล้ว' : 'เพิ่มลงรายการโปรดแล้ว'),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.grey,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (product.originalPrice != null)
                              _buildVoucherTag('ส่วนลด ฿${(product.originalPrice! - product.price).toStringAsFixed(0)}'),
                            _buildVoucherTag('ซื้อ 2 ชิ้น ลด 5%'),
                            _buildVoucherTag('SPayLater 0%'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Shop Voucher
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 1),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.confirmation_number, color: Colors.red),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('ส่วนลด 10%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('ขั้นต่ำ ฿100 ลดสูงสุด ฿2,000', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('เก็บแล้ว', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                ),

                // Product Title (for Mall)
                if (isMall)
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 1),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.verified, color: Colors.white, size: 12),
                                    SizedBox(width: 4),
                                    Text('Fulfilled', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: const Text('Mall', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),

                // Shipping Info
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 1),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: const [
                        Icon(Icons.local_shipping, size: 20, color: Colors.grey),
                        SizedBox(width: 12),
                        Expanded(child: Text('จะได้รับภายใน 6 ต.ค. - 8 ต.ค.', style: TextStyle(fontSize: 14))),
                        Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                      ],
                    ),
                  ),
                ),

                // Additional Benefits
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 1),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildBenefitRow(Icons.shield_outlined, 'เก็บเงินปลายทาง'),
                        const Divider(height: 24),
                        _buildBenefitRow(Icons.credit_card, 'SPayLater: ผ่อนชำระพร้อมได้ส่วนลดพิเศษ'),
                      ],
                    ),
                  ),
                ),

                // Product Description
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('รายละเอียดสินค้า', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Text(
                          product.description,
                          style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),

                // Reviews Section
                if (product.reviewsList.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${product.rating}',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.star, color: Colors.orange, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'คะแนนสินค้า (${product.reviews})',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: Row(
                                  children: const [
                                    Text('ดูทั้งหมด', style: TextStyle(color: Colors.red)),
                                    Icon(Icons.chevron_right, color: Colors.red, size: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Icon(Icons.chat_bubble_outline, size: 18, color: Colors.orange),
                              SizedBox(width: 8),
                              Text('ได้รับการประเมินว่าดีใช้ได้', style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Reviews List
                          ...product.reviewsList.take(_showAllReviews ? product.reviewsList.length : 2).map((review) => _buildReviewCard(review)),
                          if (product.reviewsList.length > 2 && !_showAllReviews)
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showAllReviews = true;
                                  });
                                },
                                child: const Text('ดูความคิดเห็นเพิ่มเติม', style: TextStyle(color: Colors.red)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                // Shop Info
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(16),
                    child: isMall ? _buildMallShopInfo() : _buildRegularShopInfo(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),

          // Bottom Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2))],
            ),
            padding: const EdgeInsets.all(12),
            child: SafeArea(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.push('/chat'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isMall ? Colors.white : const Color(0xFFFCE4EC),
                        border: Border.all(color: isMall ? Colors.grey[300]! : Colors.transparent),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 24, color: isMall ? Colors.grey[700] : Colors.black),
                          const SizedBox(height: 4),
                          Text('แชทเลย', style: TextStyle(fontSize: 10, color: isMall ? Colors.grey[700] : Colors.black)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      ref.read(cartProvider.notifier).addItem(
                        productId: product.id,
                        name: product.name,
                        imageUrl: product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
                        price: product.price,
                        variant: isMall ? _selectedVariant : null,
                        shopName: isMall ? null : '😊 wopric • Health & Beauty ❤️',
                        isMall: isMall,
                        quantity: _quantity,
                      );
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('เพิ่มลงตะกร้าแล้ว!'),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'ดูตะกร้า',
                            onPressed: () => context.push('/cart'),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isMall ? Colors.white : const Color(0xFFFCE4EC),
                        border: Border.all(color: isMall ? Colors.grey[300]! : Colors.transparent),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 24, color: isMall ? Colors.grey[700] : Colors.black),
                          const SizedBox(height: 4),
                          Text('เพิ่มไปยังรถเข็น', style: TextStyle(fontSize: 10, color: isMall ? Colors.grey[700] : Colors.black)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.push(
                          '/checkout',
                          extra: {
                            'productId': product.id,
                            'productName': product.name,
                            'productImage': product.imageUrls.isNotEmpty ? product.imageUrls[0] : null,
                            'productPrice': product.price,
                            'quantity': _quantity,
                            'variant': isMall ? _selectedVariant : null,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isMall ? Colors.red : const Color(0xFFFF6B35),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('ซื้อโดยใช้โค้ด', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                          Text('฿${product.price.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVariant = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? const Color(0xFF26C6DA) : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
          color: isSelected ? const Color(0xFFE0F7FA) : Colors.white,
        ),
        child: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? const Color(0xFF26C6DA) : Colors.black)),
      ),
    );
  }

  Widget _buildVoucherTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11, color: Colors.red)),
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      ],
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, size: 20, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review.rating ? Icons.star : Icons.star_border,
                          size: 14,
                          color: Colors.orange,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Text('มีประโยชน์ (${review.helpful})', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(width: 4),
              const Icon(Icons.thumb_up_outlined, size: 14, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          if (review.variant != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('ตัวเลือกสินค้า: ${review.variant}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          if (review.color != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('สี: ${review.color}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          const SizedBox(height: 8),
          Text(review.comment, style: const TextStyle(fontSize: 14, height: 1.5)),
          if (review.imageUrls.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.imageUrls.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Show fullscreen image
                    },
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(review.imageUrls[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMallShopInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Mall',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Shopee Mall Official Store',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('ดูร้านค้า', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _ShopStat(label: 'ให้คะแนน', value: '4.9'),
            _ShopStat(label: 'รายการสินค้า', value: '150'),
            _ShopStat(label: 'การตอบกลับแชท', value: '100%'),
          ],
        ),
      ],
    );
  }

  Widget _buildRegularShopInfo() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.emoji_emotions, size: 40),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('😊 wopric • Health & Beauty ❤️', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('เข้าสู่ระบบล่าสุดเมื่อ 4 นาที ที่ผ่านมา', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text('ดูร้านค้า', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

class _ShopStat extends StatelessWidget {
  final String label;
  final String value;

  const _ShopStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}