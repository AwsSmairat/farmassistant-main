import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../../../auth/domain/usecases/sign_out.dart';
import '../../domain/entities/profile.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

/// Profile tab: view only — profile image placeholder and username, phone, email.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..load(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: LiquidGlassAppBar(
          title: const Text('الملف الشخصي'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push('/settings'),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await getIt<SignOut>().call();
                if (context.mounted) context.go('/login');
              },
            ),
          ],
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is ProfileFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.read<ProfileCubit>().load(),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }
            if (state is ProfileLoaded || state is ProfileUpdating) {
              final profile = state is ProfileLoaded
                  ? state.profile
                  : (state as ProfileUpdating).profile;
              return _ProfileView(profile: profile);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView({required this.profile});

  final Profile profile;

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  File? _pickedImage;
  bool _picking = false;

  Future<void> _pickImage() async {
    if (_picking) return;
    setState(() => _picking = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (mounted) {
        setState(() => _picking = false);
        final hasFile = result != null && result.files.isNotEmpty;
        final path = hasFile ? result.files.first.path : null;
        if (path != null && path.isNotEmpty) {
          setState(() => _pickedImage = File(path));
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => _picking = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر اختيار الصورة'),
            backgroundColor: AppColors.surface,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Center(
            child: _ProfileImagePlaceholder(
              imageFile: _pickedImage,
              isLoading: _picking,
              onTap: _pickImage,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'اضغط لإضافة صورة',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _ProfileTile(
            icon: Icons.person_outline,
            label: 'اسم المستخدم',
            value: widget.profile.username,
          ),
          const SizedBox(height: 16),
          _ProfileTile(
            icon: Icons.phone_outlined,
            label: 'رقم الهاتف',
            value: widget.profile.phone.isEmpty ? '—' : widget.profile.phone,
          ),
          const SizedBox(height: 16),
          _ProfileTile(
            icon: Icons.email_outlined,
            label: 'البريد الإلكتروني',
            value: widget.profile.email,
          ),
        ],
      ),
    );
  }
}

/// Profile photo: tappable to pick from gallery. Shows placeholder or selected image.
class _ProfileImagePlaceholder extends StatelessWidget {
  const _ProfileImagePlaceholder({
    this.imageFile,
    this.isLoading = false,
    required this.onTap,
  });

  final File? imageFile;
  final bool isLoading;
  final VoidCallback onTap;

  static const double _size = 120;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              )
            : imageFile != null
                ? Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                    width: _size,
                    height: _size,
                  )
                : Icon(
                    Icons.person,
                    size: 56,
                    color: AppColors.textMuted,
                  ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
