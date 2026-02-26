import 'package:flutter/material.dart';
import 'package:trailquest_mobile/core/models/poi.dart';

class RoutePoiListSection extends StatelessWidget {
  final List<POI> pois;
  final ValueChanged<POI>? onPoiTap;
  // URL base para cargar fotos de POIs desde el backend
  final String imageBaseUrl;

  const RoutePoiListSection({
    super.key,
    required this.pois,
    this.onPoiTap,
    this.imageBaseUrl = 'http://10.0.2.2:8080/api/files',
  });

  @override
  Widget build(BuildContext context) {
    if (pois.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'POINTS OF INTEREST',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B512D),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        ...pois.map((poi) => _PoiCard(
              poi: poi,
              imageBaseUrl: imageBaseUrl,
              onTap: onPoiTap != null ? () => onPoiTap!(poi) : null,
            )),
      ],
    );
  }
}

class _PoiCard extends StatelessWidget {
  final POI poi;
  final String imageBaseUrl;
  final VoidCallback? onTap;

  const _PoiCard({
    required this.poi,
    required this.imageBaseUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto =
        poi.photoFileId != null && poi.photoFileId!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: SizedBox(
                width: 72,
                height: 72,
                child: hasPhoto
                    ? Image.network(
                        '$imageBaseUrl/${poi.photoFileId}',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    poi.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xFF1B512D),
                    ),
                  ),
                  if (poi.type != null && poi.type!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        poi.type!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF5C7A5C),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Color(0xFF5C7A5C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFC5E177),
      child: const Icon(Icons.landscape, color: Color(0xFF1B512D)),
    );
  }
}
