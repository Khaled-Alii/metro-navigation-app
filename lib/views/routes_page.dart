import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metro/model/route_info.dart';

// ─── Theme Colors ────────────────────────────────────────────────────────────
const Color bgDark = Color(0xFF16161A);
const Color surfaceDark = Color(0xFF22222A);
const Color textWhite = Colors.white;
const Color textGrey = Color(0xFFA0A0A5);

const _line1Color = Color(0xFF1976D2); // Blue
const _line2Color = Color(0xFFD32F2F); // Red
const _line3Color = Color(0xFF388E3C); // Green

// ─── Station Data ────────────────────────────────────────────────────────────
const _line1Stations = <String>{
  'helwan', 'ain helwan', 'helwan university', 'wadi hof',
  'hadayek helwan', 'el-maasara', 'tora el-asmant', 'kozzika',
  'tora el-balad', 'sakanat el-maadi', 'maadi', 'hadayek el-maadi',
  'dar el-salam', 'el-zahraa', 'mar girgis', 'el-malek el-saleh',
  'al-sayeda zeinab', 'saad zaghloul', 'orabi',
  'ghamra', 'el-demerdash', 'manshiet el-sadr',
  'kobri el-qobba', 'hammamat el-qobba', 'saray el-qobba',
  'hadayek el-zaitoun', 'helmeyet el-zaitoun', 'el-matareyya',
  'ain shams', 'ezbet el-nakhl', 'el-marg', 'new el-marg',
};

const _line2Stations = <String>{
  'el monib', 'sakiat mekki', 'omm el-masryeen', 'giza', 'faisal',
  'bohooth', 'dokki', 'opera', 'naguib',
  'massara', 'rod el-farag', 'sainte teresa', 'khalafawy',
  'mezallat', 'koleyet el-zeraa', 'shubra el-kheima',
};

String _capitalize(String s) {
  if (s.isEmpty) return s;
  return s.split(' ').map((w) {
    if (w.isEmpty) return w;
    return w[0].toUpperCase() + w.substring(1);
  }).join(' ');
}

// ─── Route Segment Logic ─────────────────────────────────────────────────────
class RouteSegment {
  final String lineName;
  final Color lineColor;
  final List<String> stations;
  final RxBool isExpanded;

  RouteSegment({
    required this.lineName,
    required this.lineColor,
    required this.stations,
    bool initiallyExpanded = false,
  }) : isExpanded = initiallyExpanded.obs;
}

// ─── Main Page ───────────────────────────────────────────────────────────────
class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  final _selectedFilter = 0.obs;
  final _routes = <RouteInfo>[].obs;

  @override
  void initState() {
    super.initState();
    // نقرأ المسارات المرسلة مرة واحدة فقط
    final rawRoutes = (Get.arguments as List).cast<RouteInfo>();
    _routes.assignAll(rawRoutes);
    // الترتيب الافتراضي (حسب الوقت الأفضل)
    _routes.sort((a, b) => a.time.compareTo(b.time));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        title: const Text(
          'Route Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: bgDark,
        foregroundColor: textWhite,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white.withOpacity(0.1), height: 1),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildFilterBar(),
            Expanded(
              child: Obx(() {
                if (_routes.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _routes.length,
                  itemBuilder: (_, index) => _SegmentedRouteCard(
                    // Key مميز لكل كارت علشان لما يترتبوا ميحصلش تداخل
                    key: ValueKey(_routes[index].path.join('-')),
                    route: _routes[index],
                    index: index,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    final filters = [
      _FilterOption(Icons.schedule, 'Best Time'),
      _FilterOption(Icons.transfer_within_a_station, 'Comfortable'),
      _FilterOption(Icons.route, 'Fewest Stations'),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: bgDark,
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Obx(() {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(filters.length, (i) {
              final selected = _selectedFilter.value == i;
              return Padding(
                padding: EdgeInsets.only(right: i < filters.length - 1 ? 10 : 0),
                child: ChoiceChip(
                  avatar: Icon(
                    filters[i].icon,
                    size: 18,
                    color: selected ? bgDark : textGrey,
                  ),
                  label: Text(
                    filters[i].label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: selected ? bgDark : textWhite,
                    ),
                  ),
                  selected: selected,
                  selectedColor: Colors.white,
                  backgroundColor: surfaceDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: selected ? Colors.white : Colors.white.withOpacity(0.1),
                    ),
                  ),
                  showCheckmark: false,
                  onSelected: (_) => _applyFilter(i),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  void _applyFilter(int index) {
    if (_selectedFilter.value == index) return;
    _selectedFilter.value = index;

    // استخدام دالة sort الأصلية بدلاً من dartx لتجنب الـ StackOverflow
    switch (index) {
      case 0: // Best Time
        _routes.sort((a, b) => a.time.compareTo(b.time));
        break;
      case 1: // Comfortable (Fewest Transfers)
        _routes.sort((a, b) => a.transStations.length.compareTo(b.transStations.length));
        break;
      case 2: // Fewest Stations
        _routes.sort((a, b) => a.path.length.compareTo(b.path.length));
        break;
    }
  }
}

class _FilterOption {
  final IconData icon;
  final String label;
  const _FilterOption(this.icon, this.label);
}

// ─── Route Card (Combining Stats + Segments) ─────────────────────────────────
class _SegmentedRouteCard extends StatefulWidget {
  final RouteInfo route;
  final int index;

  const _SegmentedRouteCard({super.key, required this.route, required this.index});

  @override
  State<_SegmentedRouteCard> createState() => _SegmentedRouteCardState();
}

class _SegmentedRouteCardState extends State<_SegmentedRouteCard> {
  late List<RouteSegment> segments;

  @override
  void initState() {
    super.initState();
    segments = _buildSegments(widget.route);
  }

  (String, Color) _getLineInfo(List<String> segmentStations) {
    String checkStation = segmentStations.length > 1
        ? segmentStations[1].toLowerCase().trim()
        : segmentStations[0].toLowerCase().trim();

    if (_line1Stations.contains(checkStation)) return ("Line 1", _line1Color);
    if (_line2Stations.contains(checkStation)) return ("Line 2", _line2Color);
    return ("Line 3", _line3Color);
  }

  List<RouteSegment> _buildSegments(RouteInfo route) {
    List<RouteSegment> segments = [];
    List<String> currentSegment = [];

    for (String station in route.path) {
      currentSegment.add(station);
      if (route.transStations.contains(station) && currentSegment.length > 1) {
        var lineInfo = _getLineInfo(currentSegment);
        segments.add(RouteSegment(
          lineName: lineInfo.$1,
          lineColor: lineInfo.$2,
          stations: List.from(currentSegment),
        ));
        currentSegment = [station];
      }
    }

    if (currentSegment.length > 1 || segments.isEmpty) {
      var lineInfo = _getLineInfo(currentSegment);
      segments.add(RouteSegment(
        lineName: lineInfo.$1,
        lineColor: lineInfo.$2,
        stations: currentSegment,
      ));
    }
    return segments;
  }

  String _timeText(int minutes) {
    if (minutes < 60) return '$minutes min';
    final h = minutes ~/ 60;
    final m = minutes - h * 60;
    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header (Summary) ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${widget.index + 1}',
                        style: const TextStyle(color: textWhite, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Route Summary',
                          style: TextStyle(color: textWhite, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.schedule, size: 14, color: Colors.blue[300]),
                            const SizedBox(width: 4),
                            Text(
                              _timeText(widget.route.time),
                              style: const TextStyle(color: textGrey, fontSize: 13),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.train, size: 14, color: Colors.green[300]),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.route.path.length} stats',
                              style: const TextStyle(color: textGrey, fontSize: 13),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.swap_horiz, size: 14, color: Colors.orange[300]),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.route.transStations.length} trans',
                              style: const TextStyle(color: textGrey, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.route.price} EGP',
                    style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.05), height: 1),

          // ── Timeline Segments ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: List.generate(segments.length, (index) {
                final segment = segments[index];
                final isLastSegment = index == segments.length - 1;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Segment Header (Toggle Button)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: bgDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: segment.lineColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: segment.lineColor),
                                ),
                                child: Text(
                                  segment.lineName.replaceAll('Line ', ''),
                                  style: TextStyle(color: segment.lineColor, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${segment.lineName} Direction',
                                style: const TextStyle(color: textWhite, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Obx(() => GestureDetector(
                            onTap: () => segment.isExpanded.toggle(),
                            child: Text(
                              segment.isExpanded.value ? '- Less details' : '+ More details',
                              style: const TextStyle(color: textGrey, fontSize: 13),
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Segment Timeline
                    Obx(() => _buildTimelineSegment(
                      segment: segment,
                      isLastSegment: isLastSegment,
                    )),

                    // Transfer Divider
                    if (!isLastSegment)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: bgDark,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              '⇆ Change the direction ⇆',
                              style: TextStyle(color: textGrey, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSegment({
    required RouteSegment segment,
    required bool isLastSegment,
  }) {
    final stations = segment.stations;

    return Column(
      children: List.generate(stations.length, (i) {
        final station = stations[i];
        final isFirst = i == 0;
        final isLast = i == stations.length - 1;

        if (!segment.isExpanded.value && !isFirst && !isLast) {
          if (i == 1) return _buildDottedLine(segment.lineColor);
          return const SizedBox.shrink();
        }

        return _buildStationRow(
          stationName: _capitalize(station),
          lineColor: segment.lineColor,
          isFirst: isFirst,
          isLast: isLast,
          isAbsoluteLast: isLastSegment && isLast,
          isTransfer: widget.route.transStations.contains(station) && isLast && !isLastSegment,
        );
      }),
    );
  }

  Widget _buildDottedLine(Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 11, bottom: 4, top: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Container(width: 4, height: 4, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(height: 6),
            Container(width: 4, height: 4, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(height: 6),
            Container(width: 4, height: 4, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          ],
        ),
      ),
    );
  }

  Widget _buildStationRow({
    required String stationName,
    required Color lineColor,
    required bool isFirst,
    required bool isLast,
    required bool isAbsoluteLast,
    required bool isTransfer,
  }) {
    final bool isMajorNode = isFirst || isLast;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 26,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: isMajorNode ? 18 : 12,
                height: isMajorNode ? 18 : 12,
                decoration: BoxDecoration(
                  color: isMajorNode ? lineColor : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: lineColor, width: 3),
                ),
              ),
              if (!isLast)
                Container(
                  width: 3,
                  height: 30,
                  color: lineColor,
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  stationName,
                  style: TextStyle(
                    color: textWhite,
                    fontSize: isMajorNode ? 15 : 14,
                    fontWeight: isMajorNode ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (isTransfer)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: bgDark,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    child: const Icon(Icons.swap_vert, color: Colors.white, size: 16),
                  ),
                if (isAbsoluteLast)
                  const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 22),
              ],
            ),
          ),
        ),
      ],
    );
  }
}