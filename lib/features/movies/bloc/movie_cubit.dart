import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/database/app_database.dart';
import '../../../core/repositories/movie_repository.dart';

abstract class MovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}
class MovieLoading extends MovieState {}
class MovieLoaded extends MovieState {
  final List<Movie> movies;
  MovieLoaded(this.movies);
  @override
  List<Object?> get props => [movies];
}
class MovieError extends MovieState {
  final String message;
  MovieError(this.message);
  @override
  List<Object?> get props => [message];
}

class MovieCubit extends Cubit<MovieState> {
  final MovieRepository _repository;
  StreamSubscription? _subscription;

  MovieCubit(this._repository) : super(MovieInitial());

  void loadTrendingMovies() {
    emit(MovieLoading());
    _subscription?.cancel();
    _subscription = _repository.watchTrendingMovies().listen(
      (movies) {
        emit(MovieLoaded(movies));
      },
      onError: (e) => emit(MovieError(e.toString())),
    );
    _repository.refreshTrendingMovies();
  }

  Future<void> toggleSave(int userId, Movie movie) async {
    try {
      await _repository.toggleSaveMovie(userId, movie);
    } catch (e) {
      // In a real app, we might emit a temporary error state
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
