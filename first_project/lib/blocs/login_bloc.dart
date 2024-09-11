import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:your_project/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Login State
abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;

  LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// Login Event
abstract class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginWithGooglePressed extends LoginEvent {}

// Login BLoC
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginInitial()) {
    on<LoginWithGooglePressed>(_onLoginWithGooglePressed);
  }

  void _onLoginWithGooglePressed(
    LoginWithGooglePressed event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        emit(LoginSuccess(user));
      } else {
        emit(LoginFailure('Login canceled'));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
