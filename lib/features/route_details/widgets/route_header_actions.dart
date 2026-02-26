import 'package:flutter/material.dart';
import 'package:trailquest_mobile/core/models/user_role.dart';

class RouteDetailHeaderActions extends StatelessWidget {
  final UserRole role;
  final bool isFavourite;
  final VoidCallback onToggleFavourite;
  final VoidCallback onShare;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RouteDetailHeaderActions({
    super.key,
    required this.role,
    required this.isFavourite,
    required this.onToggleFavourite,
    required this.onShare,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onShare,
          icon: const Icon(Icons.share, color: Color(0xFF1B512D)),
        ),
        IconButton(
          onPressed: onToggleFavourite,
          icon: Icon(
            isFavourite ? Icons.favorite : Icons.favorite_border,
            color: isFavourite ? Colors.red : const Color(0xFF1B512D),
          ),
        ),
        if (role == UserRole.manager || role == UserRole.admin)
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, color: Color(0xFF1B512D)),
          ),
        if (role == UserRole.admin)
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
      ],
    );
  }
}
