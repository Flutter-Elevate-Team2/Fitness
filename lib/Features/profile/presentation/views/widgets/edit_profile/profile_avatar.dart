import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_events.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_states.dart';
import 'package:fitness_app/Features/profile/presentation/view_model/edit_profile/edit_profile_view_model.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';


class ProfileAvatar extends StatefulWidget {
  final String? photoUrl;
  const ProfileAvatar({super.key, this.photoUrl});

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? _localImage;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileViewModel, EditProfileStates>(
      listenWhen: (previous, current) {
        return previous.uploadPhotoState?.errorMessage !=
            current.uploadPhotoState?.errorMessage &&
            current.uploadPhotoState?.errorMessage != null;
      },
      listener: (context, state) {
        setState(() {
          _localImage = null;
        });
      },
      buildWhen: (previous, current) {
        return previous.uploadPhotoState != current.uploadPhotoState;
      },
      builder: (context, state) {
        final uploadState = state.uploadPhotoState;
        final isUploading = uploadState?.isLoading ?? false;

        final networkImageUrl = widget.photoUrl;
        return Stack(
          alignment: Alignment.center,
          children: [
            ProfileImageDisplay(
              networkImageUrl: networkImageUrl,
              localImage: _localImage,
              isUploading: isUploading,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: ProfileImagePicker(
                onImageSelected: (file) {
                  setState(() {
                    _localImage = file;
                  });

                  context.read<EditProfileViewModel>().doIntent(
                    UploadPhotoEvent(file),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfileImageDisplay extends StatelessWidget {
  final String? networkImageUrl;
  final File? localImage;
  final bool isUploading;

  const ProfileImageDisplay({
    super.key,
    required this.networkImageUrl,
    this.localImage,
    required this.isUploading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.grayLight,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ProfileImageContent(
              networkImageUrl: networkImageUrl,
              localImage: localImage,
            ),
            if (isUploading) const LoadingOverlay(),
          ],
        ),
      ),
    );
  }
}

class ProfileImageContent extends StatelessWidget {
  final String? networkImageUrl;
  final File? localImage;

  const ProfileImageContent({
    super.key,
    required this.networkImageUrl,
    this.localImage,
  });

  @override
  Widget build(BuildContext context) {
    if (localImage != null) {
      return Image.file(
        localImage!,
        fit: BoxFit.cover,
        key: ValueKey(localImage!.path),
      );
    }

    if (networkImageUrl != null && networkImageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: networkImageUrl ?? '',
        fit: BoxFit.cover,
        placeholder: (context, url) => const ProfilePlaceholder(),
        errorWidget: (context, url, error) => const ProfilePlaceholder(),
      );
    }

    return const ProfilePlaceholder();
  }
}

class ProfilePlaceholder extends StatelessWidget {
  const ProfilePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grayLight,
      child: const Icon(Icons.person, size: 60, color: AppColors.blackSoft),
    );
  }
}

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.black.withValues(alpha: 0.5),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
          strokeWidth: 3,
        ),
      ),
    );
  }
}

class ProfileImagePicker extends StatelessWidget {
  final Function(File) onImageSelected;

  const ProfileImagePicker({super.key, required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(context),
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Icon(Icons.edit, color: AppColors.primary, size: 16),
      ),
    );
  }

  Future<void> _showImageSourceDialog(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) => const ImageSourceBottomSheet(),
    );

    if (source != null) {
      if (!context.mounted) return;
      _pickImage(context, source);
    }
  }

  // coverage:ignore-start
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        onImageSelected(file);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.failedToPickImage),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }
  // coverage:ignore-end
}

class ImageSourceBottomSheet extends StatelessWidget {
  const ImageSourceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.chooseImageSource,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.camera_alt, color: AppColors.primary),
            title: Text(context.l10n.camera),
            onTap: () {
              Navigator.of(context).pop(ImageSource.camera);
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library, color: AppColors.primary),
            title: Text(context.l10n.gallery),
            onTap: () {
              Navigator.of(context).pop(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}
