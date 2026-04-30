import 'package:fitness_app/Features/profile/presentation/view_model/profile/profile_view_model.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/logout_dialog.dart';
import 'package:fitness_app/Features/profile/presentation/views/widgets/profile/profile_settings_tile.dart';
import 'package:fitness_app/core/app_router/app_router.dart';
import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/l10n/locale_cubit.dart';
import 'package:fitness_app/core/widget/shared_container.dart';
import 'package:fitness_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileSettingSection extends StatefulWidget {
  const ProfileSettingSection({super.key});

  @override
  State<ProfileSettingSection> createState() => _ProfileSettingSectionState();
}

class _ProfileSettingSectionState extends State<ProfileSettingSection> {

  late bool isEnglish;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
     isEnglish = Localizations.localeOf(context).languageCode == 'en';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: SharedContainer(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Edit Profile
            ProfileSettingsTile(
              icon: Assets.icons.profile2.path,
              title: context.l10n.editProfile,
              onTap: () {
                context.pushNamed("/editprofile");
              },
            ),

            // Change Password
            ProfileSettingsTile(
              icon: Assets.icons.change.path,
              title: context.l10n.changePassword,
              onTap: () {
                context.pushNamed(Routes.changePasswordName);
              },
            ),

            // Language
            ProfileSettingsTile(
              icon: Assets.icons.language.path,
              title: context.l10n.selectLanguage,
              isLanguage: true,
              switchValue: isEnglish,
              onSwitchChanged: (value) {
                setState(() {
                  isEnglish = value;
                });
                context.read<LocaleCubit>().toggleLanguage(value);
               },
              onTap: () {},
            ),

            // Security
            ProfileSettingsTile(
              icon: Assets.icons.lockSetting.path,
              title: context.l10n.security,
              onTap: () {},
              webView: 'security',
            ),

            // Policy
            ProfileSettingsTile(
              icon: Assets.icons.securityWarning.path,
              title: context.l10n.privacyPolicy,
              onTap: () {},
              webView: 'privacy-policy',
            ),

            // Help
            ProfileSettingsTile(
              icon: Assets.icons.help.path,
              title: context.l10n.help,
              onTap: () {},
              webView: 'help',
            ),

            // Logout
            ProfileSettingsTile(
              icon: Assets.icons.logout.path,
              title: context.l10n.logout,
              onTap: () => _showLogoutDialog(context),
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => BlocProvider.value(
      value: context.read<ProfileViewModel>(),
      child: const LogoutDialog(),
    ),
  );
}