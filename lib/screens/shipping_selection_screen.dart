import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ShippingSelectionScreen extends StatefulWidget {
  const ShippingSelectionScreen({super.key});

  @override
  State<ShippingSelectionScreen> createState() => _ShippingSelectionScreenState();
}

class _ShippingSelectionScreenState extends State<ShippingSelectionScreen> {
  String _selectedShipping = 'standard';

  final List<Map<String, dynamic>> _shippingOptions = [
    {
      'id': 'standard',
      'name': 'Standard Delivery - ส่งตรงมาถึงในประเทศ',
      'fee': 45.00,
      'date': 'จะได้รับ ในวันที่ 20 มี.ค. - 22 มี.ค.',
      'details': 'การจัดส่งสำหรับรับประกัน โดย Shopee',
      'info': 'บริการการจัดส่งสำหรับรับประกันการสร้างสมอยู่ขั้นที่ชอบต้องธนาทีการรับสินค้าสูงขึ้น',
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
          'ตัวเลือกการจัดส่ง',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Info Banner
          Container(
            color: Colors.blue[50],
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.local_shipping, color: Colors.red[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
                      children: [
                        const TextSpan(text: 'บริการจัดส่งของกระบวนรับ โดย '),
                        TextSpan(
                          text: 'Shopee',
                          style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(
                          text: ' จะจะได้โค้ดแนำการจัดสิเคต่างหมายการจัดส่งส่งหมดดื่าได้นการจัดส่ง',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Shipping Options
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: _shippingOptions.length,
                itemBuilder: (context, index) {
                  final option = _shippingOptions[index];
                  final isSelected = _selectedShipping == option['id'];

                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedShipping = option['id'];
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Selection Radio
                              Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.red : Colors.grey[400]!,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? Center(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),

                              // Shipping Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            option['name'],
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '฿${option['fee'].toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      option['date'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      option['details'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // Additional Info
                          if (isSelected) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                option['info'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
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
                      // ส่งข้อมูลการจัดส่งที่เลือกกลับไป
                      final selected = _shippingOptions.firstWhere(
                        (option) => option['id'] == _selectedShipping,
                      );
                      
                      context.pop({
                        'method': selected['name'],
                        'fee': selected['fee'],
                        'date': selected['date'],
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      'ยืนยัน',
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