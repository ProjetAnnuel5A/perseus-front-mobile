import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perseus_front_mobile/common/error/exceptions.dart';
import 'package:perseus_front_mobile/common/extensions.dart';
import 'package:perseus_front_mobile/common/secure_storage.dart';
import 'package:perseus_front_mobile/model/dto/profile_update_dto.dart';
import 'package:perseus_front_mobile/model/enum/level.dart';
import 'package:perseus_front_mobile/model/enum/objective.dart';
import 'package:perseus_front_mobile/model/profile.dart';
import 'package:perseus_front_mobile/repositories/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._profileRepository) : super(ProfileInitial()) {
    on<ProfileStarted>((event, emit) async {
      emit(ProfileLoading());

      final profileId = await _storage.getUserId();

      if (profileId != null) {
        try {
          final profile = await _profileRepository.getById(profileId);

          emit(ProfileLoaded(profile));
        } catch (e) {
          print(e.toString());

          if (e is HttpException) {
            emit(ProfileError(e));
          } else {
            emit(ProfileError(ExceptionUnknown()));
          }
        }
      } else {
        // error jwt
      }
    });

    on<HeightChanged>((event, emit) async {
      emit(ProfileLoaded(event.profile.copyWith(height: event.height)));
    });

    on<WeightChanged>((event, emit) async {
      emit(ProfileLoaded(event.profile.copyWith(weight: event.weight)));
    });

    on<BirthDateChanged>((event, emit) async {
      emit(ProfileLoaded(event.profile.copyWith(birthDate: event.birthDate)));
    });

    on<LevelChanged>((event, emit) async {
      emit(ProfileLoaded(event.profile.copyWith(level: event.level)));
    });

    on<ObjectiveChanged>((event, emit) async {
      emit(ProfileLoaded(event.profile.copyWith(objective: event.objective)));
    });

    on<AvailabilityChanged>((event, emit) async {
      emit(
        ProfileLoaded(event.profile.copyWith(availability: event.availability)),
      );
    });

    on<ProfileUpdate>((event, emit) async {
      emit(ProfileLoading());

      final profileId = await _storage.getUserId();

      if (profileId != null) {
        try {
          final birthDate = event.profile.birthDate.toString().substring(0, 10);
          final level = event.profile.level.toShortString();
          final objective = event.profile.objective.toShortString();

          final profileUpdateDto = ProfileUpdateDto(
            birthDate,
            event.profile.height,
            event.profile.weight,
            event.profile.availability,
            objective,
            level,
          );

          await _profileRepository.update(profileId, profileUpdateDto);

          emit(ProfileLoaded(event.profile));
        } catch (e) {
          print(e.toString());

          if (e is HttpException) {
            emit(ProfileError(e));
          } else {
            emit(ProfileError(ExceptionUnknown()));
          }
        }
      } else {
        // error jwt
      }
    });

    add(ProfileStarted());
  }

  final _storage = SecureStorage();
  final ProfileRepository _profileRepository;
}
