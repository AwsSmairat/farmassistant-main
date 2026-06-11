// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// الملف: profile_page.dart
// المسار: features/profile/presentation/pages/profile_page.dart
// الطبقة: presentation / pages — شاشة
//
// ماذا يفعل؟
//   جزء من ميزة: الملف الشخصي. شاشة واجهة المستخدم.
//
// ماذا بداخله؟
//   • ProfilePage
//   • _ProfileView
//   • _ProfileViewState
//   • _ProfileImagePlaceholder
//   • _ProfileTile
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/storage/profile_local_avatar_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/liquid_glass/liquid_glass.dart';
import '../../../auth/presentation/widgets/logout_icon_button.dart';
import '../../domain/entities/profile.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
/// شاشة الملف الشخصي.
class ProfilePage extends StatelessWidget {
  /// دالة الملف الشخصي صفحة.
  const ProfilePage({super.key});

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..load(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: LiquidGlassAppBar(
          title: const Text('الملف الشخصي'),
          actions: [
          /// دالة أيقونة زر.
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push('/settings'),
            ),
            /// دالة تسجيل خروج أيقونة زر.
            const LogoutIconButton(),
          ],
        ),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              /// دالة center.
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is ProfileFailure) {
              /// دالة center.
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  /// دالة نص.
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                    /// دالة sized box.
                    const SizedBox(height: 16),
                  /// دالة نص زر.
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
              /// دالة داخلية: الملف الشخصي عرض.
              return _ProfileView(profile: profile);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

/// مكوّن واجهة: الملف الشخصي عرض.
class _ProfileView extends StatefulWidget {
  /// دالة داخلية: الملف الشخصي عرض.
  const _ProfileView({required this.profile});

  /// حقل: الملف الشخصي.
  final Profile profile;

  @override
  /// ينشئ الحالة.
  State<_ProfileView> createState() => _ProfileViewState();
}

/// حالة واجهة الملف الشخصي عرض.
class _ProfileViewState extends State<_ProfileView> {
  Uint8List? _pickedImageBytes;
  bool _picking = false;

  @override
  /// يهيّئ الويدجت.
  void initState() {
    super.initState();
  /// دالة داخلية: restore محلي صورة.
    _restoreLocalAvatar();
  }

  @override
  /// يستجيب لتغيّر خصائص الويدجت.
  void didUpdateWidget(covariant _ProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.uid != widget.profile.uid) {
      _pickedImageBytes = null;
    /// دالة داخلية: restore محلي صورة.
      _restoreLocalAvatar();
    }
  }

  /// دالة داخلية: restore محلي صورة.
  Future<void> _restoreLocalAvatar() async {
    final bytes = await ProfileLocalAvatarStore.loadIfExists(widget.profile.uid);
    if (mounted && bytes != null) {
      setState(() => _pickedImageBytes = bytes);
    }
  }

  /// دالة داخلية: pick الصورة.
  Future<void> _pickImage() async {
    if (_picking) return;
  /// يعيّن الحالة.
    setState(() => _picking = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: kIsWeb,
      );
      if (!mounted) return;

      final picked = result != null && result.files.isNotEmpty
          ? result.files.first
          : null;
      Uint8List? stored;
      if (picked != null) {
        stored = await ProfileLocalAvatarStore.persistPick(
          widget.profile.uid,
          path: picked.path,
          bytes: picked.bytes,
        );
      }

      if (!mounted) return;
      setState(() {
        _picking = false;
        if (stored != null) _pickedImageBytes = stored;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _picking = false);
        ScaffoldMessenger.of(context).showSnackBar(
          /// دالة snack شريط.
          const SnackBar(
            content: Text('تعذر اختيار الصورة'),
            backgroundColor: AppColors.surface,
          ),
        );
      }
    }
  }

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// دالة sized box.
          const SizedBox(height: 16),
        /// دالة center.
          Center(
            child: _ProfileImagePlaceholder(
              imageBytes: _pickedImageBytes,
              isLoading: _picking,
              onTap: _pickImage,
            ),
          ),
          /// دالة sized box.
          const SizedBox(height: 8),
        /// دالة center.
          Center(
            child: Text(
              'اضغط لإضافة صورة',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ),
          /// دالة sized box.
          const SizedBox(height: 24),
        /// دالة داخلية: الملف الشخصي tile.
          _ProfileTile(
            icon: Icons.person_outline,
            label: 'اسم المستخدم',
            value: widget.profile.username,
          ),
          /// دالة sized box.
          const SizedBox(height: 16),
        /// دالة داخلية: الملف الشخصي tile.
          _ProfileTile(
            icon: Icons.phone_outlined,
            label: 'رقم الهاتف',
            value: widget.profile.phone.isEmpty ? '—' : widget.profile.phone,
          ),
          /// دالة sized box.
          const SizedBox(height: 16),
        /// دالة داخلية: الملف الشخصي tile.
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
/// كلاس الملف الشخصي الصورة placeholder.
class _ProfileImagePlaceholder extends StatelessWidget {
  /// دالة داخلية: الملف الشخصي الصورة placeholder.
  const _ProfileImagePlaceholder({
    this.imageBytes,
    this.isLoading = false,
    required this.onTap,
  });

  /// حقل: الصورة bytes.
  final Uint8List? imageBytes;
  /// حقل: is تحميل.
  final bool isLoading;
  /// حقل: on tap.
  final VoidCallback onTap;

  /// حقل: size.
  static const double _size = 120;

  @override
  /// يبني شجرة الواجهة (Widget).
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
            /// دالة center.
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
            : imageBytes != null
                ? Image.memory(
                    imageBytes!,
                    fit: BoxFit.cover,
                    width: _size,
                    height: _size,
                    gaplessPlayback: true,
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

/// كلاس الملف الشخصي tile.
class _ProfileTile extends StatelessWidget {
  /// دالة داخلية: الملف الشخصي tile.
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  /// حقل: أيقونة.
  final IconData icon;
  /// حقل: label.
  final String label;
  /// حقل: value.
  final String value;

  @override
  /// يبني شجرة الواجهة (Widget).
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
          /// دالة أيقونة.
            Icon(icon, color: AppColors.primary, size: 24),
            /// دالة sized box.
            const SizedBox(width: 16),
          /// دالة expanded.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                /// دالة نص.
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  /// دالة sized box.
                  const SizedBox(height: 4),
                /// دالة نص.
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
