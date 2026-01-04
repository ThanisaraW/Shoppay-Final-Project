import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/mock_products.dart';

class MallScreen extends StatelessWidget {
  const MallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ดึงเฉพาะสินค้า Mall (flash_sale, health, beauty)
    final mallProducts = mockProducts.values.where((p) => 
      p.category == 'flash_sale' || p.category == 'health' || p.category == 'beauty'
    ).toList();

    return Scaffold(
      backgroundColor: Colors.red[700],
      appBar: AppBar(
        backgroundColor: Colors.red[700],
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            readOnly: true,
            onTap: () => context.push('/search'),
            decoration: const InputDecoration(
              hintText: 'Shopee Mall',
              hintStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            onPressed: () => context.push('/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // Banner 1 - ด้านบน
          Image.asset(
            'assets/images/Mall/banner1.png',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange, Colors.red[700]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Shopee Mall',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Premium brands, Guaranteed quality', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Categories Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCategory('assets/icons/Mall/Shopee_Premium.png', 'Shopee\nPremium'),
                _buildCategory('assets/icons/Mall/Brand_Day_Calendar.png', 'Brand Day\nCalendar'),
                _buildCategory('assets/icons/Mall/Crazy_Deal.png', 'Crazy\nDeals'),
                _buildCategory('assets/icons/Mall/Lowest_Price.png', 'Lowest\nPrice'),
              ],
            ),
          ),
          
          // Banner 2-3 - ด้านล่าง Categories (รูปเดียวเต็มความกว้าง)
          Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/Mall/banner2-3.png',
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink[300]!, Colors.red[100]!],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('Super Brand Day\nลดสูงสุด 70%', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Product Grid Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: const [
                      Icon(Icons.local_fire_department, color: Colors.red, size: 24),
                      SizedBox(width: 8),
                      Text('MALL CRAZY DEALS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: mallProducts.length,
                  itemBuilder: (context, index) {
                    final product = mallProducts[index];
                    return _buildProductCard(context, product);
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCategory(String iconPath, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              iconPath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.shopping_bag, size: 30, color: Colors.red[700]);
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center, maxLines: 2),
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, MockProduct product) {
    final discount = product.discount;

    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      child: Image.network(
                        product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.image, size: 50, color: Colors.grey));
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Text('Mall', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('฿', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red)),
                      Text(product.price.toStringAsFixed(0), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (product.originalPrice != null) ...[
                        Text(
                          '฿${product.originalPrice!.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 10, color: Colors.grey[600], decoration: TextDecoration.lineThrough),
                        ),
                        const SizedBox(width: 4),
                      ],
                      if (discount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text('-$discount%', style: const TextStyle(fontSize: 9, color: Colors.red, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 10, color: Colors.orange),
                          const SizedBox(width: 2),
                          Text(product.rating.toString(), style: const TextStyle(fontSize: 9, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'ขายแล้ว ${(product.sold / 1000).toStringAsFixed(1)}k+',
                          style: const TextStyle(fontSize: 9, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
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