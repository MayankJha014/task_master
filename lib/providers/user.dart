import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_master/model/user.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier()
      : super(
          User(
            id: '',
            uniqueId: '',
            displayName: '',
            email: '',
            mobile: 0,
            token: '',
            deviceToken: '',
            profilePicture: '',
            followers: [],
            following: [],
            createdAt: '',
          ),
        );

  void updateUser(String user) {
    state = User.fromJson(user);
  }
}
