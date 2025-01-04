part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String street;
  final String location;
  final int phoneNumber;
  

  AuthSignUp(
      {required this.email,
      required this.password,
      required this.name,
      required this.street,
      required this.location,
      required this.phoneNumber,
      });
}

final class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
}

final class AuthIsUserLoggedIn extends AuthEvent {}

final class AuthLogout extends AuthEvent {}

final class AuthUpdateProfile extends AuthEvent {
  // New event
  final String userId;
  final String name;
  final String email;
  final String street;
  final String location;
  final int phoneNumber;
  final File imagePath;

  AuthUpdateProfile({
    required this.userId,
    required this.name,
    required this.email,
    required this.street,
    required this.location,
    required this.phoneNumber,
    required this.imagePath,
  });
}
