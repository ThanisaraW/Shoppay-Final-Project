import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../utils/app_theme.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedTab = 2; // 0: วิดีโอ, 1: Live, 2: สำหรับคุณ
  bool _isRewardVisible = true;
  Offset _rewardPosition = const Offset(200, 120);
  
  List<VideoPlayerController> _videoControllers = [];
  bool _controllersInitialized = false;

  final List<Map<String, dynamic>> _videos = [
    {
      'title': '#รองพื้นเนมฟิล สุดฮอตคล 15% ที่เซฟโฟ่รา Beauty Pass Exclusive #lifeatbenefit #เนมฟิล #benefitthailand #POREfessional',
      'username': '@benefitthailand',
      'hashtags': '#benefitthailand #POREfessional',
      'likes': '2.1k',
      'comments': '45',
      'isLive': false,
      'isLiked': false,
      'productName': 'Benefit Cosmetics Thailand',
      'price': '฿1,590',
      'discount': 'โค้ดลด 15%',
      'rating': '4.9',
      'sold': '8.3K',
      'rewardText': 'ดูอีก 00:08 เพื่อรับ',
      'rewardCoins': '0.01',
      'videoUrl': 'assets/videos/benefit_cosmetic.mp4',
      'location': 'SEPHORA Siam Center • Bangkok',
    },
    {
      'title': 'โปรแรงสดคุ้ม คลีนซิ่งเนื้อแอคแบคโฟมไขล่า แลกซื้อลด 50% ที่วัตสัน ช้อปเลย',
      'username': '@nivea_thailand',
      'hashtags': '#nivea #skincare',
      'likes': '3.5k',
      'comments': '89',
      'isLive': false,
      'isLiked': false,
      'productName': 'NIVEA THAILAND',
      'price': '฿129',
      'discount': 'แลกซื้อลด 50%',
      'rating': '4.8',
      'sold': '12.5K',
      'rewardText': 'ดูอีก 00:12 เพื่อรับ',
      'rewardCoins': '0.01',
      'videoUrl': 'assets/videos/Nivea.mp4',
      'location': 'Watsons Thailand',
    },
    {
      'title': 'Fresh out of the oven, and ready to take your order. Shop Lattafa Eclaire before they run out. #SoWhippedbyLattafa',
      'username': '@lattafaperfumes',
      'hashtags': '#lattafa #perfume',
      'likes': '1.8k',
      'comments': '67',
      'isLive': false,
      'isLiked': false,
      'productName': 'Lattafa Perfumes',
      'price': '฿890',
      'discount': 'โค้ดลด 10%',
      'rating': '4.9',
      'sold': '5.2K',
      'rewardText': 'ดูอีก 00:15 เพื่อรับ',
      'rewardCoins': '0.01',
      'videoUrl': 'assets/videos/Latafa.mp4',
      'location': 'Lattafa Perfumes Store',
    },
    {
      'title': 'ผมเจงสายเพื่อนชีวิตไบเดียเอามมไปทาสีเลย 😂 #ออลลบำรุงผม #เซรั่มล้อคผมตรง #เซรั่มทำตั้งล็อคผมตรง #hairoil ad',
      'username': '@realametrine',
      'hashtags': '#hairoil #haircare',
      'likes': '4.2k',
      'comments': '156',
      'isLive': false,
      'isLiked': false,
      'productName': 'realAmetrine (เอสฟิล์ม)',
      'price': '฿259',
      'discount': 'โค้ดลด 20%',
      'rating': '4.7',
      'sold': '9.8K',
      'rewardText': 'ดูอีก 00:10 เพื่อรับ',
      'rewardCoins': '0.01',
      'videoUrl': 'assets/videos/clip4.mp4',
      'location': 'Thailand',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideoControllers();
  }

  Future<void> _initializeVideoControllers() async {
    for (var video in _videos) {
      final controller = VideoPlayerController.asset(video['videoUrl']);
      await controller.initialize();
      controller.setLooping(true);
      _videoControllers.add(controller);
    }
    
    setState(() {
      _controllersInitialized = true;
    });
    
    // เล่นวิดีโอแรก
    if (_videoControllers.isNotEmpty) {
      _videoControllers[0].play();
    }
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      final currentVideo = _videos[_currentPage];
      currentVideo['isLiked'] = !(currentVideo['isLiked'] ?? false);
      if (currentVideo['isLiked']) {
        int likes = int.parse(currentVideo['likes']?.replaceAll('k', '00') ?? '0');
        currentVideo['likes'] = '${(likes / 100 + 1).toStringAsFixed(1)}k';
      } else {
        int likes = int.parse(currentVideo['likes']?.replaceAll('k', '00') ?? '0');
        currentVideo['likes'] = '${(likes / 100 - 1).toStringAsFixed(1)}k';
      }
    });
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'ความคิดเห็น',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text('ผู้ใช้ 1'),
                    subtitle: Text('สินค้าน่ารักมาก!'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShareOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('แชร์ไปที่', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShareOption(Icons.facebook, 'Facebook'),
                _buildShareOption(Icons.message, 'Line'),
                _buildShareOption(Icons.link, 'คัดลอกลิงก์'),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 32),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Content based on selected tab
          if (_selectedTab == 0) _buildVideoTab(),
          if (_selectedTab == 1) _buildLiveTab(),
          if (_selectedTab == 2) _buildForYouTab(),
          
          // Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.person_outline, color: Colors.white, size: 28),
                  const SizedBox(width: 16),
                  const Icon(Icons.search, color: Colors.white, size: 28),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
          ),
          
          // Tab Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 70),
              child: SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: _buildTab('วิดีโอ', 0),
                    ),
                    const SizedBox(width: 32),
                    GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: _buildTab('Live', 1),
                    ),
                    const SizedBox(width: 32),
                    GestureDetector(
                      onTap: () => setState(() => _selectedTab = 2),
                      child: _buildTab('สำหรับคุณ', 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Draggable Reward Badge (only show for "สำหรับคุณ" tab)
          if (_isRewardVisible && _selectedTab == 2)
            Positioned(
              left: _rewardPosition.dx,
              top: _rewardPosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _rewardPosition = Offset(
                      _rewardPosition.dx + details.delta.dx,
                      _rewardPosition.dy + details.delta.dy,
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange[700]!, Colors.red[700]!],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.yellow[700],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'REWARD',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isRewardVisible = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _videos[_currentPage]['rewardText'] ?? 'ดูอีก 00:08 เพื่อรับ',
                        style: const TextStyle(color: Colors.white, fontSize: 9),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.yellow,
                              shape: BoxShape.circle,
                            ),
                            child: const Text(
                              'S',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _videos[_currentPage]['rewardCoins'] ?? '0.01',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('รับรางวัลแล้ว!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red[900],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'รับ',
                                style: TextStyle(color: Colors.white, fontSize: 11),
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildTab(String text, int index) {
    bool isSelected = index == _selectedTab;
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 40,
            color: Colors.white,
          ),
      ],
    );
  }

  Widget _buildVideoTab() {
    return _buildVideoPageView();
  }

  Widget _buildLiveTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam_off_outlined,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'ไม่มี Live ในขณะนี้',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'กลับมาดูใหม่ภายหลัง',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForYouTab() {
    return _buildVideoPageView();
  }

  Widget _buildVideoPageView() {
    if (!_controllersInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return GestureDetector(
      onTap: () {
        if (_videoControllers.isNotEmpty && _currentPage < _videoControllers.length) {
          final controller = _videoControllers[_currentPage];
          setState(() {
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              controller.play();
            }
          });
        }
      },
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _videos.length,
        onPageChanged: (index) {
          // หยุดวิดีโอเก่า
          if (_currentPage < _videoControllers.length) {
            _videoControllers[_currentPage].pause();
          }
          
          setState(() => _currentPage = index);
          
          // เล่นวิดีโอใหม่
          if (index < _videoControllers.length) {
            _videoControllers[index].play();
          }
        },
        itemBuilder: (context, index) {
          return _buildVideoPage(_videos[index], index);
        },
      ),
    );
  }

  Widget _buildVideoPage(Map<String, dynamic> video, int index) {
    final bool hasController = index < _videoControllers.length;
    final VideoPlayerController? controller = hasController ? _videoControllers[index] : null;
    
    return Stack(
      children: [
        // Video player
        if (controller != null && controller.value.isInitialized)
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,
                child: VideoPlayer(controller),
              ),
            ),
          )
        else
          Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),

        // Pause indicator
        if (controller != null && !controller.value.isPlaying)
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.pause, color: Colors.white, size: 60),
            ),
          ),
        
        // Video info overlay
        Positioned(
          bottom: 100,
          left: 16,
          right: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                video['username'] ?? '@user',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                video['title'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                video['hashtags'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
              if (video['location'] != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        video['location'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        
        // Right side actions
        Positioned(
          right: 16,
          bottom: 220,
          child: Column(
            children: [
              // Profile with follow button
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ติดตามแล้ว!'), duration: Duration(seconds: 1)),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Like button
              GestureDetector(
                onTap: _toggleLike,
                child: _buildActionButton(
                  video['isLiked'] == true ? Icons.favorite : Icons.favorite_border,
                  video['likes'] ?? '0',
                  isLiked: video['isLiked'] == true,
                ),
              ),
              const SizedBox(height: 24),
              
              // Comment button
              GestureDetector(
                onTap: _showComments,
                child: _buildActionButton(Icons.chat_bubble_outline, video['comments'] ?? '0'),
              ),
              const SizedBox(height: 24),
              
              // Share button
              GestureDetector(
                onTap: _showShareOptions,
                child: _buildActionButton(Icons.share, 'แชร์'),
              ),
              const SizedBox(height: 24),
              
              // Music button
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('เปิดเพลง'), duration: Duration(seconds: 1)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.music_note, color: Colors.white, size: 24),
                ),
              ),
            ],
          ),
        ),
        
        // Product banner at bottom
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('เปิดหน้าสินค้า'), duration: Duration(seconds: 1)),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.shopping_bag, color: Colors.red, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${video['discount'] ?? ''} | ${video['productName'] ?? ''}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, {bool isLiked = false}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isLiked ? Colors.red : Colors.white,
            size: 28,
          ),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ],
    );
  }
}