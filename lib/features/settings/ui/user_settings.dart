import 'package:flutter/material.dart';
import '../../common/widgets/bottom_navigation_bar.dart';
import '../../user/ui/user_profile.dart';
import '../../welcome_page/ui/welcome_page_view.dart';

class UserSettingsPage extends StatefulWidget {
  final String? username;
  final String? email;

  const UserSettingsPage({super.key, this.username, this.email});

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  late String _username;
  late String _email;
  late String _userAvatar;

  @override
  void initState() {
    super.initState();
    _username = widget.username ?? 'Usuario';
    _email = widget.email ?? 'usuario@trailquest.com';
    _userAvatar = _username.isNotEmpty ? _username[0].toUpperCase() : 'U';
  }

  void _showEditProfile() {
    final usernameController = TextEditingController(text: _username);
    final emailController = TextEditingController(text: _email);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF3D6B4A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DragHandle(),
              const SizedBox(height: 20),
              const Text(
                'Edit Profile',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              _InputField(label: 'Name', controller: usernameController),
              const SizedBox(height: 16),
              _InputField(
                label: 'Email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 28),
              _PrimaryButton(
                label: 'Save Changes',
                onPressed: () {
                  final newName = usernameController.text.trim();
                  final newEmail = emailController.text.trim();
                  if (newName.isNotEmpty && newEmail.isNotEmpty) {
                    setState(() {
                      _username = newName;
                      _email = newEmail;
                      _userAvatar = newName[0].toUpperCase();
                    });
                    Navigator.of(ctx).pop();
                    _showSnackBar('Profile updated successfully');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePassword() {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF3D6B4A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DragHandle(),
              const SizedBox(height: 20),
              const Text(
                'Change Password',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              _InputField(
                  label: 'Current Password',
                  controller: currentController,
                  obscureText: true),
              const SizedBox(height: 16),
              _InputField(
                  label: 'New Password',
                  controller: newController,
                  obscureText: true),
              const SizedBox(height: 16),
              _InputField(
                  label: 'Confirm New Password',
                  controller: confirmController,
                  obscureText: true),
              const SizedBox(height: 28),
              _PrimaryButton(
                label: 'Update Password',
                onPressed: () {
                  if (currentController.text.isEmpty) {
                    _showSnackBar('Please enter your current password');
                    return;
                  }
                  if (newController.text.length < 6) {
                    _showSnackBar(
                        'New password must be at least 6 characters');
                    return;
                  }
                  if (newController.text != confirmController.text) {
                    _showSnackBar('Passwords do not match');
                    return;
                  }
                  Navigator.of(ctx).pop();
                  _showSnackBar('Password changed successfully');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacy() {
    _showInfoDialog(
      title: 'Privacy',
      icon: Icons.privacy_tip_outlined,
      content:
          'TrailQuest collects only the data necessary to provide you with personalised trail recommendations and activity tracking.\n\n'
          '• Location data is used only while the app is active and is never sold to third parties.\n'
          '• Activity history is stored securely and can be deleted at any time.\n'
          '• You can request a full data export at support@trailquest.com.\n\n'
          'Full policy at trailquest.com/privacy.',
    );
  }

  void _showHelpCenter() {
    _showInfoDialog(
      title: 'Help Center',
      icon: Icons.help_outline,
      content:
          'Need help? We\'re here for you.\n\n'
          'support@trailquest.com\n'
          'trailquest.com/help\n'
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

  void _showLogOutConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF3D6B4A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const WelcomePageView()),
              );
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          Icon(icon, color: const Color(0xFF9DB92C), size: 22),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
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
          onPressed: () => Navigator.of(context).pop({
            'username': _username,
            'email': _email,
            'avatar': _userAvatar,
          }),
        ),
        title: const Text('Settings',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE8D4C8),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Center(
                      child: Text(_userAvatar,
                          style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFCB4D5))),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_username,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(_email,
                            style: const TextStyle(
                                color: Color(0xFFD4E5DB),
                                fontSize: 13,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Account Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ACCOUNT',
                      style: TextStyle(
                          color: Color(0xFFA8C59F),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  _SettingItem(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      onTap: _showEditProfile),
                  const SizedBox(height: 12),
                  _SettingItem(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      onTap: _showChangePassword),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Privacy & Support Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PRIVACY & SUPPORT',
                      style: TextStyle(
                          color: Color(0xFFA8C59F),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5)),
                  const SizedBox(height: 12),
                  _SettingItem(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy',
                      onTap: _showPrivacy),
                  const SizedBox(height: 12),
                  _SettingItem(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      onTap: _showHelpCenter),
                  const SizedBox(height: 12),
                  _SettingItem(
                      icon: Icons.info_outline,
                      title: 'About TrailQuest',
                      onTap: _showAbout),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Logout Button
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
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 5,
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

class _InputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;

  const _InputField({
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(
                color: Color(0xFFD4E5DB),
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF4A7C59),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFFA8C59F),
                        size: 20),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class _NotifToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotifToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: const Color(0xFF4A7C59),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xFFD4E5DB), fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF9DB92C),
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}