import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/admin/domain/entites/bike_entity.dart';
import 'package:flutter_application_1/features/admin/presentation/viewmodel/bike_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class BikeFormWidget extends ConsumerStatefulWidget {
  final BikeEntity? existingBike;
  const BikeFormWidget({super.key, this.existingBike});

  @override
  ConsumerState<BikeFormWidget> createState() => _BikeFormWidgetState();
}

class _BikeFormWidgetState extends ConsumerState<BikeFormWidget> {
  final _nameCtrl    = TextEditingController();
  final _brandCtrl   = TextEditingController();
  final _priceCtrl   = TextEditingController();
  final _engineCtrl  = TextEditingController();
  final _milageCtrl  = TextEditingController();
  bool _isAvailable  = true;
  File? _imageFile;

  bool get _isEditing => widget.existingBike != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final b       = widget.existingBike!;
      _nameCtrl.text   = b.name;
      _brandCtrl.text  = b.brand;
      _priceCtrl.text  = b.price;
      _engineCtrl.text = b.engineCC.toString();
      _milageCtrl.text = b.milage;
      _isAvailable     = b.isAvailable;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _brandCtrl.dispose();
    _priceCtrl.dispose();
    _engineCtrl.dispose();
    _milageCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void _submit() {
    final vm = ref.read(bikeViewModelProvider.notifier);

    if (_isEditing) {
      vm.updateBike(
        id:          widget.existingBike!.id!,
        name:        _nameCtrl.text.trim(),
        brand:       _brandCtrl.text.trim(),
        price:       _priceCtrl.text.trim(),
        engineCC:    int.tryParse(_engineCtrl.text.trim()) ?? 0,
        milage:      _milageCtrl.text.trim(),
        isAvailable: _isAvailable,
        imageFile:   _imageFile,
      );
    } else {
      vm.createBike(
        name:        _nameCtrl.text.trim(),
        brand:       _brandCtrl.text.trim(),
        price:       _priceCtrl.text.trim(),
        engineCC:    int.tryParse(_engineCtrl.text.trim()) ?? 0,
        milage:      _milageCtrl.text.trim(),
        isAvailable: _isAvailable,
        imageFile:   _imageFile,
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isEditing ? 'Edit Bike' : 'Add Bike',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _field(_nameCtrl,   'Name'),
            _field(_brandCtrl,  'Brand'),
            _field(_priceCtrl,  'Price'),
            _field(_engineCtrl, 'Engine CC', keyboard: TextInputType.number),
            _field(_milageCtrl, 'Milage'),
            SwitchListTile(
              title: const Text('Available'),
              value: _isAvailable,
              onChanged: (val) => setState(() => _isAvailable = val),
            ),
            const SizedBox(height: 8),
            // Image picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : widget.existingBike?.imageUrl != null
                        ? Image.network(widget.existingBike!.imageUrl!,
                            fit: BoxFit.cover)
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 32),
                                Text('Tap to select image'),
                              ],
                            ),
                          ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text(_isEditing ? 'Update Bike' : 'Add Bike'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: c,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}