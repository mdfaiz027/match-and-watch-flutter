import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/database/app_database.dart';
import '../../../core/repositories/user_repository.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState {
  final List<User> users;
  UserLoaded(this.users);
  @override
  List<Object?> get props => [users];
}
class UserError extends UserState {
  final String message;
  UserError(this.message);
  @override
  List<Object?> get props => [message];
}

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;
  StreamSubscription? _subscription;

  UserCubit(this._repository) : super(UserInitial());

  void loadUsers() {
    emit(UserLoading());
    _subscription?.cancel();
    _subscription = _repository.watchUsers().listen(
      (users) {
        emit(UserLoaded(users));
      },
      onError: (e) => emit(UserError(e.toString())),
    );
    _repository.refreshUsers();
  }

  Future<void> addUser({
    required String firstName,
    required String lastName,
    required String movieTaste,
  }) async {
    try {
      await _repository.createUser(
        firstName: firstName,
        lastName: lastName,
        movieTaste: movieTaste,
      );
    } catch (e) {
      emit(UserError('Failed to add user locally'));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
