import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(currentUserProvider);

    return authState.when(
      data: (user) => _buildSettings(context, ref, user),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildSettings(BuildContext context, WidgetRef ref, user) {
    final isLoggedIn = user != null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Account Settings',
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.chat_bubble_outline, color: Colors.black),
                if (isLoggedIn)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '33',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => context.push('/chat'),
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),

          // Account Section
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _buildSettingsItem('Profile and Security', Icons.person_outline),
                _buildDivider(),
                _buildSettingsItem('My Addresses', Icons.location_on_outlined),
                _buildDivider(),
                _buildSettingsItem('Account Info/Banks', Icons.credit_card_outlined),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Settings Section
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _buildSettingsItem('Chat Settings', Icons.chat_outlined),
                _buildDivider(),
                _buildSettingsItem('Notification Settings', Icons.notifications_outlined),
                _buildDivider(),
                _buildSettingsItem('Privacy Settings', Icons.lock_outline),
                _buildDivider(),
                _buildSettingsItem('User Blocked', Icons.block_outlined),
                _buildDivider(),
                _buildSettingsItem('Language / Language / ဘာသာစကား', Icons.language_outlined, 
                    subtitle: 'English'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Help Section
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Help',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _buildSettingsItem('Help Center', Icons.help_outline),
                _buildDivider(),
                _buildSettingsItem('Usage Regulations', Icons.description_outlined),
                _buildDivider(),
                _buildSettingsItem('Shopee Policies', Icons.policy_outlined),
                _buildDivider(),
                _buildSettingsItem('Want to work at Shopee? Join us now!', Icons.work_outline),
                _buildDivider(),
                _buildSettingsItem('About', Icons.info_outline),
                _buildDivider(),
                _buildSettingsItem('Account Deletion Request', Icons.delete_outline),
              ],
            ),
          ),

          if (isLoggedIn) ...[
            const SizedBox(height: 16),

            // Logout button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Log Out'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Log Out',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await ref.read(authNotifierProvider.notifier).signOut();
                    if (context.mounted) {
                      context.go('/');
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'Change/Log Out Account',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, {String? subtitle}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: Colors.black87, size: 24),
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0xFFEEEEEE),
      margin: const EdgeInsets.only(left: 56),
    );
  }
}