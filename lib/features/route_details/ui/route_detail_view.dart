import 'package:flutter/material.dart';
import 'package:trailquest_mobile/core/models/poi.dart';
import 'package:trailquest_mobile/core/models/route_response.dart';
import 'package:trailquest_mobile/core/models/user_role.dart';
import 'package:trailquest_mobile/core/services/poi_service.dart';
import 'package:trailquest_mobile/core/services/route_service.dart';
import 'package:trailquest_mobile/features/poi_detail/ui/poi_detail_page_view.dart';
import 'package:trailquest_mobile/features/route_selected_map/ui/navigation_screen.dart';
import 'package:trailquest_mobile/features/route_details/widgets/route_bottom_actions.dart';
import 'package:trailquest_mobile/features/route_details/widgets/route_header_actions.dart';
import 'package:trailquest_mobile/features/route_details/widgets/route_header_image.dart';
import 'package:trailquest_mobile/features/route_details/widgets/route_poi_list_section.dart';
import 'package:trailquest_mobile/features/route_details/widgets/route_stats_row.dart';

class RouteDetailPageView extends StatefulWidget {
  final int routeId;
  final UserRole userRole;

  const RouteDetailPageView({
    super.key,
    required this.routeId,
    this.userRole = UserRole.public,
  });

  @override
  State<RouteDetailPageView> createState() => _RouteDetailPageViewState();
}

class _RouteDetailPageViewState extends State<RouteDetailPageView> {
  final _routeService = RouteService();
  final _poiService = PoiService();

  late Future<_RouteDetailData> _dataFuture;
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  Future<_RouteDetailData> _loadData() async {
    try {
      final results = await Future.wait([
        _routeService.getRoute(widget.routeId),
        _poiService.getPoisByRoute(widget.routeId),
      ]).timeout(const Duration(seconds: 8));
      return _RouteDetailData(
        route: results[0] as TrailRoute,
        pois: results[1] as List<POI>,
        isMock: false,
      );
    } catch (_) {
      return _RouteDetailData(
        route: _mockRoute(),
        pois: _mockPois(),
        isMock: true,
      );
    }
  }

  TrailRoute _mockRoute() => TrailRoute(
        id: widget.routeId,
        title: 'Lago Castiñeiras',
        region: 'Figueirido - Galicia',
        distanceKm: 4.3,
        difficulty: 'Easy',
        creatorId: '',
        coverFileId: '',
        elevation: 120,
        pathPoints: [],
        pois: [],
      );

  List<POI> _mockPois() => [
        POI(id: 1, name: 'Picnic Area', lat: 0, lon: 0, routeId: widget.routeId),
        POI(id: 2, name: 'Old Chapel', lat: 0, lon: 0, routeId: widget.routeId),
        POI(id: 3, name: 'Mirador del Lago', lat: 0, lon: 0, routeId: widget.routeId),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD2E993),
      body: FutureBuilder<_RouteDetailData>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1B512D)),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 48, color: Color(0xFF1B512D)),
                    const SizedBox(height: 12),
                    Text(
                      'No se pudo cargar la ruta.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF1B512D)),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          setState(() => _dataFuture = _loadData()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B512D),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final data = snapshot.data!;
          return _buildContent(context, data.route, data.pois, data.isMock);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, TrailRoute route, List<POI> pois, bool isMock) {
    return Stack(
      children: [
        // Cuerpo principal con imagen y contenido scrollable
        CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 260,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: RouteHeaderImage(coverFileId: route.coverFileId),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFD2E993),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
                child: _buildBody(context, route, pois),
              ),
            ),
          ],
        ),

        // Banner de datos de muestra (abajo)
        if (isMock)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: GestureDetector(
                onTap: () => setState(() => _dataFuture = _loadData()),
                // child: Container(
                //   padding: const EdgeInsets.symmetric(vertical: 8),
                //   color: const Color(0xFF1B512D).withOpacity(0.88),
                //   // child: const Row(
                //   //   mainAxisAlignment: MainAxisAlignment.center,
                //   //   children: [
                //   //     Icon(Icons.wifi_off, size: 14, color: Colors.white70),
                //   //     SizedBox(width: 6),
                //   //     Text(
                //   //       'Vista previa — toca para conectar al servidor',
                //   //       style: TextStyle(color: Colors.white70, fontSize: 12),
                //   //     ),
                //   //   ],
                //   // ),
                // ),
              ),
            ),
          ),

        // Botones de cabecera (back + acciones)
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleIconButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                RouteDetailHeaderActions(
                  role: widget.userRole,
                  isFavourite: _isFavourite,
                  onToggleFavourite: () =>
                      setState(() => _isFavourite = !_isFavourite),
                  onShare: () {},
                  onEdit: () {},
                  onDelete: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, TrailRoute route, List<POI> pois) {
    final titleText = route.title;
    final regionText = route.region;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                regionText.isNotEmpty
                    ? '$titleText -\n$regionText'
                    : titleText,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B512D),
                  fontFamily: 'Georgia',
                  height: 1.15,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _isFavourite = !_isFavourite),
              child: Icon(
                _isFavourite ? Icons.favorite : Icons.favorite_border,
                color: _isFavourite ? Colors.red : const Color(0xFF1B512D),
                size: 26,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            const Icon(Icons.star, color: Color(0xFFD4A346), size: 18),
            const SizedBox(width: 4),
            const Text(
              '—',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B512D),
              ),
            ),
            const SizedBox(width: 10),
            _DifficultyPill(text: route.difficulty),
          ],
        ),
        const SizedBox(height: 20),
        RouteStatsRow(
          distanceKm: route.distanceKm,
          elevation: route.elevation,
          estimatedTime: '', 
          routeType: '',    
        ),
        const SizedBox(height: 20),
        const Text(
          '¡Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis in maximus ante, in mollis libero. Nam eu justo erat. Vivamus laoreet ligula nec leo tincidunt, non lobortis felis ultrices. Nulla imperdiet augue eu mi congue maximus. Nulla facilisi. Proin pharetra dapibus porttitor. Fusce sollicitudin ex at ligula vestibulum, ac pharetra quam pellentesque.!',
          style: TextStyle(
            fontSize: 14.5,
            color: Color(0xFF355E3B),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        RoutePoiListSection(
          pois: pois,
          onPoiTap: (poi) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PoiDetailPageView(poi: poi),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        RouteBottomActions(
          role: widget.userRole,
          onDownload: () {},
          onNavigate: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => NavigationScreen(routeId: 1),
              ),
            );
          },
          onDraft: () {},
          onPublish: () {},
        ),
      ],
    );
  }
}


class _RouteDetailData {
  final TrailRoute route;
  final List<POI> pois;
  final bool isMock;
  const _RouteDetailData({required this.route, required this.pois, this.isMock = false});
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFD2E993),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: const Color(0xFF1B512D)),
        ),
      ),
    );
  }
}

class _DifficultyPill extends StatelessWidget {
  final String text;

  const _DifficultyPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2AA84A),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
