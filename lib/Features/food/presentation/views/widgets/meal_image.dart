import 'package:fitness_app/core/extension/context_extention.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'helper/youtube_extension.dart';

class MealImage extends StatelessWidget {
  final String? videoUrl;
  const MealImage({super.key , required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.45,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                /// Image
                Positioned.fill(
                  child: Image.network(
                    videoUrl?.youtubeThumbnail ?? "",
                    fit: BoxFit.cover,
                  ),
                ),

                 Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0.0, 0.3, 0.6,0.8, 1.0],
                        colors: [
                          AppColors.black.withAlpha(200),
                          AppColors.black.withAlpha(100),
                          AppColors.black.withAlpha(50),
                          AppColors.black.withAlpha(10),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
        Positioned.fill(
            child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),

                    onTap: () async {

                      final url = Uri.parse(videoUrl ?? "");

                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            // ignore: use_build_context_synchronously
                            content: Text(context.l10n.couldNotOpenVideo),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.black.withAlpha(60),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(14),
                        child: const Icon(
                          Icons.play_arrow,
                          color: AppColors.primary,
                          size: 45,
                        )
                    ),
                  ),
                )))],

    );
  }
}
