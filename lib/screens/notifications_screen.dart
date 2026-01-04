import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme.dart';
import '../providers/cart_provider.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemsCount = ref.watch(cartItemsCountProvider);
    final notificationState = ref.watch(notificationProvider);
    final systemNotifications = notificationState.notifications;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('การแจ้งเตือน', style: TextStyle(color: Colors.white)),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                onPressed: () => context.push('/cart'),
              ),
              if (cartItemsCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
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
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
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
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: const Text(
                    '88',
                    style: TextStyle(
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
        ],
      ),
      body: ListView(
        children: [
          // Banner notification permission
          Container(
            color: Colors.amber[50],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_active, color: Colors.orange, size: 20),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'อนุญาตให้ Shopee ส่งการแจ้งเตือนความคืบหน้าของคำสั่งซื้อและโปรโมชั่น ฯ อนุญาต',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                const Icon(Icons.close, size: 20, color: Colors.grey),
              ],
            ),
          ),
          
          // Notification sections เดิม (อยู่บนก่อน)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'การแจ้งเตือนทั้งหมด',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          _buildNotificationSection(
            'โปรโมชั่นจาก Shopee',
            'assets/icons/noti_page/promotionจากshopee.png',
            '🚚 ส่งฟรี* พรุ่งนี้ถึง',
            '15',
            Colors.orange,
          ),
          const Divider(height: 1),
          
          _buildNotificationSection(
            'อัปเดตจาก Shopee Live/Video',
            'assets/icons/noti_page/updateจากshopeelive_vdo.png',
            'Konvy ดูลาคุ้ม ดีลเด็ด โปรแรง!',
            '16',
            Colors.teal,
          ),
          const Divider(height: 1),
          
          _buildNotificationSection(
            'อัปเดตบริการทางการเงิน',
            'assets/icons/noti_page/อัปเดตบริการทางการเงิน.png',
            'ระบบได้ตำเนินการคืนเงินจำนวน 480.- จากคำสั่ง...',
            '2',
            Colors.orange,
          ),
          const Divider(height: 1),
          
          _buildNotificationSection(
            'อัปเดตจาก Shopee',
            'assets/icons/noti_page/อัพเดทจากshopee.png',
            'เปิดการใช้งาน การเข้าสระบบแบบรวดเร็ว ในอุปก...',
            '3',
            Colors.orange,
          ),
          const Divider(height: 1),
          
          _buildNotificationSection(
            'Shopee Prizes',
            'assets/icons/noti_page/Shopee_Prizes.png',
            'เก่งมาก! คุณทำภารกิจ ShopeeFood ยิ่งกิน ยิ่งได้...',
            '1',
            Colors.blue,
          ),

          // แสดงการแจ้งเตือนจากระบบ (อยู่ล่างสุด)
          if (systemNotifications.isNotEmpty) ...[
            const Divider(height: 1, thickness: 8),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'การแจ้งเตือนล่าสุด',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (notificationState.unreadCount > 0)
                    TextButton(
                      onPressed: () {
                        ref.read(notificationProvider.notifier).markAllAsRead();
                      },
                      child: const Text(
                        'ทำเครื่องหมายว่าอ่านทั้งหมด',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                ],
              ),
            ),
            // แสดงรายการการแจ้งเตือนจากระบบ
            ...systemNotifications.map((notification) {
              return _buildSystemNotification(context, ref, notification);
            }).toList(),
          ],
        ],
      ),
    );
  }

  // Widget สำหรับแสดงการแจ้งเตือนจากระบบ
  Widget _buildSystemNotification(BuildContext context, WidgetRef ref, NotificationItem notification) {
    final timeAgo = _getTimeAgo(notification.timestamp);
    
    IconData iconData;
    Color iconColor;
    
    switch (notification.type) {
      case 'order':
        iconData = Icons.shopping_bag;
        iconColor = Colors.green;
        break;
      case 'payment':
        iconData = Icons.payment;
        iconColor = Colors.blue;
        break;
      case 'delivery':
        iconData = Icons.local_shipping;
        iconColor = Colors.orange;
        break;
      case 'promotion':
        iconData = Icons.local_offer;
        iconColor = const Color(0xFFEE4D2D);
        break;
      default:
        iconData = Icons.notifications;
        iconColor = const Color(0xFFEE4D2D);
    }

    return Container(
      color: notification.isRead ? Colors.white : Colors.orange[50],
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: iconColor,
                size: 28,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    notification.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w600,
                    ),
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEE4D2D),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
                const SizedBox(height: 4),
                Text(
                  timeAgo,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.grey[400]),
              onSelected: (value) {
                if (value == 'delete') {
                  ref.read(notificationProvider.notifier).removeNotification(notification.id);
                } else if (value == 'mark_read') {
                  ref.read(notificationProvider.notifier).markAsRead(notification.id);
                }
              },
              itemBuilder: (context) => [
                if (!notification.isRead)
                  const PopupMenuItem(
                    value: 'mark_read',
                    child: Text('ทำเครื่องหมายว่าอ่านแล้ว'),
                  ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('ลบการแจ้งเตือน'),
                ),
              ],
            ),
            onTap: () {
              if (!notification.isRead) {
                ref.read(notificationProvider.notifier).markAsRead(notification.id);
              }
              if (notification.orderNumber != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('คำสั่งซื้อ: ${notification.orderNumber}'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'เมื่อสักครู่';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} นาทีที่แล้ว';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ชั่วโมงที่แล้ว';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} วันที่แล้ว';
    } else {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    }
  }

  Widget _buildNotificationSection(String title, String iconPath, String subtitle, String badge, Color iconColor) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 56,
        height: 56,
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.asset(
            iconPath,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications,
                  color: iconColor,
                  size: 28,
                ),
              );
            },
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: const BoxConstraints(minWidth: 24),
            child: Text(
              badge,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }
}