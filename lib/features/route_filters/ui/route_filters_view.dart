import 'package:flutter/material.dart';
import 'package:trailquest_mobile/features/route_filters/widgets/difficulty_card.dart';
import 'package:trailquest_mobile/features/route_filters/widgets/route_type_button.dart';

class RouteFiltersView extends StatefulWidget {
  const RouteFiltersView({super.key});

  @override
  State<RouteFiltersView> createState() => _RouteFiltersViewState();
}

class _RouteFiltersViewState extends State<RouteFiltersView> {
  String difficulty = 'Easy';
  double maxDistance = 40;
  String routeType = 'Out & Back';
  final List<String> regions = const [
    'All regions',
    'Sierra Norte',
    'Sierra Sur',
    'Costa',
    'Parque Natural Doñana',
  ];
  String region = 'All regions';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1F17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1F17),
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF1E432B),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 18),
                color: Colors.white,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            const Text(
              'Filters',
              style: TextStyle(
                color: Color(0xFFEDF7D1),
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  difficulty = 'Easy';
                  maxDistance = 40;
                  routeType = 'Out & Back';
                  region = 'All regions';
                });
              },
              child: const Text(
                'RESET',
                style: TextStyle(
                  color: Color(0xFFD2E993),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Text(
              'DIFFICULTY',
              style: TextStyle(
                color: Color(0xFFD2E993),
                fontSize: 14,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DifficultyCard(
                  label: 'Easy',
                  selectedLabel: difficulty,
                  color: const Color(0xFF46E071),
                  onSelected: (value) => setState(() => difficulty = value),
                ),
                DifficultyCard(
                  label: 'Moderate',
                  selectedLabel: difficulty,
                  color: const Color(0xFFFFB769),
                  onSelected: (value) => setState(() => difficulty = value),
                ),
                DifficultyCard(
                  label: 'Hard',
                  selectedLabel: difficulty,
                  color: const Color(0xFFFF7B7B),
                  onSelected: (value) => setState(() => difficulty = value),
                ),
                DifficultyCard(
                  label: 'Extreme',
                  selectedLabel: difficulty,
                  color: const Color(0xFFFF4545),
                  onSelected: (value) => setState(() => difficulty = value),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'LENGTH (Km)',
              style: TextStyle(
                color: Color(0xFFD2E993),
                fontSize: 14,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF1E432B),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    activeTrackColor: const Color(0xFF8EE28F),
                    inactiveTrackColor: const Color(0xFF1E432B),
                    thumbColor: const Color(0xFFB9F28B),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                    ),
                    overlayShape: SliderComponentShape.noOverlay,
                  ),
                  child: Slider(
                    min: 0,
                    max: 80,
                    value: maxDistance,
                    onChanged: (value) {
                      setState(() => maxDistance = value);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '0',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  '80+',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'ROUTE TYPE',
              style: TextStyle(
                color: Color(0xFFCEDF8F),
                fontSize: 14,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RouteTypeButton(
                  label: 'Loop',
                  selectedLabel: routeType,
                  icon: Icons.autorenew,
                  onSelected: (value) => setState(() => routeType = value),
                ),
                RouteTypeButton(
                  label: 'Out & Back',
                  selectedLabel: routeType,
                  icon: Icons.arrow_forward,
                  onSelected: (value) => setState(() => routeType = value),
                ),
                RouteTypeButton(
                  label: 'Elevated',
                  selectedLabel: routeType,
                  icon: Icons.trending_up,
                  onSelected: (value) => setState(() => routeType = value),
                ),
                RouteTypeButton(
                  label: 'Point to Point',
                  selectedLabel: routeType,
                  icon: Icons.compare_arrows,
                  onSelected: (value) => setState(() => routeType = value),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'REGION',
              style: TextStyle(
                color: Color(0xFFCEDF8F),
                fontSize: 14,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final selected = await showModalBottomSheet<String>(
                  context: context,
                  backgroundColor: const Color(0xFF02160D),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  builder: (context) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: regions.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, color: Colors.white12),
                      itemBuilder: (context, index) {
                        final item = regions[index];
                        final isSelected = item == region;

                        return ListTile(
                          title: Text(
                            item,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFFCEDF8F)
                                  : Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          onTap: () => Navigator.of(context).pop(item),
                        );
                      },
                    );
                  },
                );

                if (selected != null && selected != region) {
                  setState(() => region = selected);
                }
              },
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF062015),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      region,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 72,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E432B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36),
                  ),
                ),
                onPressed: () {
                  // completar esto
                },
                child: const Text(
                  'SHOW 86 TRAILS',
                  style: TextStyle(
                    color: Color(0xFFD2E993),
                    fontSize: 18,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
