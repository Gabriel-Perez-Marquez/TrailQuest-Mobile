import 'package:flutter/material.dart';

class RouteHeaderImage extends StatelessWidget {
  final String? coverFileId;
  final String imageBaseUrl;

  const RouteHeaderImage({
    super.key,
    required this.coverFileId,
    this.imageBaseUrl = 'http://10.0.2.2:8080/api/files',
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = coverFileId != null && coverFileId!.isNotEmpty;

    if (!hasImage) {
      return _gradient();
    }

    return Image.network(
      '$imageBaseUrl/$coverFileId',
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _gradient();
      },
      errorBuilder: (_, __, ___) => _gradient(),
    );
  }

  Widget _gradient() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2AA84A), Color(0xFFD2E993)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.landscape, size: 80, color: Colors.white54),
      ),
    );
  }
}
