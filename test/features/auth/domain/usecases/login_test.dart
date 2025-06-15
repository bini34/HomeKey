// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import '../../../../../core/error/failures.dart';
// import '../../entities/user_entity.dart';
// import '../../repositories/auth_repository.dart';
// import 'login.dart';
// import 'login_test.mocks.dart';

// // Generate mocks with `flutter pub run build_runner build`.
// @GenerateMocks([AuthRepository])
// void main() {
//   late Login loginUseCase;
//   late MockAuthRepository mockAuthRepository;

//   setUp(() {
//     mockAuthRepository = MockAuthRepository();
//     loginUseCase = Login(mockAuthRepository);
//   });

//   const tAuthEntity = AuthEntity(id: '123', email: 'test@example.com');
//   const tParams = LoginParams(email: 'test@example.com', password: 'password');

//   test('should get auth entity from repository', () async {
//     // Arrange: Mock repository to return success.
//     when(mockAuthRepository.login(any, any))
//         .thenAnswer((_) async => const Right(tAuthEntity));

//     // Act: Call the use case.
//     final result = await loginUseCase(tParams);

//     // Assert: Verify the result and repository interaction.
//     expect(result, const Right(tAuthEntity));
//     verify(mockAuthRepository.login(tParams.email, tParams.password));
//     verifyNoMoreInteractions(mockAuthRepository);
//   });
// }