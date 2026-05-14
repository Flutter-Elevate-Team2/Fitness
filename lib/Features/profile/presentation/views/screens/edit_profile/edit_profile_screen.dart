import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/edit_profile_screen_body.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/user_entity.dart';

class EditProfileScreen extends StatelessWidget {
  final UserEntity user;

  const EditProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      backgroundImage: Assets.images.food.path,
      title: Text(context.l10n.editProfile),
      body: EditProfileScreenBody(user: user),
    );
  }
}
