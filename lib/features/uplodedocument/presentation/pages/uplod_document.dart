import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/uplodedocument/presentation/view_models/uplode_documnet_viewmodel.dart';
import 'package:flutter_application_1/features/uplodedocument/presentation/widgets/document_field_widget.dart';
import 'package:flutter_application_1/features/uplodedocument/presentation/widgets/document_image_picker_widget.dart';
import 'package:flutter_application_1/features/uplodedocument/presentation/widgets/document_section_header_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_application_1/features/uplodedocument/domain/entites/uplodedocument_entity.dart';
import 'package:flutter_application_1/features/uplodedocument/presentation/providers/state/uplode_document_state.dart';


class UploadDocumentPage extends ConsumerStatefulWidget {
  const UploadDocumentPage({super.key});

  @override
  ConsumerState<UploadDocumentPage> createState() =>
      _UploadDocumentPageState();
}

class _UploadDocumentPageState extends ConsumerState<UploadDocumentPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _nationalIdController = TextEditingController();

  String? _licenseImagePath;
  String? _nationalIdImagePath;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _licenseNumberController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  // ─── Validators ───────────────────────────────────────────
  String? _validateFullName(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Full name is required' : null;

  String? _validatePhone(String? v) =>
      (v == null || v.trim().length < 10)
          ? 'Phone must be at least 10 digits'
          : null;

  String? _validateLicense(String? v) {
    if (v == null || !RegExp(r'^\d{2}-\d{2}-\d{8}$').hasMatch(v)) {
      return 'Format: 01-06-01234567';
    }
    return null;
  }

  String? _validateNationalId(String? v) {
    if (v == null || !RegExp(r'^\d{2}-\d{2}-\d{2}-\d{5}$').hasMatch(v)) {
      return 'Format: 01-02-03-12345';
    }
    return null;
  }

  // ─── Image Picker ─────────────────────────────────────────
  Future<void> _pickImage(String type) async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() {
      if (type == 'license') {
        _licenseImagePath = picked.path;
      } else {
        _nationalIdImagePath = picked.path;
      }
    });
  }

  // ─── Submit ───────────────────────────────────────────────
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_licenseImagePath == null) {
      _showSnack('Please upload your driving license image');
      return;
    }
    if (_nationalIdImagePath == null) {
      _showSnack('Please upload your national ID image');
      return;
    }

    final entity = UplodeDocumentEntity(
      fullname: _fullNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      drivingLicense: _licenseNumberController.text.trim(),
      drivingLicenseImageUrl: _licenseImagePath!,
      nationalId: _nationalIdController.text.trim(),
      nationalIdImageUrl: _nationalIdImagePath!,
    );

    await ref
        .read(uploadDocumentViewModelProvider.notifier)
        .createDocument(entity);

    final docState = ref.read(uploadDocumentViewModelProvider);
    if (docState.status == UploadDocumentStatus.success && mounted) {
      _showSnack('✅ Documents submitted successfully!', isError: false);
      Navigator.pop(context);
    }
  }

  void _showSnack(String msg, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            isError ? Colors.redAccent : const Color(0xFF2ECC71),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ── Listen for success / error (same pattern as BikeCard) ──
    ref.listen<UploadDocumentState>(uploadDocumentViewModelProvider,
        (previous, next) {
      if (next.status == UploadDocumentStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Documents submitted successfully!'),
            backgroundColor: Color(0xFF2ECC71),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      if (next.status == UploadDocumentStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('❌ ${next.errorMessage ?? 'Submission failed'}'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final docState = ref.watch(uploadDocumentViewModelProvider);
    final isUploading = docState.isUploading;

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
          '📄 Upload Documents',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () =>
                ref.read(uploadDocumentViewModelProvider.notifier).reset(),
          ),
        ],
      ),
      body: _buildBody(context, docState, isUploading),
    );
  }

  // ── Body builder (same _buildBody pattern as BikeListPage) ──
  Widget _buildBody(
    BuildContext context,
    UploadDocumentState state,
    bool isUploading,
  ) {
    switch (state.status) {
      // ── Loading ────────────────────────────────────────────
      case UploadDocumentStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFE91E8C)),
        );

      // ── Error ──────────────────────────────────────────────
      case UploadDocumentStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  color: Colors.redAccent, size: 48),
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
                onPressed: () => ref
                    .read(uploadDocumentViewModelProvider.notifier)
                    .clearError(),
                child: const Text(
                  'Try Again',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );

      // ── Initial / Success → show form ─────────────────────
      case UploadDocumentStatus.initial:
      case UploadDocumentStatus.success:
      case UploadDocumentStatus.uploading:
        return _buildForm(isUploading);
    }
  }

  Widget _buildForm(bool isUploading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1E2A),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Personal Info ────────────────────────────
              const DocumentSectionHeader(
                title: 'Personal Information',
                icon: Icons.person_outline_rounded,
              ),
              DocumentFormField(
                controller: _fullNameController,
                label: 'Full Name',
                hint: 'John Doe',
                validator: _validateFullName,
                prefixIcon: Icons.badge_outlined,
              ),
              DocumentFormField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: '98XXXXXXXX',
                validator: _validatePhone,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_outlined,
              ),

              // ── Driving License ──────────────────────────
              const DocumentSectionHeader(
                title: 'Driving License',
                icon: Icons.credit_card_outlined,
              ),
              DocumentFormField(
                controller: _licenseNumberController,
                label: 'License Number',
                hint: '01-06-01234567',
                validator: _validateLicense,
                prefixIcon: Icons.numbers_outlined,
              ),
              DocumentImagePickerCard(
                label: 'Upload License Image',
                imagePath: _licenseImagePath,
                onTap: () => _pickImage('license'),
              ),

              // ── National ID ──────────────────────────────
              const DocumentSectionHeader(
                title: 'National ID',
                icon: Icons.fingerprint_rounded,
              ),
              DocumentFormField(
                controller: _nationalIdController,
                label: 'National ID Number',
                hint: '01-02-03-12345',
                validator: _validateNationalId,
                prefixIcon: Icons.numbers_outlined,
              ),
              DocumentImagePickerCard(
                label: 'Upload National ID Image',
                imagePath: _nationalIdImagePath,
                onTap: () => _pickImage('nationalId'),
              ),

              const SizedBox(height: 6),
              Divider(color: Colors.white.withOpacity(0.08), height: 1),
              const SizedBox(height: 16),

              // ── Submit Button (matches BikeCard Book Now) ─
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
                  onPressed: isUploading ? null : _submit,
                  child: isUploading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Submit Documents',
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
        ),
      ),
    );
  }
}