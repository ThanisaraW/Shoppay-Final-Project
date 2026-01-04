import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../utils/app_theme.dart';
import '../providers/favorites_provider.dart';
import '../providers/cart_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(currentUserProvider);

    return authState.when(
      data: (user) {
        if (user == null) {
          return _buildNotLoggedIn(context);
        }
        return _buildLoggedIn(context, ref, user);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  // Screen when not logged in
  Widget _buildNotLoggedIn(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/Profile_Setting.png',
              width: 28,
              height: 28,
              color: Colors.white,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.settings_outlined, color: Colors.white, size: 28);
              },
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Image.asset(
              'assets/icons/Profile_Cart.png',
              width: 28,
              height: 28,
              color: Colors.white,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 28);
              },
            ),
            onPressed: () => context.push('/cart'),
          ),
          IconButton(
            icon: Image.asset(
              'assets/icons/Profile_Chat.png',
              width: 28,
              height: 28,
              color: Colors.white,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 28);
              },
            ),
            onPressed: () => context.push('/chat'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 32, color: Colors.grey),
                ),
                const Spacer(),
                SizedBox(
                  width: 90,
                  height: 34,
                  child: ElevatedButton(
                    onPressed: () => context.push('/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: const Text('Log In', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 90,
                  height: 34,
                  child: OutlinedButton(
                    onPressed: () => context.push('/register'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),
          
          // Menu items
          Expanded(
            child: ListView(
              children: [
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      _buildMenuItem(
                        Icons.receipt_long_outlined,
                        'My Purchases',
                        onTap: () => context.push('/login'),
                        imagePath: 'assets/icons/My_Purchases.png',
                      ),
                      _buildMenuItem(
                        Icons.account_balance_wallet_outlined,
                        'Deduction Items',
                        onTap: () => context.push('/login'),
                        imagePath: 'assets/icons/Deduction_Items.png',
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // My Wallet Section
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/My_Wallet.png',
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.account_balance_wallet_outlined, size: 24, color: AppColors.primary);
                            },
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'My Wallet',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[900],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildWalletIconItem(
                            Icons.account_balance_wallet,
                            'ShopeePay',
                            'Instant transfer',
                            imagePath: 'assets/icons/Shoppee_Pay.png',
                          ),
                          _buildWalletIconItem(
                            Icons.monetization_on,
                            'Shopee Coins',
                            'Check in daily\nfor free coins!',
                            imagePath: 'assets/icons/Shopee_Coins.png',
                          ),
                          _buildWalletIconItem(
                            Icons.credit_card,
                            'My SPayLater',
                            'Get credit up to\n฿100,000',
                            imagePath: 'assets/icons/My_SPay_Later.png',
                          ),
                          _buildWalletIconItem(
                            Icons.confirmation_number,
                            'My Voucher',
                            'Use your\nvouchers now',
                            imagePath: 'assets/icons/My_Voucher.png',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      _buildMenuItem(Icons.card_giftcard, 'Shopee Rewards', imagePath: 'assets/icons/Shopee_Rewards.png'),
                      _buildMenuItem(
                        Icons.favorite_border,
                        'Liked Items',
                        onTap: () => context.push('/favorites'),
                        imagePath: 'assets/icons/Liked_Items.png',
                      ),
                      _buildMenuItem(Icons.history, 'Recently Viewed', imagePath: 'assets/icons/Recently_Viewed.png'),
                      _buildMenuItem(Icons.shopping_bag_outlined, 'Shop to Earn 30 Coins', imagePath: 'assets/icons/Shop_to_earn_30_coins.png'),
                      _buildMenuItem(Icons.star_border, 'My Reviews', imagePath: 'assets/icons/My_Reviewed.png'),
                      _buildMenuItem(
                        Icons.card_membership,
                        'Super Voucher Pack',
                        showNew: true,
                        imagePath: 'assets/icons/Super_Voucher_Pack.png',
                      ),
                      _buildMenuItem(Icons.settings_outlined, 'Account Settings', showDivider: false),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Screen when logged in
  Widget _buildLoggedIn(BuildContext context, WidgetRef ref, user) {
    final displayName = user.displayName ?? user.email?.split('@')[0] ?? 'User';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';
    final cartItemsCount = ref.watch(cartItemsCountProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/Profile_Setting.png',
              width: 28,
              height: 28,
              color: Colors.white,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.settings_outlined, color: Colors.white, size: 28);
              },
            ),
            onPressed: () => _showSettingsScreen(context, ref),
          ),
          Stack(
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/icons/Profile_Cart.png',
                  width: 28,
                  height: 28,
                  color: Colors.white,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 28);
                  },
                ),
                onPressed: () => context.push('/cart'),
              ),
              if (cartItemsCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      cartItemsCount > 99 ? '99+' : '$cartItemsCount',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/icons/Profile_Chat.png',
                  width: 28,
                  height: 28,
                  color: Colors.white,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 28);
                  },
                ),
                onPressed: () => context.push('/chat'),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: const Text(
                    '33',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
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
      body: ListView(
        children: [
          // Profile header
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.white,
                  backgroundImage: user.photoURL != null 
                      ? NetworkImage(user.photoURL!) 
                      : null,
                  child: user.photoURL == null 
                      ? Text(
                          initial,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Gold',
                              style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right, color: Colors.white, size: 18),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Text(
                            '18 Followers',
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                          SizedBox(width: 16),
                          Text(
                            '170 Following',
                            style: TextStyle(fontSize: 11, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // VIP Banner
          Container(
            margin: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber[700]!, Colors.amber[400]!],
              ),
            ),
            child: ListTile(
              leading: const Icon(Icons.workspace_premium, color: Colors.white, size: 36),
              title: const Text(
                'Get up to 25% discount and free shipping for orders above 0.-',
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white),
              onTap: () {},
            ),
          ),

          const SizedBox(height: 8),

          // Order Status
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Purchases',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Row(
                      children: const [
                        Text(
                          'View Purchase History',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatusIcon(Icons.payment, 'To Pay', imagePath: 'assets/icons/To_Pay.png'),
                    _buildStatusIcon(Icons.inventory_2_outlined, 'To Ship', imagePath: 'assets/icons/To_Ship.png'),
                    _buildStatusIcon(Icons.local_shipping_outlined, 'To Receive', imagePath: 'assets/icons/To_Recieve.png'),
                    _buildStatusIcon(Icons.rate_review_outlined, 'To Review', badge: 1, imagePath: 'assets/icons/To_Review.png'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 1),

          Container(
            color: Colors.white,
            child: _buildMenuItem(
              Icons.account_balance_wallet_outlined,
              'Deduction Items',
              imagePath: 'assets/icons/Deduction_Items.png',
            ),
          ),

          const SizedBox(height: 8),

          // ShopeeFood and E-Service
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildMenuItem(
                  Icons.restaurant,
                  'ShopeeFood',
                  trailing: 'Discount up to 50%',
                  imagePath: 'assets/icons/Shopee_Food.png',
                ),
                _buildMenuItem(
                  Icons.confirmation_number,
                  'E-Service / E-Voucher',
                  trailing: 'Discount ฿50',
                  showDivider: false,
                  imagePath: 'assets/icons/E-Services.png',
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // My Wallet Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/My_Wallet.png',
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.account_balance_wallet_outlined, size: 24, color: AppColors.primary);
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'My Wallet',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildWalletIconItem(Icons.payment, 'ShopeePay', '฿0.00', imagePath: 'assets/icons/Shoppee_Pay.png'),
                    _buildWalletIconItemWithBadge(
                      Icons.monetization_on,
                      'Shopee Coins',
                      'Check in to get\nShopee Coins!',
                      imagePath: 'assets/icons/Shopee_Coins.png',
                      showBadge: true,
                    ),
                    _buildWalletIconItem(
                      Icons.credit_card,
                      'My SPayLater',
                      'Get credit up to\n฿100,000',
                      imagePath: 'assets/icons/My_SPay_Later.png',
                    ),
                    _buildWalletIconItemWithBadge(
                      Icons.confirmation_number,
                      'My Voucher',
                      '50+ Vouchers',
                      imagePath: 'assets/icons/My_Voucher.png',
                      showBadge: true,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Financial Services Section
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildMenuItem(
                  Icons.account_balance,
                  'SEasyCash',
                  trailing: 'Get up to ฿100,000',
                  badge: 'New',
                  imagePath: 'assets/icons/SEasy_Cash.png',
                ),
                _buildMenuItem(
                  Icons.security,
                  'Insurance',
                  trailing: 'View Purchase History',
                  showDivider: false,
                  imagePath: 'assets/icons/Insurance.png',
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Activities Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activities',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.push('/favorites'),
                        child: _buildActivityCard(
                          Icons.favorite_border,
                          'Liked Items',
                          imagePath: 'assets/icons/Liked_Items.png',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActivityCard(
                        Icons.store,
                        'Affiliate Program',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildActivityCard(
                        Icons.restaurant,
                        'ShopeeFood',
                        subtitle: 'Discount up to 50%',
                        imagePath: 'assets/icons/Shopee_Food.png',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildActivityCard(
                        Icons.schedule,
                        'Recently Viewed',
                        imagePath: 'assets/icons/Recently_Viewed.png',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Help Section
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Help',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 8),
                _buildMenuItem(Icons.help_outline, 'Help Center', showDivider: false),
                _buildMenuItem(Icons.chat_bubble_outline, 'Chat with Us', showDivider: false),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showSettingsScreen(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Settings',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: [
                    _buildSettingsSection('Account', [
                      _buildSettingsItem('Profile and Security', Icons.person_outline),
                      _buildSettingsItem('My Addresses', Icons.location_on_outlined),
                      _buildSettingsItem('Bank Account/Card', Icons.credit_card),
                    ]),
                    const Divider(height: 1, thickness: 8, color: Color(0xFFF5F5F5)),
                    _buildSettingsSection('Settings', [
                      _buildSettingsItem('Chat Settings', Icons.chat_bubble_outline),
                      _buildSettingsItem('Notification Settings', Icons.notifications_outlined),
                      _buildSettingsItem('Privacy Settings', Icons.lock_outline),
                      _buildSettingsItem('Users Blocked', Icons.block),
                    ]),
                    const Divider(height: 1, thickness: 8, color: Color(0xFFF5F5F5)),
                    _buildSettingsSection('Language', [
                      _buildSettingsItem('Language / ภาษา / ဘာသာစကား', Icons.language, trailing: 'English'),
                    ]),
                    const Divider(height: 1, thickness: 8, color: Color(0xFFF5F5F5)),
                    _buildSettingsSection('Support', [
                      _buildSettingsItem('Help Center', Icons.help_outline),
                      _buildSettingsItem('Terms of Use', Icons.description_outlined),
                      _buildSettingsItem('Shopee Policy', Icons.policy_outlined),
                      _buildSettingsItem('Do you like Shopee?', Icons.thumb_up_outlined),
                      _buildSettingsItem('About', Icons.info_outline),
                      _buildSettingsItem('Account Deletion', Icons.delete_outline),
                    ]),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: OutlinedButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Log Out'),
                              content: const Text('Do you want to log out?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(dialogContext, true),
                                  child: const Text('Log Out', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            // ปิด Settings modal ก่อน
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                            
                            // ทำการ logout
                            await ref.read(authNotifierProvider.notifier).signOut();
                            
                            // Navigate to home
                            if (context.mounted) {
                              context.go('/');
                            }
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Change User / Log Out',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, {String? trailing}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700], size: 28),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: trailing != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(trailing, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
              ],
            )
          : const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildActivityCard(IconData icon, String label, {String? subtitle, String? imagePath}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          imagePath != null
              ? Image.asset(
                  imagePath,
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(icon, size: 40, color: AppColors.primary);
                  },
                )
              : Icon(icon, size: 40, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 9, color: Colors.grey[600]),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVIPIconItem(IconData icon, String label, {String? imagePath}) {
    return SizedBox(
      width: 70,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          imagePath != null
              ? Image.asset(
                  imagePath,
                  width: 56,
                  height: 56,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(icon, size: 56, color: AppColors.primary);
                  },
                )
              : Icon(icon, size: 56, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildWalletIconItemWithBadge(
    IconData icon,
    String label,
    String value, {
    String? imagePath,
    bool showBadge = false,
  }) {
    return SizedBox(
      width: 70,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              imagePath != null
                  ? Image.asset(
                      imagePath,
                      width: 56,
                      height: 56,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(icon, size: 56, color: AppColors.primary);
                      },
                    )
                  : Icon(icon, size: 56, color: AppColors.primary),
              if (showBadge)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(fontSize: 9, color: Colors.grey[600]),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(IconData icon, String label, {int? badge, String? imagePath}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            imagePath != null
                ? Image.asset(
                    imagePath,
                    width: 56,
                    height: 56,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(icon, size: 56, color: Colors.grey[600]);
                    },
                  )
                : Icon(icon, size: 56, color: Colors.grey[600]),
            if (badge != null)
              Positioned(
                right: -6,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '$badge',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title, {
    String? trailing,
    bool showNew = false,
    String? badge,
    bool showDivider = true,
    VoidCallback? onTap,
    String? imagePath,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: imagePath != null
              ? Image.asset(
                  imagePath,
                  width: 28,
                  height: 28,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(icon, color: Colors.grey[700], size: 28);
                  },
                )
              : Icon(icon, color: Colors.grey[700], size: 28),
          title: Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 14)),
              if (showNew || badge != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    badge ?? 'New',
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
          trailing: trailing != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        trailing,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                  ],
                )
              : const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
          onTap: onTap,
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE), indent: 56),
      ],
    );
  }

  Widget _buildWalletIconItem(IconData icon, String label, String value, {String? imagePath}) {
    return SizedBox(
      width: 70,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          imagePath != null
              ? Image.asset(
                  imagePath,
                  width: 56,
                  height: 56,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(icon, size: 56, color: AppColors.primary);
                  },
                )
              : Icon(icon, size: 56, color: AppColors.primary),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 9, color: Colors.grey),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}