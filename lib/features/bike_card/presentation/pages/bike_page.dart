// presentation/pages/bike_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/bike_card/presentation/providers/state/bike_state.dart';

import 'package:flutter_application_1/features/bike_card/presentation/view_model/bike_viewmodel.dart';
import 'package:flutter_application_1/features/bike_card/presentation/widget/bike_widget.dart';
// presentation/pages/bike_page.dart
// ✅ ADD
// ✅ ADD
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BikeListPage extends ConsumerWidget {
  const BikeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bikeViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF13151F), // dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF13151F),
        elevation: 0,
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
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, BikeState state) {
    switch (state.status) {
      // ── Loading ──────────────────────────────────────────────────
      case BikeStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFE91E8C)),
        );

      // ── Error ────────────────────────────────────────────────────
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

      // ── Loaded ───────────────────────────────────────────────────
      case BikeStatus.loaded:
        if (state.bikes.isEmpty) {
          return const Center(
            child: Text(
              'No bikes available',
              style: TextStyle(color: Colors.white54),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          itemCount: state.bikes.length,
          itemBuilder: (context, index) {
            final bike = state.bikes[index];
            return BikeCard(
              bike: bike,
              onTap: () {
                // TODO: navigate to bike detail page
              },
            );
          },
        );

      // ── Initial ──────────────────────────────────────────────────
      case BikeStatus.initial:
        return const SizedBox.shrink();
    }
  }
}
