import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends StatefulWidget {
  // สำหรับซื้อชิ้นเดียว (Buy Now)
  final String? productId;
  final String? productName;
  final String? productImage;
  final double? productPrice;
  final int? quantity;

  // สำหรับซื้อหลายชิ้นจาก cart
  final List<dynamic>? items;
  final double? cartTotalPrice;

  const CheckoutScreen({
    super.key,
    this.productId,
    this.productName,
    this.productImage,
    this.productPrice,
    this.quantity,
    this.items,
    this.cartTotalPrice,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _paymentMethod = 'Mobile Banking';
  String _paymentDetail = 'K PLUS';
  double _shippingFee = 45.00;
  String _deliveryMethod = 'Standard Delivery - ส่งตรงมาถึงในประเทศ';
  String _deliveryDate = 'จะได้รับ ในวันที่ 20 มี.ค. - 22 มี.ค.';

  // คำนวณจาก cart หรือสินค้าชิ้นเดียว
  double get _subtotal {
    if (widget.items != null && widget.items!.isNotEmpty) {
      return widget.items!.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    }
    return (widget.productPrice ?? 65) * (widget.quantity ?? 1);
  }

  int get _totalQuantity {
    if (widget.items != null && widget.items!.isNotEmpty) {
      return widget.items!.fold(0, (sum, item) => sum + item.quantity as int);
    }
    return widget.quantity ?? 1;
  }

  double get _total => _subtotal + _shippingFee;

  // ตรวจสอบว่าเป็นการซื้อจาก cart หรือไม่
  bool get _isFromCart => widget.items != null && widget.items!.isNotEmpty;

  // สร้างรายละเอียดสินค้าสำหรับส่งต่อ
  List<Map<String, dynamic>> get _orderItems {
    if (_isFromCart) {
      return widget.items!.map((item) => {
        'name': item.name,
        'price': item.price,
        'quantity': item.quantity,
        'imageUrl': item.imageUrl,
        'variant': item.variant,
      }).toList();
    } else {
      return [
        {
          'name': widget.productName ?? 'Welcare หน้ากากอนามัย Mask Black Edition...',
          'price': widget.productPrice ?? 65,
          'quantity': widget.quantity ?? 1,
          'imageUrl': widget.productImage,
          'variant': null,
        }
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'ทำการสั่งซื้อ',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Address Section
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, color: Colors.red, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ที่อยู่สำหรับจัดส่ง',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'น.ส. ชุติมาภรณ์ ศรีสมบูญ | (+66) 86 353 5581',
                              style: TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'บ้านเลขที่ 6 หมู่ 1 ตำบลหาดท้ายเหมือง\nอำเภอสำนักพร้าน, จังหวัดชลบุรี, 73110',
                              style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Shop Section
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Text(
                          'Shopee Mall',
                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isFromCart && widget.items!.first.shopName != null 
                            ? widget.items!.first.shopName 
                            : 'Welcare Thailand',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

                // Products List (จาก cart หรือชิ้นเดียว)
                if (_isFromCart)
                  ...widget.items!.map((item) => _buildProductItem(
                    imageUrl: item.imageUrl,
                    name: item.name,
                    variant: item.variant,
                    price: item.price,
                    quantity: item.quantity,
                  ))
                else
                  _buildProductItem(
                    imageUrl: widget.productImage,
                    name: widget.productName ?? 'Welcare หน้ากากอนามัย Mask Black Edition...',
                    variant: null,
                    price: widget.productPrice ?? 65,
                    quantity: widget.quantity ?? 1,
                  ),

                // Voucher Selection
                Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 1),
                  child: InkWell(
                    onTap: () {
                      context.push('/voucher-selection');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.confirmation_number_outlined, color: Colors.grey[700], size: 20),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'เลือกโค้ดส่วนลดของ Shopee',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),

                // Delivery Option
                Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(top: 1),
                  child: InkWell(
                    onTap: () async {
                      final result = await context.push('/shipping-selection');
                      if (result != null && result is Map) {
                        setState(() {
                          _deliveryMethod = result['method'];
                          _shippingFee = result['fee'];
                          _deliveryDate = result['date'];
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ตัวเลือกการจัดส่ง',
                                style: TextStyle(fontSize: 13, color: Color(0xFF26C6DA)),
                              ),
                              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _deliveryMethod,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              Text(
                                '฿${_shippingFee.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _deliveryDate,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Message to Shop
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Text(
                        'หมายเหตุ:',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'ฝากถ้วยหมายเหตุสำหรับคำสั่งซื้อหลายรายการบูรณ์',
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 1),

                // Order Summary
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryRow(
                        'ค่าสั่งซื้อทั้งหมด ($_totalQuantity ชิ้น):',
                        '฿${_total.toStringAsFixed(0)}',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Payment Method - Voucher
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          context.push('/voucher-selection');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Icon(Icons.confirmation_number, color: Colors.grey[700], size: 20),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'ใช้คส่วนลดของ Shopee',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              const Text(
                                'เลือกโค้ดส่วนลด',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1, thickness: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Icon(Icons.emoji_emotions_outlined, color: Colors.grey[700], size: 20),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'ไม่สามารถใช้ Shopee Coins ในคำสั่งซื้อ',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Payment Methods
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          final result = await context.push('/payment-method');
                          if (result != null && result is Map) {
                            setState(() {
                              _paymentMethod = result['method'];
                              _paymentDetail = result['detail'] ?? '';
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Icon(Icons.money, color: Colors.grey[700], size: 20),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'วิธีการชำระเงิน',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ),
                              Text(
                                _paymentDetail.isNotEmpty ? '$_paymentMethod [$_paymentDetail]' : _paymentMethod,
                                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.amber[50],
                        padding: const EdgeInsets.all(12),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 11, color: Colors.orange[800], height: 1.4),
                            children: const [
                              TextSpan(text: 'ใช้ '),
                              TextSpan(
                                text: 'ShopeePay/SPayLater',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: ' เพื่อ '),
                              TextSpan(
                                text: 'ใช้หมายเหตุชำระเงินได้อย่างรวดเร็ว',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Price Details
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildDetailRow('รวมการสั่งซื้อ', '฿${_subtotal.toStringAsFixed(0)}'),
                      const SizedBox(height: 8),
                      _buildDetailRow('การจัดส่ง', '฿${_shippingFee.toStringAsFixed(0)}'),
                      const SizedBox(height: 12),
                      const Divider(height: 1, thickness: 1),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        'ยอดชำระเงินทั้งหมด',
                        '฿${_total.toStringAsFixed(0)}',
                        isBold: true,
                        priceColor: Colors.red,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),

          // Bottom Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ยอดชำระเงินทั้งหมด',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '฿${_total.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // ไปหน้าชำระเงิน
                        context.push(
                          '/payment',
                          extra: {
                            'totalAmount': _total,
                            'quantity': _totalQuantity,
                            'items': _orderItems,
                            'paymentMethod': _paymentMethod,
                            'paymentDetail': _paymentDetail,
                            'shippingFee': _shippingFee,
                            'deliveryMethod': _deliveryMethod,
                            'deliveryDate': _deliveryDate,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'สั่งสินค้า',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem({
    String? imageUrl,
    required String name,
    String? variant,
    required double price,
    required int quantity,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image, size: 40, color: Colors.grey);
                      },
                    )
                  : const Icon(Icons.image, size: 40, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (variant != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '# $variant',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '฿${price.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                    Text(
                      'x$quantity',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        Text(value, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, Color? priceColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: priceColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}