import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/database/app_database.dart';

class ActiveUserCubit extends Cubit<User?> {
  ActiveUserCubit() : super(null);

  void setUser(User user) => emit(user);
  void clear() => emit(null);
}
