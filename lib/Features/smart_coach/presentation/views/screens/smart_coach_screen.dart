import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_state.dart';
import 'package:fitness_app/Features/smart_coach/presentation/view_model/smart_coach_view_model.dart';
import 'package:fitness_app/core/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SmartCoachScreen extends StatelessWidget {
  const SmartCoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SmartCoachViewModel>()..getSmartCoachData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Coach'),
        ),
        body: BlocBuilder<SmartCoachViewModel, SmartCoachState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.errorMessage != null) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            }
            if (state.data != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ID: ${state.data!.id}'),
                    Text('Message: ${state.data!.message}'),
                  ],
                ),
              );
            }
            return const Center(child: Text('Smart Coach Data Placeholder'));
          },
        ),
      ),
    );
  }
}
