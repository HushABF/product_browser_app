import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:product_browser_app/core/errors/failures.dart';
import 'package:product_browser_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:product_browser_app/features/auth/presentation/screens/login_screen.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });
  testWidgets(
    'when AuthError state is emitted, an error message text appears on screen',
    (tester) async {
      whenListen(
        mockAuthBloc,
        Stream.fromIterable([
          AuthFailure(failure: InvalidCredentialsFailure()),
        ]),
        initialState: AuthInitial(),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: LoginScreen(),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Wrong email or password.'), findsOneWidget);
    },
  );

  testWidgets(
    "the login button is disabled while AuthLoading state is active",
    (tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthLoading());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: mockAuthBloc,
            child: LoginScreen(),
          ),
        ),
      );
      final button = tester.widget<TextButton>(find.byType(TextButton));
      expect(button.onPressed, isNull);
    },
  );
}
