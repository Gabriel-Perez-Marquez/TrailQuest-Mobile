import 'package:flutter/material.dart';
import '../../../core/services/theme_service.dart';
import '../../common/widgets/bottom_navigation_bar.dart';
import '../../user/ui/user_profile.dart';

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({super.key});

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  String _selectedUnit = 'Metric';
  late bool _darkModeEnabled;
  late ThemeService _themeService;

  final List<_OfflineMap> _offlineMaps = [
    _OfflineMap(name: 'Olympic National Park', size: '1.2 GB'),
    _OfflineMap(name: 'Cascade Range – North', size: '0.8 GB'),
    _OfflineMap(name: 'Mount Rainier Area', size: '0.4 GB'),
  ];

  @override
  void initState() {
    super.initState();
    _themeService = ThemeService();
    _darkModeEnabled = _themeService.isDarkMode;
  }

  void _showOfflineMaps() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFF3D6B4A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DragHandle(),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.map_outlined, color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  const Text(
                    'Offline Maps',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    '${_totalOfflineSize()} total',
                    style: const TextStyle(
                        color: Color(0xFFD4E5DB), fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ..._offlineMaps.map(
                (map) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                        color: const Color(0xFF4A7C59),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        const Icon(Icons.download_done,
                            color: Color(0xFF9DB92C), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(map.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              Text(map.size,
                                  style: const TextStyle(
                                      color: Color(0xFFD4E5DB),
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Color(0xFFFF6B6B), size: 20),
                          onPressed: () {
                            setModalState(() => _offlineMaps.remove(map));
                            setState(() {});
                            _showSnackBar('${map.name} deleted');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _PrimaryButton(
                label: 'Download New Map',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _showSnackBar('Map download feature coming soon');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _totalOfflineSize() {
    if (_offlineMaps.isEmpty) return '0 GB';
    final total = _offlineMaps.fold(0.0, (sum, m) {
      final value = double.tryParse(m.size.replaceAll(' GB', '')) ?? 0;
      return sum + value;
    });
    return '${total.toStringAsFixed(1)} GB';
  }

  void _showHelpSupport() {
    _showInfoDialog(
      title: 'Help & Support',
      icon: Icons.help_outline,
      content:
          'Need help? We\'re here for you.\n\n'
          '📧  support@trailquest.com\n'
          '🌐  trailquest.com/help\n'
          '💬  In-app chat (Pro members)\n\n'
          'Common topics:\n'
          '• How to download offline maps\n'
          '• Recording a hike\n'
          '• Managing your subscription\n'
          '• Reporting a trail issue',
    );
  }

  void _showAbout() {
    _showInfoDialog(
      title: 'About TrailQuest',
      icon: Icons.info_outline,
      content:
          'TrailQuest v4.5.0\n\n'
          'Your companion for every adventure. Discover thousands of trails, track your progress and connect with a community of outdoor enthusiasts.\n\n'
          '© 2024 TrailQuest Inc.\ntrailquest.com',
    );
  }

  void _showPrivacyPolicy() {
    _showInfoDialog(
      title: 'Privacy Policy',
      icon: Icons.privacy_tip_outlined,
      content:
          'TrailQuest collects only the data necessary to provide personalised trail recommendations and activity tracking.\n\n'
          '• Location data is used only while the app is active and is never sold to third parties.\n'
          '• Activity history is stored securely and can be deleted at any time.\n'
          '• You can request a full data export at support@trailquest.com.\n\n'
          'Full policy at trailquest.com/privacy.',
    );
  }

  void _showLogOutConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF3D6B4A),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        content: const Text('Are you sure you want to log out?',
            style: TextStyle(color: Color(0xFFD4E5DB))),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFFD4E5DB))),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // TODO: clear session and navigate to login screen
              _showSnackBar('Logged out');
            },
            child: const Text('Log Out',
                style: TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(
      {required String title,
      required IconData icon,
      required String content}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF3D6B4A),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          Icon(icon, color: const Color(0xFF9DB92C), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
          ),
        ]),
        content: Text(content,
            style: const TextStyle(
                color: Color(0xFFD4E5DB), fontSize: 14, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close',
                style: TextStyle(
                    color: Color(0xFF9DB92C),
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: const Color(0xFF3D6B4A),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A7C59),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A7C59),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('General Settings',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PREFERENCES',
                      style: TextStyle(
                          color: Color(0xFFA8C59F),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: const Color(0xFF5A9070),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Measurement Units',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        Row(
                          children: ['Metric', 'Imperial'].map((unit) {
                            final selected = _selectedUnit == unit;
                            return Expanded(
                              child: Padding(
                                padding: unit == 'Imperial'
                                    ? const EdgeInsets.only(left: 12)
                                    : EdgeInsets.zero,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() => _selectedUnit = unit);
                                    _showSnackBar(
                                        'Units set to $unit');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? const Color(0xFF9DB92C)
                                          : const Color(0xFF4A7C59),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(unit,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: const Color(0xFF5A9070),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const Icon(Icons.dark_mode_outlined,
                              color: Colors.white),
                          const SizedBox(width: 12),
                          const Text('Dark Mode',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                        ]),
                        Switch(
                          value: _darkModeEnabled,
                          onChanged: (value) {
                            setState(() => _darkModeEnabled = value);
                            _themeService.setDarkMode(value);
                            _showSnackBar(value
                                ? 'Dark mode enabled'
                                : 'Dark mode disabled');
                          },
                          activeColor: const Color(0xFF9DB92C),
                          inactiveThumbColor: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _showOfflineMaps,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: const Color(0xFF5A9070),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            const Icon(Icons.map_outlined, color: Colors.white),
                            const SizedBox(width: 12),
                            const Text('Offline Maps',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                          ]),
                          Row(children: [
                            Text(_totalOfflineSize(),
                                style: const TextStyle(
                                    color: Color(0xFFD4E5DB), fontSize: 13)),
                            const SizedBox(width: 8),
                            const Icon(Icons.chevron_right,
                                color: Color(0xFFD4E5DB), size: 20),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SUPPORT & LEGAL',
                      style: TextStyle(
                          color: Color(0xFFA8C59F),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  _SettingItem(
                      icon: Icons.help_outline,
                      title: 'Help & Support',
                      onTap: _showHelpSupport),
                  const SizedBox(height: 12),
                  _SettingItem(
                      icon: Icons.info_outline,
                      title: 'About TrailQuest',
                      onTap: _showAbout),
                  const SizedBox(height: 12),
                  _SettingItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      onTap: _showPrivacyPolicy),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showLogOutConfirmation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: const Color(0xFFFF6B6B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Log Out',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('TRAILQUEST V4.5.0',
                style: TextStyle(
                    color: Color(0xFFA8C59F),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5)),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 5) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const UserProfilePage()),
            );
          }
        },
      ),
    );
  }
}

class _OfflineMap {
  final String name;
  final String size;
  _OfflineMap({required this.name, required this.size});
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingItem(
      {required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
            color: const Color(0xFF5A9070),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
            ),
            const Icon(Icons.chevron_right,
                color: Color(0xFFD4E5DB), size: 20),
          ],
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
            color: Colors.white30, borderRadius: BorderRadius.circular(2)),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9DB92C),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}