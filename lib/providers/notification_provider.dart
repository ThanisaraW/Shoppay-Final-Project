import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model สำหรับ Notification
class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type; // 'order', 'promotion', 'system', etc.
  final DateTime timestamp;
  final bool isRead;
  final String? orderNumber;
  final double? amount;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.orderNumber,
    this.amount,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    DateTime? timestamp,
    bool? isRead,
    String? orderNumber,
    double? amount,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      orderNumber: orderNumber ?? this.orderNumber,
      amount: amount ?? this.amount,
    );
  }
}

// State สำหรับจัดการ Notifications
class NotificationState {
  final List<NotificationItem> notifications;
  
  NotificationState({this.notifications = const []});

  NotificationState copyWith({
    List<NotificationItem>? notifications,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
    );
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;
}

// Notifier สำหรับจัดการ Notifications
class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(NotificationState());

  // เพิ่มการแจ้งเตือนคำสั่งซื้อ
  void addOrderNotification({
    required String orderNumber,
    required double totalAmount,
    required int quantity,
  }) {
    final newNotification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'คำสั่งซื้อสำเร็จ',
      message: 'คำสั่งซื้อ #$orderNumber สำเร็จแล้ว จำนวน $quantity ชิ้น ยอดชำระ ฿${totalAmount.toStringAsFixed(2)}',
      type: 'order',
      timestamp: DateTime.now(),
      orderNumber: orderNumber,
      amount: totalAmount,
    );

    state = state.copyWith(
      notifications: [newNotification, ...state.notifications],
    );
  }

  // เพิ่มการแจ้งเตือนทั่วไป
  void addNotification({
    required String title,
    required String message,
    String type = 'system',
  }) {
    final newNotification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      notifications: [newNotification, ...state.notifications],
    );
  }

  // ทำเครื่องหมายว่าอ่านแล้ว
  void markAsRead(String id) {
    state = state.copyWith(
      notifications: state.notifications.map((notification) {
        if (notification.id == id) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList(),
    );
  }

  // ทำเครื่องหมายทั้งหมดว่าอ่านแล้ว
  void markAllAsRead() {
    state = state.copyWith(
      notifications: state.notifications.map((notification) {
        return notification.copyWith(isRead: true);
      }).toList(),
    );
  }

  // ลบการแจ้งเตือน
  void removeNotification(String id) {
    state = state.copyWith(
      notifications: state.notifications.where((n) => n.id != id).toList(),
    );
  }

  // ล้างการแจ้งเตือนทั้งหมด
  void clearAll() {
    state = NotificationState();
  }
}

// Provider
final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});

// Provider สำหรับนับจำนวนการแจ้งเตือนที่ยังไม่ได้อ่าน
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notificationState = ref.watch(notificationProvider);
  return notificationState.unreadCount;
});