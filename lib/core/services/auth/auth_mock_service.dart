import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:chat/core/services/auth/auth_service.dart';
import '../../models/chat_user.dart';

class AuthMockService implements AuthService {
  static final _defaultUser = ChatUser(
    id: '1',
    name: 'teste',
    email: 'teste@teste.com.br',
    imageURL: 'assets/images/imagemdedo.jpg',
  );

  static Map<String, ChatUser> _users = {
    _defaultUser.email: _defaultUser,
  };
  static ChatUser? _currentUser;
  static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _uptadeUser(_defaultUser);
  });

  ChatUser? get currentUser {
    return _currentUser;
  }

  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  Future<void> signup(
    String name,
    String email,
    String password,
    File? image,
  ) async {
    final newUser = ChatUser(
      id: Random().nextDouble().toString(),
      name: name,
      email: email,
      imageURL: image?.path ?? 'assets/images/imagemdedo.jpg',
    );
    _users.putIfAbsent(email, () => newUser);
    _uptadeUser(newUser);
  }

  Future<void> login(String email, String password) async {
    _uptadeUser(_users[email]);
  }

  Future<void> logout() async {
    _uptadeUser(null);
  }

  static void _uptadeUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }
}
