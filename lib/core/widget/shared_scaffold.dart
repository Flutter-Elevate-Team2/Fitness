import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class SharedScaffold extends StatelessWidget {
  final String? headerImage;
  final Widget? appBarContent;
  final bool showBackButton;
  final Widget body;

  const SharedScaffold({
    super.key,
     this.headerImage,
    this.appBarContent,
    this.showBackButton = true,
    required this.body,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        automaticallyImplyLeading: showBackButton,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: headerImage != null
            ? Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(headerImage!),
              fit: BoxFit.cover,
            ),
          ),
        )
            : null,
           leading:showBackButton ? Padding(
             padding: const EdgeInsets.all(8.0),
             child: GestureDetector(
               onTap: () => Navigator.of(context).pop(),
               child: Container(
                 decoration: BoxDecoration(
                   color: AppColors.primary,
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child: Icon(
                   Icons.arrow_back_ios_new,
                 ),
               ),
             ),
           )
             : null,
        title: appBarContent,
        centerTitle: true,
      ),
      extendBodyBehindAppBar: headerImage != null,
      body: body,
    );
  }
}