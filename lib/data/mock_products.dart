class Review {
  final String username;
  final double rating;
  final String comment;
  final String? variant;
  final String? color;
  final List<String> imageUrls;
  final int helpful;
  final String date;

  Review({
    required this.username,
    required this.rating,
    required this.comment,
    this.variant,
    this.color,
    this.imageUrls = const [],
    this.helpful = 0,
    required this.date,
  });
}

class MockProduct {
  final String id;
  final String name;
  final double price;
  final double? originalPrice;
  final List<String> imageUrls;
  final double rating;
  final int reviews;
  final int sold;
  final String description;
  final bool isTop;
  final String category;
  final List<Review> reviewsList;

  MockProduct({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.imageUrls,
    required this.rating,
    required this.reviews,
    required this.sold,
    required this.description,
    this.isTop = false,
    required this.category,
    this.reviewsList = const [],
  });

  int get discount {
    if (originalPrice == null) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }
}

final Map<String, MockProduct> mockProducts = {
  'flash_0': MockProduct(
    id: 'flash_0',
    name: 'เครื่องชงกาแฟ เอสเปรสโซ่ แรงดัน 20 บาร์',
    price: 1159,
    originalPrice: 1547,
    imageUrls: [
      'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=800',
      'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
      'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800',
    ],
    rating: 4.8,
    reviews: 2341,
    sold: 5234,
    description: 'เครื่องชงกาแฟอัตโนมัติ ระบบแรงดัน 20 บาร์ ชงกาแฟได้เหมือนร้าน พร้อมฟองนมนุ่มละเอียด ใช้งานง่าย ทำความสะอาดสะดวก มีถังน้ำขนาด 1.5 ลิตร',
    category: 'flash_sale',
    reviewsList: [
      Review(
        username: 'coffeelover88',
        rating: 5,
        comment: 'ชงกาแฟอร่อยมากค่ะ ราคานี้คุ้มมาก ใช้ง่าย',
        imageUrls: ['https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=400'],
        helpful: 45,
        date: '2025-09-15',
      ),
      Review(
        username: 'barista_pro',
        rating: 4,
        comment: 'ดีครับ แต่ต้องปรับความเข้าใจนิดหน่อย',
        helpful: 23,
        date: '2025-09-20',
      ),
    ],
  ),
  'flash_1': MockProduct(
    id: 'flash_1',
    name: 'เครื่องปั่นสมูทตี้ พกพา USB ชาร์จได้',
    price: 299,
    originalPrice: 499,
    imageUrls: [
      'https://images.unsplash.com/photo-1570831739435-6601aa3fa4fb?w=800',
      'https://images.unsplash.com/photo-1622597467836-f3285f2131b8?w=800',
      'https://images.unsplash.com/photo-1505938088051-4ab5ba6e1b0c?w=800',
    ],
    rating: 4.9,
    reviews: 1872,
    sold: 3156,
    description: 'เครื่องปั่นพกพา ชาร์จ USB ปั่นผลไม้ได้ทุกที่ ความจุ 380ml มีดสแตนเลส 304 ปั่นนุ่มละเอียด เหมาะกับคนรักสุขภาพ',
    category: 'flash_sale',
    reviewsList: [
      Review(
        username: 'healthylife',
        rating: 5,
        comment: 'พกพาสะดวกมาก ปั่นนุ่ม เสียงไม่ดัง',
        imageUrls: ['https://images.unsplash.com/photo-1570831739435-6601aa3fa4fb?w=400'],
        helpful: 67,
        date: '2025-09-10',
      ),
    ],
  ),
  'flash_2': MockProduct(
    id: 'flash_2',
    name: 'หม้อทอดไร้น้ำมัน ดิจิตอล 5.5L',
    price: 2999,
    originalPrice: 3528,
    imageUrls: [
      'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=800',
      'https://images.unsplash.com/photo-1600891964092-4316c288032e?w=800',
      'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?w=800',
    ],
    rating: 4.7,
    reviews: 3421,
    sold: 8234,
    description: 'Air Fryer ความจุ 5.5 ลิตร หน้าจอดิจิตอล ปรับอุหภูมิ 80-200°C ทอดได้โดยไม่ต้องใช้น้ำมัน สุขภาพดี ประหยัดพลังงาน',
    category: 'flash_sale',
    reviewsList: [
      Review(
        username: 'cookinglove',
        rating: 5,
        comment: 'ทอดกรอบดี ไม่ต้องใช้น้ำมัน ครอบครัวชอบมาก',
        helpful: 89,
        date: '2025-09-18',
      ),
    ],
  ),
  'food_0': MockProduct(
    id: 'food_0',
    name: 'KFC (โลตัส สามพราว)',
    price: 199,
    imageUrls: [
      'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=800',
      'https://images.unsplash.com/photo-1562059392-096320bccc7e?w=800',
      'https://images.unsplash.com/photo-1598511757337-fe2cafc31ba0?w=800',
    ],
    rating: 4.6,
    reviews: 8234,
    sold: 12000,
    description: 'ไก่ทอดสูตรเด็ด พร้อมเครื่องเคียงครบครัน จัดส่งฟรี ร้อนกรอบถึงบ้าน',
    category: 'food',
    reviewsList: [
      Review(
        username: 'foodie_th',
        rating: 5,
        comment: 'อร่อยมาก ส่งเร็ว ยังร้อนอยู่',
        helpful: 34,
        date: '2025-09-22',
      ),
    ],
  ),
  'food_1': MockProduct(
    id: 'food_1',
    name: 'The Pizza Company (ต่อนใหญ่)',
    price: 299,
    imageUrls: [
      'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
      'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800',
      'https://images.unsplash.com/photo-1593560708920-61dd98c46a4e?w=800',
    ],
    rating: 4.7,
    reviews: 6543,
    sold: 9876,
    description: 'พิซซ่าหน้าพิเศษ ชีสเยอะ อร่อยทุกคำ ส่งตรงถึงบ้าน',
    category: 'food',
    reviewsList: [],
  ),
  'food_2': MockProduct(
    id: 'food_2',
    name: 'MR.D.I.Y. (เชียงใหม่)',
    price: 149,
    imageUrls: [
      'https://images.unsplash.com/photo-1581783898377-1c85bf937427?w=800',
      'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800',
    ],
    rating: 4.5,
    reviews: 4321,
    sold: 7654,
    description: 'อุปกรณ์ DIY และของใช้ในบ้าน ครบครัน ราคาประหยัด',
    category: 'food',
    reviewsList: [],
  ),
  'top_0': MockProduct(
    id: 'top_0',
    name: 'ครีมบำรุงผิวหน้า สูตรเข้มข้น 50ml',
    price: 359,
    originalPrice: 499,
    imageUrls: [
      'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=800',
      'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=800',
      'https://images.unsplash.com/photo-1571875257727-256c39da42af?w=800',
    ],
    rating: 4.9,
    reviews: 5432,
    sold: 7890,
    description: 'ครีมบำรุงผิวหน้า ลดริ้วรอย เพิ่มความชุ่มชื้น ผิวเนียนนุ่ม กระจ่างใส เห็นผลภายใน 7 วัน',
    isTop: true,
    category: 'beauty',
    reviewsList: [
      Review(
        username: 'beautyguru',
        rating: 5,
        comment: 'ครีมดีมาก ผิวชุ่มชื้น ใช้แล้วชอบ',
        imageUrls: ['https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=400'],
        helpful: 78,
        date: '2025-09-14',
      ),
    ],
  ),
  'top_1': MockProduct(
    id: 'top_1',
    name: 'ฟิล์มกระจกกันรอยมือถือ ฟิล์มไฮโดรเจล HD',
    price: 89,
    originalPrice: 149,
    imageUrls: [
      'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=800',
      'https://images.unsplash.com/photo-1616348436168-de43ad0db179?w=800',
      'https://images.unsplash.com/photo-1622782914767-404fb9ab3f57?w=800',
    ],
    rating: 4.8,
    reviews: 11678,
    sold: 116000,
    description: 'ฟิล์มไฮโดรเจล HD ใส ไม่มีขอบดำ ป้องกันรอยขีดข่วน กันแรงกระแทก ติดง่าย ไม่มีฟองอากาศ',
    isTop: true,
    category: 'mobile',
    reviewsList: [],
  ),
  'top_2': MockProduct(
    id: 'top_2',
    name: 'เคส iPhone 15 Pro Max ซิลิโคน กันกระแทก',
    price: 199,
    originalPrice: 399,
    imageUrls: [
      'https://images.unsplash.com/photo-1601593346740-925612772716?w=800',
      'https://images.unsplash.com/photo-1556656793-08538906a9f8?w=800',
      'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=800',
    ],
    rating: 4.9,
    reviews: 8765,
    sold: 56000,
    description: 'เคสซิลิโคนพรีเมี่ยม นุ่มมือ กันกระแทกได้ดี มีขอบกันหน้าจอ มีหลายสี สวยหรู',
    isTop: true,
    category: 'mobile',
    reviewsList: [],
  ),
  'mall_0': MockProduct(
    id: 'mall_0',
    name: 'เจลล้างมือแอลกอฮอล์ 200ml ฆ่าเชื้อโรค 99.9%',
    price: 59,
    originalPrice: 118,
    imageUrls: [
      'https://images.unsplash.com/photo-1584483766114-2cea6facdf57?w=800',
      'https://images.unsplash.com/photo-1585435557343-3b092031a831?w=800',
      'https://images.unsplash.com/photo-1598885159329-6e0b8e5c6f4e?w=800',
    ],
    rating: 4.8,
    reviews: 3456,
    sold: 23000,
    description: 'เจลล้างมือแอลกอฮอล์ 70% ฆ่าเชื้อโรค 99.9% ไม่ต้องล้างออก ไม่เหนียวเหนอะหนะ สะอาดปลอดภัย',
    category: 'health',
    reviewsList: [
      Review(
        username: 'cleanliving',
        rating: 5,
        comment: 'ใช้ดีค่ะ ไม่เหนอะหนะ กลิ่นหอม',
        helpful: 56,
        date: '2025-09-12',
      ),
    ],
  ),
  'mall_1': MockProduct(
    id: 'mall_1',
    name: 'วิตามินซี 1000mg บำรุงผิวพรรณ 30 เม็ด',
    price: 299,
    originalPrice: 499,
    imageUrls: [
      'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=800',
      'https://images.unsplash.com/photo-1550572017-4c4f2b286e91?w=800',
      'https://images.unsplash.com/photo-1607619662634-3ac55ec1b0b7?w=800',
    ],
    rating: 4.7,
    reviews: 2345,
    sold: 12000,
    description: 'วิตามินซีเข้มข้น 1000mg บำรุงผิวขาวใส เสริมภูมิคุ้มกัน ทานง่าย ไม่ส่งผลข้างเคียง',
    category: 'health',
    reviewsList: [
      Review(
        username: 'healthyway',
        rating: 5,
        comment: 'ทานแล้วผิวดีขึ้น ไม่ป่วยบ่อย แนะนำเลย',
        helpful: 92,
        date: '2025-09-16',
      ),
    ],
  ),
  'mall_2': MockProduct(
    id: 'mall_2',
    name: 'น้ำดื่มบริสุทธิ์ 600ml แพ็ค 6 ขวด',
    price: 45,
    originalPrice: 60,
    imageUrls: [
      'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=800',
      'https://images.unsplash.com/photo-1523362628745-0c100150b504?w=800',
      'https://images.unsplash.com/photo-1550599452-3d45a2b8e8fb?w=800',
    ],
    rating: 4.6,
    reviews: 1234,
    sold: 45000,
    description: 'น้ำดื่มบริสุทธิ์ ผลิตจากระบบ RO คุณภาพดี ราคาประหยัด ปลอดภัยสำหรับทุกคนในครอบครัว',
    category: 'health',
    reviewsList: [],
  ),
};

List<MockProduct> getProductGridItems() {
  List<MockProduct> products = [];
  final productNames = [
    'เสื้อยืดคอกลม Cotton 100%',
    'กางเกงยีนส์ขายาว ทรงสลิม',
    'รองเท้าผ้าใบ สีขาว คลาสสิค',
    'กระเป๋าสะพายหนัง PU',
    'หูฟัง Bluetooth ไร้สาย',
    'Power Bank 20000mAh',
    'สายชาร์จ Type-C ยาว 2m',
    'แก้วน้ำสแตนเลส 500ml',
    'หมอนหนุน เมมโมรี่โฟม',
    'ผ้าห่มนุ่ม ขนาด 60x80 นิ้ว',
  ];
  
  for (int i = 0; i < 20; i++) {
    products.add(MockProduct(
      id: 'product_$i',
      name: i < productNames.length ? productNames[i] : 'สินค้าทั่วไป ${i + 1}',
      price: 65 + (i * 10).toDouble(),
      originalPrice: i < 6 ? 99 + (i * 15).toDouble() : null,
      imageUrls: [
        'https://images.unsplash.com/photo-${1500000000000 + i}?w=800',
      ],
      rating: 4.5 + (i % 5) * 0.1,
      reviews: 500 + (i * 100),
      sold: 30000 + (i * 1000),
      description: 'สินค้าคุณภาพดี ราคาเหมาะสม ส่งฟรีทั่วประเทศ มีรับประกันสินค้า',
      isTop: i < 6,
      category: 'general',
      reviewsList: [],
    ));
  }
  return products;
}

MockProduct? getProductById(String id) {
  if (mockProducts.containsKey(id)) {
    return mockProducts[id];
  }
  
  final gridProducts = getProductGridItems();
  try {
    return gridProducts.firstWhere((p) => p.id == id);
  } catch (e) {
    return null;
  }
}