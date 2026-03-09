import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/admin/presentation/viewmodel/bike_viewmodel.dart';
import 'package:flutter_application_1/features/admin/presentation/provider/state/bike_state.dart';
import 'package:flutter_application_1/features/admin/presentation/widget/bike_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminBikePage extends ConsumerStatefulWidget {
  const AdminBikePage({super.key});

  @override
  ConsumerState<AdminBikePage> createState() => _AdminBikePageState();
}

class _AdminBikePageState extends ConsumerState<AdminBikePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(bikeViewModelProvider.notifier).fetchAllBikes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bikeViewModelProvider);

    ref.listen<BikeState>(bikeViewModelProvider, (_, next) {
      if (next.isSuccess && next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
      }
      if (next.isFailure && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Bikes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.bikes.isEmpty
              ? const Center(child: Text('No bikes found.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: state.bikes.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final bike = state.bikes[index];
                    return ListTile(
                      leading: bike.imageUrl != null
                          ? Image.network(
                              bike.imageUrl!,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.two_wheeler, size: 40),
                            )
                          : const Icon(Icons.two_wheeler, size: 40),
                      title: Text('${bike.brand} ${bike.name}'),
                      subtitle: Text(
                        'Rs. ${bike.price}  •  ${bike.engineCC}cc  •  ${bike.milage}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _openForm(context, bike: bike),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, bike.id!),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  void _openForm(BuildContext context, {bike}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BikeFormWidget(existingBike: bike),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Bike'),
        content: const Text('Are you sure you want to delete this bike?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(bikeViewModelProvider.notifier).deleteBike(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}