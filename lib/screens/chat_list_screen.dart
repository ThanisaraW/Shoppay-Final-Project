import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/app_theme.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Chat', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Text('All', style: TextStyle(fontWeight: FontWeight.bold)),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildChatItem(
                  'inlighthole',
                  'For customers who enter the code...',
                  '16-03-2022 7:01 AM',
                ),
                _buildChatItem(
                  'lotus_officialshop',
                  '🔥 Get ready! With Lotus 3.15 Con...',
                  '14-03-2022 11:59 AM',
                ),
                _buildChatItem(
                  'pawsociety',
                  '3 special products discount...',
                  '04-03-2022 4:55 PM',
                ),
                _buildChatItem(
                  'ssp_lfc',
                  '🔴 LFC x Shopee 2nd drop 🔥🔥',
                  '18-02-2022 6:00 PM',
                ),
                _buildChatItem(
                  'adkowjaroen',
                  'Best price for you',
                  '17-01-2022 11:55 AM',
                ),
                _buildChatItem(
                  'laskdai.th',
                  'yes',
                  '05-01-2022 1:11 PM',
                ),
                _buildChatItem(
                  'babgun',
                  'Check out our latest collection',
                  '21-12-2021 10:28 AM',
                ),
                _buildChatItem(
                  'poseehome.th',
                  'do you play tiktok, dear?',
                  '21-12-2021 8:05 AM',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(String shop, String message, String time) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: const Icon(Icons.store, color: Colors.grey),
      ),
      title: Row(
        children: [
          Text(shop, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          const Icon(Icons.verified, size: 16, color: Colors.red),
        ],
      ),
      subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
            child: const Text(
              '8',
              style: TextStyle(color: Colors.white, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}