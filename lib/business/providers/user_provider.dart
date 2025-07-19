import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/entities/user.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/datasources/user_repository_impl.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl();
});

final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  return UserNotifier(ref.watch(userRepositoryProvider));
});

class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final UserRepository _userRepository;

  UserNotifier(this._userRepository) : super(const AsyncValue.loading()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await _userRepository.getUser();
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> saveUser(User user) async {
    state = const AsyncValue.loading();
    try {
      await _userRepository.saveUser(user);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateUser(User user) async {
    state = const AsyncValue.loading();
    try {
      await _userRepository.updateUser(user);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteUser() async {
    state = const AsyncValue.loading();
    try {
      await _userRepository.deleteUser();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<bool> hasUser() async {
    try {
      return await _userRepository.hasUser();
    } catch (e) {
      return false;
    }
  }
}