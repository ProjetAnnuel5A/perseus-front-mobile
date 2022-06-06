import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/common/secure_storage.dart';
import 'package:perseus_front_mobile/model/profile.dart';
import 'package:perseus_front_mobile/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<ProfileStarted>((event, emit) async {
      final profileId = await _storage.getUserId();
      final jwt = await _storage.getToken();

      if (profileId != null && jwt != null) {
        final profile = await _profileRepository.getById(profileId, jwt);

        if (profile != null) {
          emit(ProfileLoaded(profile));
        } else {
          // error state
        }
      }
    });

    add(ProfileStarted());
  }

  final _storage = SecureStorage();
  final ProfileRepository _profileRepository;
}
