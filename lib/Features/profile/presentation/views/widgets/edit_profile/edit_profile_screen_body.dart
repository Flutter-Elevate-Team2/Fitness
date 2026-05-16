import 'package:fitness_app/Features/profile/presentation/views/widgets/edit_profile/edit_profile_form.dart';
import 'package:fitness_app/Features/profile/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';

class EditProfileScreenBody extends StatelessWidget {
  final UserEntity user;

  const EditProfileScreenBody({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            EditProfileForm(user: user),
          ],
        ),
      ),
    );
  }
}
