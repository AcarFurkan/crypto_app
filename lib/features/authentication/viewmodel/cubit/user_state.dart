part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserNull extends UserState {}

class UserLoading extends UserState {}

class UserError extends UserState {
 final String message;
  UserError({
    required this.message,
  });
}

class UserUpdate extends UserState {}

class UserFull extends UserState {
 final MyUser user;
  UserFull({
    required this.user,
  });
}
