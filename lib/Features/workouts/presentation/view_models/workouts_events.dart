sealed class WorkoutsEvent {}

class FetchMuscleGroupsEvent extends WorkoutsEvent {}

class FetchMusclesByGroupEvent extends WorkoutsEvent {
  final String groupId;

  FetchMusclesByGroupEvent(this.groupId);
}
