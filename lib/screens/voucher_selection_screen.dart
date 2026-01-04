import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VoucherSelectionScreen extends StatefulWidget {
  const VoucherSelectionScreen({super.key});

  @override
  State<VoucherSelectionScreen> createState() => _VoucherSelectionScreenState();
}

class _VoucherSelectionScreenState extends State<VoucherSelectionScreen> {
  String? _selectedVoucher;

  final List<Map<String, dynamic>> _vouchers = [
    {
      'id': 'voucher1',
      'type': 'ได้ส่งฟรี',
      'title': 'ได้ส่งฟรี',
      'badge': 'Supermarket',
      'conditions': 'ขั้นต่ำ ฿0 | 7 พ.ค. สิ้นสุดเดือนสินค้า',
      'expiry': 'ใช้ได้ถึง: 23.03.2022',
      'available': true,
    },
    {
      'id': 'voucher2',
      'type': 'ส่วนลด 15%',
      'title': 'ส่วนลด 15%',
      'badge': 'SPayLater',
      'conditions': 'ขั้นต่ำ ฿0 ลดสูงสุด ฿150',
      'subConditions': '[SPayLater]',
      'expiry': 'ใช้ได้ถึง: 28.03.2022',
      'available': true,
    },
  ];

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
          'เลือกโค้ดส่วนลดของ Shopee',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'เพิ่มโค้ดส่วนลดของ Shopee',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'ตกลง',
                    style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Voucher List Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                Text(
                  'ได้ส่งฟรี',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          // Vouchers
          Expanded(
            child: ListView.builder(
              itemCount: _vouchers.length,
              itemBuilder: (context, index) {
                final voucher = _vouchers[index];
                final isSelected = _selectedVoucher == voucher['id'];

                return Container(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: voucher['available']
                        ? () {
                            setState(() {
                              _selectedVoucher = voucher['id'];
                            });
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Voucher Icon
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: voucher['badge'] == 'SPayLater' 
                                  ? Colors.orange[100] 
                                  : Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.confirmation_number,
                                color: voucher['badge'] == 'SPayLater' 
                                    ? Colors.orange 
                                    : Colors.blue,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Voucher Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Badge
                                if (voucher['badge'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: voucher['badge'] == 'SPayLater' 
                                          ? Colors.orange 
                                          : Colors.blue,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Text(
                                      voucher['badge'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 6),

                                // Title
                                Text(
                                  voucher['title'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // Conditions
                                Text(
                                  voucher['conditions'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),

                                // Sub Conditions
                                if (voucher['subConditions'] != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    voucher['subConditions'],
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 6),

                                // Expiry
                                Text(
                                  voucher['expiry'],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Selection Indicator
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? Colors.red : Colors.grey[400]!,
                                width: 2,
                              ),
                              color: isSelected ? Colors.red : Colors.transparent,
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Footer Note
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ใช้หมายรหัสใช้โค้ดส่งฟรีกับส่วนตําจะรวิวกรณีใช้',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, thickness: 1),
                const SizedBox(height: 12),
                const Text(
                  'โค้ดส่วนลดและเคด็ Coins Cashback',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  '* แล้วใช้โค้ดส่วนหมายที่คุณเก็บมาค้าและใช้ได้มาตำจัดมีเมืนนี้ได้',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Bottom Button
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
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop(_selectedVoucher);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'ตกลง',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}