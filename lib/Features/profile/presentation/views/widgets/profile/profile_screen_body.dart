import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_setting_section.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_user_card.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/widget/shared_scaffold.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class ProfileScreenBody extends StatelessWidget {
  final UserEntity user;

  const ProfileScreenBody({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
       backgroundImage: Assets.images.food.path,
      title: Text(context.l10n.profile),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileUserCard(user: user),
            const SizedBox(height: 16),
            ProfileSettingSection()
          ],
        ),
      ),
    );
  }
}
