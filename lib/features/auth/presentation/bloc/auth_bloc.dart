import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_me_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetMeUseCase getMeUseCase;
  final AuthRepository authRepository;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getMeUseCase,
    required this.authRepository,
  }) : super(const AuthState()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final tokenResult = await authRepository.getStoredToken();
    final token = tokenResult.fold((_) => null, (t) => t);

    if (token == null || token.isEmpty) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
      return;
    }

    final userResult = await getMeUseCase(const NoParams());

    userResult.fold(
      (failure) async {
        final cachedUserResult = await authRepository.getStoredUser();
        final cachedUser = cachedUserResult.fold((_) => null, (u) => u);

        if (cachedUser != null) {
          emit(state.copyWith(
            status: AuthStatus.authenticated,
            user: cachedUser,
            token: token,
          ));
        } else {
          emit(state.copyWith(status: AuthStatus.unauthenticated));
        }
      },
      (user) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          token: token,
        ));
      },
    );
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.authenticating, errorMessage: null));

    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: failure.message,
      )),
      (data) {
        final (user, token) = data;
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          token: token,
          errorMessage: null,
        ));
      },
    );
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.authenticating, errorMessage: null));

    final result = await registerUseCase(
      RegisterParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: failure.message,
      )),
      (data) {
        final (user, token) = data;
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          token: token,
          errorMessage: null,
        ));
      },
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await logoutUseCase(const NoParams());
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
