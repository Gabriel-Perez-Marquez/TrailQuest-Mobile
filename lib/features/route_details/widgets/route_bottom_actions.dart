import 'package:flutter/material.dart';
import 'package:trailquest_mobile/core/models/user_role.dart';

class RouteBottomActions extends StatelessWidget {
  final UserRole role;
  final VoidCallback onDownload;
  final VoidCallback onNavigate;
  final VoidCallback onDraft;
  final VoidCallback onPublish;

  const RouteBottomActions({
    super.key,
    required this.role,
    required this.onDownload,
    required this.onNavigate,
    required this.onDraft,
    required this.onPublish,
  });

  @override
  Widget build(BuildContext context) {
    final canPublish = role == UserRole.manager || role == UserRole.admin;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onDownload,
                    icon: const Icon(Icons.download),
                    label: const Text('Download'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B512D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onNavigate,
                    icon: const Icon(Icons.navigation),
                    label: const Text('Navigate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2AA84A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (canPublish) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onDraft,
                      icon: const Icon(Icons.edit_note),
                      label: const Text('Draft'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE96B5A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onPublish,
                      icon: const Icon(Icons.verified),
                      label: const Text('Publish'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B512D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}