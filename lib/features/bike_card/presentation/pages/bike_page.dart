// presentation/pages/bike_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/bike_card/domain/entites/bike_entity.dart';
import 'package:flutter_application_1/features/bike_card/presentation/providers/state/bike_state.dart';
import 'package:flutter_application_1/features/bike_card/presentation/view_model/bike_viewmodel.dart';
import 'package:flutter_application_1/features/bike_card/presentation/widget/bike_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BikeListPage extends ConsumerStatefulWidget {
  const BikeListPage({super.key});

  @override
  ConsumerState<BikeListPage> createState() => _BikeListPageState();
}

class _BikeListPageState extends ConsumerState<BikeListPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String? _selectedBrand;
  int? _selectedEngineCC;
  bool? _availabilityFilter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BikeEntity> _applyFilters(List<BikeEntity> bikes) {
    return bikes.where((bike) {
      final q = _searchQuery.toLowerCase();
      final matchesSearch =
          q.isEmpty ||
          bike.name.toLowerCase().contains(q) ||
          bike.brand.toLowerCase().contains(q);
      final matchesBrand =
          _selectedBrand == null || bike.brand == _selectedBrand;
      final matchesCC =
          _selectedEngineCC == null || bike.engineCC == _selectedEngineCC;
      final matchesAvailability =
          _availabilityFilter == null ||
          bike.isAvailable == _availabilityFilter;
      return matchesSearch && matchesBrand && matchesCC && matchesAvailability;
    }).toList();
  }

  void _showFilterSheet(List<BikeEntity> allBikes) {
    final brands = allBikes.map((b) => b.brand).toSet().toList()..sort();
    final engineCCs = allBikes.map((b) => b.engineCC).toSet().toList()..sort();

    String? tempBrand = _selectedBrand;
    int? tempCC = _selectedEngineCC;
    bool? tempAvail = _availabilityFilter;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1E2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed:
                            () => setSheetState(() {
                              tempBrand = null;
                              tempCC = null;
                              tempAvail = null;
                            }),
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: Color(0xFFE91E8C)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Brand
                  const Text(
                    'Brand',
                    style: TextStyle(
                      color: Color(0xFF8A8FA8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(
                        label: 'All',
                        selected: tempBrand == null,
                        onTap: () => setSheetState(() => tempBrand = null),
                      ),
                      ...brands.map(
                        (b) => _FilterChip(
                          label: b,
                          selected: tempBrand == b,
                          onTap: () => setSheetState(() => tempBrand = b),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Engine CC
                  const Text(
                    'Engine CC',
                    style: TextStyle(
                      color: Color(0xFF8A8FA8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChip(
                        label: 'All',
                        selected: tempCC == null,
                        onTap: () => setSheetState(() => tempCC = null),
                      ),
                      ...engineCCs.map(
                        (cc) => _FilterChip(
                          label: '${cc}cc',
                          selected: tempCC == cc,
                          onTap: () => setSheetState(() => tempCC = cc),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Availability
                  const Text(
                    'Availability',
                    style: TextStyle(
                      color: Color(0xFF8A8FA8),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: [
                      _FilterChip(
                        label: 'All',
                        selected: tempAvail == null,
                        onTap: () => setSheetState(() => tempAvail = null),
                      ),
                      _FilterChip(
                        label: '✓ Available',
                        selected: tempAvail == true,
                        activeColor: const Color(0xFF2ECC71),
                        onTap: () => setSheetState(() => tempAvail = true),
                      ),
                      _FilterChip(
                        label: 'Unavailable',
                        selected: tempAvail == false,
                        activeColor: const Color(0xFFE74C3C),
                        onTap: () => setSheetState(() => tempAvail = false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E8C),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedBrand = tempBrand;
                          _selectedEngineCC = tempCC;
                          _availabilityFilter = tempAvail;
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bikeViewModelProvider);
    final activeFilterCount =
        [
          _selectedBrand,
          _selectedEngineCC,
          _availabilityFilter,
        ].where((f) => f != null).length;

    return Scaffold(
      backgroundColor: const Color(0xFF13151F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF13151F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '🏍️ Rent a Bike',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed:
                () => ref.read(bikeViewModelProvider.notifier).getAllBikes(),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Search + Filter Bar ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1E2A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Search by name or brand...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF8A8FA8),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF8A8FA8),
                          size: 20,
                        ),
                        suffixIcon:
                            _searchQuery.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Color(0xFF8A8FA8),
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                                : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () => _showFilterSheet(state.bikes),
                      child: Container(
                        height: 46,
                        width: 46,
                        decoration: BoxDecoration(
                          color:
                              activeFilterCount > 0
                                  ? const Color(0xFFE91E8C)
                                  : const Color(0xFF1C1E2A),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    if (activeFilterCount > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$activeFilterCount',
                              style: const TextStyle(
                                color: Color(0xFFE91E8C),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // ── Active filter tags ───────────────────────────────────
          if (activeFilterCount > 0)
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  if (_selectedBrand != null)
                    _ActiveFilterTag(
                      label: _selectedBrand!,
                      onRemove: () => setState(() => _selectedBrand = null),
                    ),
                  if (_selectedEngineCC != null)
                    _ActiveFilterTag(
                      label: '${_selectedEngineCC}cc',
                      onRemove: () => setState(() => _selectedEngineCC = null),
                    ),
                  if (_availabilityFilter != null)
                    _ActiveFilterTag(
                      label: _availabilityFilter! ? 'Available' : 'Unavailable',
                      onRemove:
                          () => setState(() => _availabilityFilter = null),
                    ),
                ],
              ),
            ),

          // ── Body ─────────────────────────────────────────────────
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  Widget _buildBody(BikeState state) {
    switch (state.status) {
      case BikeStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFE91E8C)),
        );

      case BikeStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                state.errorMessage ?? 'Something went wrong',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E8C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed:
                    () =>
                        ref.read(bikeViewModelProvider.notifier).getAllBikes(),
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );

      case BikeStatus.loaded:
        final filtered = _applyFilters(state.bikes);
        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search_off,
                  color: Color(0xFF8A8FA8),
                  size: 52,
                ),
                const SizedBox(height: 12),
                const Text(
                  'No bikes match your filters',
                  style: TextStyle(color: Colors.white54, fontSize: 15),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed:
                      () => setState(() {
                        _searchQuery = '';
                        _searchController.clear();
                        _selectedBrand = null;
                        _selectedEngineCC = null;
                        _availabilityFilter = null;
                      }),
                  child: const Text(
                    'Clear all filters',
                    style: TextStyle(color: Color(0xFFE91E8C)),
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          itemCount: filtered.length,
          itemBuilder:
              (context, index) => BikeCard(bike: filtered[index], onTap: () {}),
        );

      case BikeStatus.initial:
        return const SizedBox.shrink();
    }
  }
}

// ── Filter Chip ───────────────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color activeColor;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.activeColor = const Color(0xFFE91E8C),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? activeColor : const Color(0xFF2A2D3E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? activeColor : Colors.white12,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF8A8FA8),
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ── Active Filter Tag ─────────────────────────────────────────────────────────
class _ActiveFilterTag extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _ActiveFilterTag({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8, top: 4, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E8C).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE91E8C), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFE91E8C),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: Color(0xFFE91E8C)),
          ),
        ],
      ),
    );
  }
}
