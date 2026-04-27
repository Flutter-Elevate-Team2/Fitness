
import 'package:fitness_app/Features/profile/data/models/edit_profile_request.dart';
sealed class EditProfileEvents {
}
class EditProfileEvent extends EditProfileEvents {
  final EditProfileRequest request;
  EditProfileEvent(this.request);

}
