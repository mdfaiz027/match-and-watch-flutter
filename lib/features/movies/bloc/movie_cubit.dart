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
  int _currentPage = 1;
  bool _isFetchingNextPage = false;

  MovieCubit(this._repository) : super(MovieInitial());

  void loadMovies() {
    emit(MovieLoading());
    _subscription?.cancel();
    _subscription = _repository.watchMovies().listen(
      (movies) {
        emit(MovieLoaded(movies));
      },
      onError: (e) => emit(MovieError(e.toString())),
    );
    _repository.refreshMovies(page: 1);
  }

  Future<void> loadNextPage() async {
    if (_isFetchingNextPage) return;
    _isFetchingNextPage = true;
    _currentPage++;
    await _repository.refreshMovies(page: _currentPage);
    _isFetchingNextPage = false;
  }

  Future<void> loadMovieDetails(int movieId) async {
    await _repository.fetchMovieDetails(movieId);
  }

  Future<void> toggleSave(int userId, Movie movie) async {
    try {
      await _repository.toggleSaveMovie(userId, movie);
    } catch (e) {
      // Handle error
    }
  }

  Stream<int> getSaveCount(int movieId) => _repository.watchSaveCount(movieId);
  Stream<bool> isSaved(int userId, int movieId) => _repository.watchIsSaved(userId, movieId);
  Stream<List<User>> getUsersWhoSaved(int movieId) => _repository.watchUsersWhoSavedMovie(movieId);
  Stream<Movie?> getMovieById(int id) => _repository.watchMovieById(id);

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
