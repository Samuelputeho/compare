import 'dart:io';

import 'package:compareitr/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:compareitr/core/usecase/usecase.dart';
import 'package:compareitr/core/common/entities/user_entity.dart';
import 'package:compareitr/features/auth/domain/usecases/current_user.dart';
import 'package:compareitr/features/auth/domain/usecases/update_user.dart';
import 'package:compareitr/features/auth/domain/usecases/user_login.dart';
import 'package:compareitr/features/auth/domain/usecases/user_sign_up.dart';
import 'package:compareitr/features/auth/domain/usecases/logout_usecase.dart';
// New import
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final LogoutUsecase _logoutUsecase;
  final UpdateUserProfile _updateUserProfile; // New use case
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required LogoutUsecase logoutUsecase,
    required UpdateUserProfile updateUserProfile, // New use case
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _logoutUsecase = logoutUsecase,
        _updateUserProfile = updateUserProfile, // New use case
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthLogout>(_onAuthLogout);
    on<AuthUpdateProfile>(_onAuthUpdateProfile); // New event handler
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignUp(
      UserSignUpParams(
        password: event.password,
        name: event.name,
        email: event.email,
        phoneNumber: event.phoneNumber,
        street: event.street,
        location: event.location,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthLogout(AuthLogout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _logoutUsecase();

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) {
        _appUserCubit.updateUser(null); // Clear user data
        emit(AuthInitial()); // Reset to initial state
      },
    );
  }

  void _onAuthUpdateProfile(
      AuthUpdateProfile event, Emitter<AuthState> emit) async {
    emit(AuthLoading()); // Show loading while updating the profile

    final res = await _updateUserProfile(UpdateUserProfileParams(
      userId: event.userId,
      name: event.name,
      email: event.email,
      street: event.street,
      location: event.location,
      phoneNumber: event.phoneNumber,
      imagePath: event.imagePath, // New profile image
    ));

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) {
        // Profile updated successfully
        _appUserCubit.updateUser(UserEntity(
          id: event.userId,
          email: event.email,
          name: event.name,
          street: event.street,
          location: event.location,
          phoneNumber: event.phoneNumber,
          proPic: event.imagePath
              .path, // Assuming imagePath is the path of the updated image
        ));
        emit(AuthSuccess(UserEntity(
          id: event.userId,
          name: event.name,
          street: event.street,
          email: event.email,
          location: event.location,
          phoneNumber: event.phoneNumber,
          proPic: event.imagePath.path,
        )));
      },
    );
  }

  void _emitAuthSuccess(UserEntity user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
