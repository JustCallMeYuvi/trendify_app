import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendify/login_screen.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  Future<void> logout(BuildContext context) async {
    // Firebase logout
    await FirebaseAuth.instance.signOut();

    // Clear stored login credentials
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Navigate to login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  bool pushAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        title: const Text(
          'Admin Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xFF1E293B),
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFFEE2B5B).withOpacity(0.2), width: 2),
              ),
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=100&h=100'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'ACCOUNT SETTINGS'),
            SettingsCard(children: [
              const SettingsTile(
                icon: Icons.person_outline,
                label: 'Profile Details',
                iconColor: Color(0xFF3B82F6),
                bgColor: Color(0xFFEFF6FF),
              ),
              const SettingsTile(
                icon: Icons.verified_user_outlined,
                label: 'Security',
                iconColor: Color(0xFF6366F1),
                bgColor: Color(0xFFEEF2FF),
              ),
              const SettingsTile(
                icon: Icons.lock_reset,
                label: 'Change Password',
                iconColor: Color(0xFFF59E0B),
                bgColor: Color(0xFFFFFBEB),
              ),
            ]),
            const SectionHeader(title: 'STORE CONFIGURATION'),
            SettingsCard(children: [
              const SettingsTile(
                icon: Icons.category_outlined,
                label: 'Manage Categories',
                iconColor: Color(0xFF10B981),
                bgColor: Color(0xFFECFDF5),
              ),
              const SettingsTile(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Payment Gateway',
                iconColor: Color(0xFFF59E0B),
                bgColor: Color(0xFFFFFBEB),
              ),
              const SettingsTile(
                icon: Icons.local_shipping_outlined,
                label: 'Shipping Rates',
                iconColor: Color(0xFF06B6D4),
                bgColor: Color(0xFFECFEFF),
              ),
            ]),
            const SectionHeader(title: 'NOTIFICATIONS'),
            SettingsCard(children: [
              SettingsTile(
                icon: Icons.notifications_active_outlined,
                label: 'Push Alerts',
                iconColor: Color(0xFFEC4899),
                bgColor: const Color(0xFFFDF2F8),
                trailing: Switch(
                  value: pushAlerts,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFFEE2B5B),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFE2E8F0),
                  onChanged: (val) => setState(() => pushAlerts = val),
                ),
              ),
              const SettingsTile(
                icon: Icons.alternate_email,
                label: 'Email Settings',
                iconColor: Color(0xFFA855F7),
                bgColor: Color(0xFFFAF5FF),
              ),
            ]),
            const SectionHeader(title: 'ACCESS MANAGEMENT'),
            const SettingsCard(children: [
              SettingsTile(
                icon: Icons.admin_panel_settings_outlined,
                label: 'Manage Admin Roles',
                iconColor: Color(0xFFF43F5E),
                bgColor: Color(0xFFFFF1F2),
              ),
            ]),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  logout(context);
                },
                icon: const Icon(Icons.logout,
                    color: Color(0xFFE02424), size: 20),
                label: const Text('Log Out',
                    style: TextStyle(
                        color: Color(0xFFE02424),
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFDE8E8),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            const SizedBox(height: 120), // Bottom nav spacer
          ],
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Container(
      //   margin: const EdgeInsets.only(top: 20),
      //   child: FloatingActionButton(
      //     onPressed: () {},
      //     backgroundColor: const Color(0xFFEE2B5B),
      //     elevation: 8,
      //     shape: const CircleBorder(),
      //     child: const Icon(Icons.add, color: Colors.white, size: 32),
      //   ),
      // ),
      // bottomNavigationBar: BottomAppBar(
      //   height: 85,
      //   notchMargin: 12,
      //   padding: const EdgeInsets.symmetric(horizontal: 10),
      //   shape: const CircularNotchedRectangle(),
      //   color: Colors.white,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       const NavItem(icon: Icons.dashboard_outlined, label: 'Home'),
      //       const NavItem(icon: Icons.local_shipping_outlined, label: 'Orders'),
      //       const SizedBox(width: 48), // Space for FAB
      //       const NavItem(icon: Icons.inventory_2_outlined, label: 'Inventory'),
      //       const NavItem(
      //           icon: Icons.settings, label: 'Settings', isActive: true),
      //     ],
      //   ),
      // ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 12.0, top: 20.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.0,
          color: Color(0xFF94A3B8),
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const SettingsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color bgColor;
  final Widget? trailing;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.bgColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      title: Text(label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E293B),
          )),
      trailing: trailing ??
          const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1), size: 20),
      onTap: () {},
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  const NavItem(
      {super.key,
      required this.icon,
      required this.label,
      this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color:
                  isActive ? const Color(0xFFEE2B5B) : const Color(0xFF94A3B8),
              size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color:
                  isActive ? const Color(0xFFEE2B5B) : const Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
