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
class UserAdding extends UserState {}
class UserLoaded extends UserState {
  final List<UserWithMovieCount> users;
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
  int _currentPage = 1;
  bool _isFetchingNextPage = false;

  UserCubit(this._repository) : super(UserInitial());

  void loadUsers() async {
    final bool hasData = state is UserLoaded && (state as UserLoaded).users.isNotEmpty;
    if (!hasData) {
      emit(UserLoading());
    }

    _subscription?.cancel();
    _subscription = _repository.watchUsersWithMovieCount().listen(
      (users) {
        // Only transition to Loaded if we have data OR if we aren't currently waiting for the initial sync
        if (users.isNotEmpty || state is! UserLoading) {
          emit(UserLoaded(users));
        }
      },
      onError: (e) => emit(UserError(e.toString())),
    );
    try {
      await _repository.refreshUsers(page: 1, silent: hasData);
    } catch (e) {
      if (state is UserLoading || (state is UserLoaded && (state as UserLoaded).users.isEmpty)) {
        emit(UserError(e.toString()));
      }
    } finally {
      // Transition to Loaded if we are still in Loading to stop shimmer
      if (state is UserLoading) {
        emit(UserLoaded(const []));
      }
    }
  }

  Future<void> loadNextPage() async {
    if (_isFetchingNextPage) return;
    _isFetchingNextPage = true;
    _currentPage++;
    try {
      await _repository.refreshUsers(page: _currentPage);
    } catch (e) {
      // For pagination, we don't necessarily want to show a full-screen error
      // if we already have some data. We just log it or handle silently.
      _currentPage--; // Revert page increment on failure
    } finally {
      _isFetchingNextPage = false;
    }
  }

  Future<void> createUser({
    required String fullName,
    required String movieTaste,
  }) async {
    final previousState = state;
    emit(UserAdding());
    try {
      await _repository.createUser(
        fullName: fullName,
        movieTaste: movieTaste,
      );
      // Restore previous state (likely UserLoaded) so the UI continues to function
      if (previousState is UserLoaded) {
        emit(previousState);
      }
    } catch (e) {
      emit(UserError('Failed to add user: ${e.toString()}'));
    }
  }

  Stream<int> getSavedMovieCount(int userId) => _repository.watchSavedMovieCount(userId);
  Stream<User?> watchUserById(int userId) => _repository.watchUserById(userId);

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
