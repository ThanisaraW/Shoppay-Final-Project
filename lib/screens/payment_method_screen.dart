import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedPayment = 'mobile_banking';
  bool _showSpayLaterDetails = false;
  bool _showCreditCardList = false;
  bool _showWalletList = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'ช่องทางการชำระเงิน',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // ShopeePay Section
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Center(
                              child: Text('S', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text('ShopeePay', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                          const Spacer(),
                          Icon(Icons.chevron_right, color: Colors.grey[400]),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 1),

                // SPayLater Section
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showSpayLaterDetails = !_showSpayLaterDetails;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.credit_card, color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('SPayLater', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 2),
                                    Text('ซื้อก่อน จ่ายทีหลัง เลือกผ่อนตามสบาย ไม่ต้องดาวน์', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('เปิดใช้งาน', style: TextStyle(fontSize: 11, color: Colors.red)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_showSpayLaterDetails) ...[
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.local_offer, color: Colors.white, size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text('ส่งฟรี', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              _buildInstallmentOption('ซื้อปล่อยจ่ายทีหลัง', '฿846.00', 'ลดเพิ่ม 70% สูงสุด 50 บาท', 'ดอกเบี้ย 0%'),
                              const SizedBox(height: 12),
                              _buildInstallmentOption('ผ่อนชำระ 2 เดือน', '฿423.00/เดือน', 'ลดเพิ่ม 70% สูงสุด 50 บาท', 'ดอกเบี้ย 0%', strikethrough: '฿436.24'),
                              const SizedBox(height: 12),
                              _buildInstallmentOption('ผ่อนชำระ 3 เดือน', '฿282.00/เดือน', 'ลดเพิ่ม 70% สูงสุด 50 บาท', 'ดอกเบี้ย 0%', strikethrough: '฿293.81'),
                              const SizedBox(height: 12),
                              _buildInstallmentOption('ผ่อนชำระ 5 เดือน', '฿169.20/เดือน', 'ลดเพิ่ม 70% สูงสุด 50 บาท', 'ดอกเบี้ย 0%', strikethrough: '฿179.90'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 1),

                // Credit/Debit Card Section
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showCreditCardList = !_showCreditCardList;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.blue[700],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(Icons.credit_card, color: Colors.white, size: 18),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text('บัตรเครดิต/บัตรเดบิต', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                              ),
                              Icon(_showCreditCardList ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      if (_showCreditCardList)
                        Container(
                          padding: const EdgeInsets.only(left: 60, right: 16, bottom: 16),
                          child: Column(
                            children: [
                              _buildBadge('ส่งฟรี'),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.add, color: Colors.grey, size: 20),
                                  const SizedBox(width: 8),
                                  const Text('ผูกบัญชีธนาคาร', style: TextStyle(fontSize: 13, color: Colors.grey)),
                                  const Spacer(),
                                  Icon(Icons.shield_outlined, color: Colors.grey[400], size: 20),
                                  const SizedBox(width: 4),
                                  Icon(Icons.check_circle_outline, color: Colors.grey[400], size: 20),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Other Payment Methods Header
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: const Text('ช่องทางการชำระเงินอื่น', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),

                const SizedBox(height: 1),

                // QR Payment
                Container(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPayment = 'qr';
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.teal[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.qr_code_scanner, color: Colors.teal, size: 18),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text('QR พร้อมเพย์', style: TextStyle(fontSize: 15)),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedPayment == 'qr' ? Colors.red : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: _selectedPayment == 'qr'
                                ? Center(
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (_selectedPayment == 'qr')
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 60, right: 16, bottom: 16),
                    child: _buildBadge('ส่งฟรี'),
                  ),

                const SizedBox(height: 1),

                // COD
                Container(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPayment = 'cod';
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text('COD', style: TextStyle(color: Colors.orange[800], fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text('เก็บเงินปลายทาง', style: TextStyle(fontSize: 15)),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedPayment == 'cod' ? Colors.red : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: _selectedPayment == 'cod'
                                ? Center(
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                if (_selectedPayment == 'cod')
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 60, right: 16, bottom: 16),
                    child: _buildBadge('ส่งฟรี'),
                  ),

                const SizedBox(height: 1),

                // Mobile Banking
                Container(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPayment = 'mobile_banking';
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Center(
                              child: Text('S', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Mobile Banking', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                SizedBox(height: 2),
                                Text('K PLUS', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedPayment == 'mobile_banking' ? Colors.red : Colors.transparent,
                              border: Border.all(
                                color: _selectedPayment == 'mobile_banking' ? Colors.red : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: _selectedPayment == 'mobile_banking'
                                ? const Icon(Icons.check, size: 16, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),

                if (_selectedPayment == 'mobile_banking')
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 60, right: 16, bottom: 16),
                    child: _buildBadge('ส่งฟรี'),
                  ),

                const SizedBox(height: 1),

                // Counter Service
                Container(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _showWalletList = !_showWalletList;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.store, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text('คะแนนบัตรเครดิต', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                          ),
                          Icon(_showWalletList ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),

                if (_showWalletList)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 60, right: 16, bottom: 16),
                    child: _buildBadge('ส่งฟรี'),
                  ),

                const SizedBox(height: 80),
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
                      // ส่งข้อมูลวิธีการชำระเงินที่เลือกกลับไป
                      String methodName = '';
                      String methodDetail = '';
                      
                      switch (_selectedPayment) {
                        case 'mobile_banking':
                          methodName = 'Mobile Banking';
                          methodDetail = 'K PLUS';
                          break;
                        case 'qr':
                          methodName = 'QR พร้อมเพย์';
                          methodDetail = '';
                          break;
                        case 'cod':
                          methodName = 'เก็บเงินปลายทาง';
                          methodDetail = '';
                          break;
                        default:
                          methodName = 'Mobile Banking';
                          methodDetail = 'K PLUS';
                      }
                      
                      context.pop({
                        'method': methodName,
                        'detail': methodDetail,
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

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_offer, color: Colors.red, size: 12),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildInstallmentOption(String title, String price, String discount, String interest, {String? strikethrough}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                if (strikethrough != null)
                  Text(
                    strikethrough,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500], decoration: TextDecoration.lineThrough),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(discount, style: const TextStyle(fontSize: 10, color: Colors.red)),
            ),
            Text(interest, style: TextStyle(fontSize: 11, color: Colors.red[700])),
          ],
        ),
      ],
    );
  }
}