import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:match_and_watch/features/users/bloc/user_cubit.dart';
import 'package:match_and_watch/core/repositories/user_repository.dart';
import 'package:match_and_watch/core/database/app_database.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UserCubit userCubit;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    userCubit = UserCubit(mockUserRepository);
  });

  tearDown(() {
    userCubit.close();
  });

  group('UserCubit', () {
    final mockUsers = [
      UserWithMovieCount(
        User(id: 1, firstName: 'John', lastName: 'Doe', movieTaste: 'Action', pendingSync: false),
        5,
      )
    ];

    blocTest<UserCubit, UserState>(
      'emits [UserLoading, UserLoaded] when loadUsers is successful',
      build: () {
        when(() => mockUserRepository.watchUsersWithMovieCount())
            .thenAnswer((_) => Stream.value(mockUsers));
        when(() => mockUserRepository.refreshUsers(page: 1, silent: false))
            .thenAnswer((_) async {});
        return userCubit;
      },
      act: (cubit) => cubit.loadUsers(),
      expect: () => [
        UserLoading(),
        UserLoaded(mockUsers),
      ],
    );

    blocTest<UserCubit, UserState>(
      'emits [UserLoading, UserError, UserLoaded] when refreshUsers fails and no data exists',
      build: () {
        when(() => mockUserRepository.watchUsersWithMovieCount())
            .thenAnswer((_) => Stream.value([]));
        when(() => mockUserRepository.refreshUsers(page: 1, silent: false))
            .thenThrow(Exception('API Error'));
        return userCubit;
      },
      act: (cubit) => cubit.loadUsers(),
      expect: () => [
        UserLoading(),
        UserError('Exception: API Error'),
        UserLoaded(const []),
      ],
    );
  });
}
