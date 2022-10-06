import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:coin_with_architecture/product/repository/service/firebase/auth/fireabase_auth_service.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../../../../core/enums/back_up_enum.dart';
import '../../../../core/model/response_model/IResponse_model.dart';
import '../../../../locator.dart';
import '../../../../product/model/coin/my_coin_model.dart';
import '../../../../product/model/user/my_user_model.dart';
import '../../../../product/repository/cache/coin_cache_manager.dart';
import '../../../../product/repository/service/user_service_controller/user_service_controller.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial()) {
    getCurrentUser();
    groupValue = BackUpTypes.never.name;
    isLoginPage = true;
    isLockOpen = true;
    autoValidateMode = AutovalidateMode.disabled;
    tabbarIndex = 0;
  }

  final UserServiceController _userServiceController =
      UserServiceController.instance;
  MyUser? user;
  String? email;
  late bool isLoginPage;
  late bool isLockOpen;

  String? password;
  String? emailErrorMessage;
  String? passwordErrorMessage;
  bool? isBackUpActiveForUpdate;
  String? backUpTypeForUpdate;
  List<MainCurrencyModel> differentCurrensies = [];
  List<MainCurrencyModel>? coinListFromDataBase;
  TextEditingController? emailControllerForLogin = TextEditingController();
  TextEditingController? passwordControllerForLogin = TextEditingController();
  TextEditingController? emailControllerForRegister = TextEditingController();
  TextEditingController? passwordControllerForRegister =
      TextEditingController();
  late int tabbarIndex;
  TextEditingController? nameController = TextEditingController();
  late AutovalidateMode autoValidateMode;
  final GlobalKey<FormState> formState = GlobalKey<FormState>();

  final CoinCacheManager _cacheManager = locator<CoinCacheManager>();
  late String groupValue;

  void changeGroupValue(String path) {
    groupValue = path;
    emit(UserFull(user: user!));
  }

  void changeAutoValidateMode() {
    autoValidateMode = AutovalidateMode.always;
  }

  tappedLoginRegisterButton() async {
    changeAutoValidateMode();
    if (formState.currentState!.validate()) {
      if (isLoginPage) {
        await signInWithEmailandPassword(
            emailControllerForLogin!.text, passwordControllerForLogin!.text);
      } else {
        await createUserWithEmailandPassword(emailControllerForRegister!.text,
            passwordControllerForRegister!.text, nameController!.text);
      }
    } else {
      emit(UserNull());
    }
  }

  changeIsLoginPage(int index) {
    if (index == 0) {
      tabbarIndex = 0;
      isLoginPage = true;
    } else {
      tabbarIndex = 1;

      isLoginPage = false;
    }
    emit(UserNull());
  }

  changeIsLockOpen() {
    isLockOpen = !isLockOpen;
    emit(UserNull());
  }

  Future<MyUser?> updateUser() async {
    if (BackUpTypes.never.name != groupValue) {
      user?.isBackUpActive = true;
    } else {
      user?.isBackUpActive = false;
    }
    user?.backUpType = groupValue;
    emit(UserFull(user: user!));
    if (user != null) {
      IResponseModel<MyUser?> responseModel =
          await _userServiceController.updateUser(user!);
      if (responseModel.error != null) {
        emit(UserError(message: responseModel.error!.message));
      } else if (responseModel.data != null) {
        emit(UserFull(user: responseModel.data!));
      } else {
        emit(UserNull());
      }
    }
  }

  List<MainCurrencyModel>? _fetchAllAddedCoinsFromDatabase() =>
      _cacheManager.getValues();

  Future<void> createUserWithEmailandPassword(
      String email, String password, String name) async {
    emit(UserLoading());
    var result = await _userServiceController.createUserWithEmailandPassword(
        email, password, name);
    if (result.error != null) {
      user = result.data;
      emit(UserError(message: result.error!.message));
      emit(UserNull());
    } else if (result.data != null) {
      user = result.data;
      emit(UserFull(user: user!));
    } else if (result.data == null) {
      user = result.data;

      emit(UserNull());
    } else {
      user = result.data;

      emit(UserNull());
    }
  }

  Future<void> getCurrentUser() async {
    if (user == null) {
      emit(UserLoading());
    }
    var result = await _userServiceController.getCurrentUser();
    if (result.error != null) {
      user = result.data;
      emit(UserError(message: result.error!.message));
      emit(UserNull());
    } else if (result.data != null) {
      user = result.data;
      emit(UserFull(user: user!));
    } else {
      user = result.data;
      emit(UserNull());
    }
  }

  Future<void> signInWithEmailandPassword(String email, String password) async {
    emit(UserLoading());

    var result = await _userServiceController.signInWithEmailandPassword(
        email, password);
    if (result.error != null) {
      user = result.data;

      emit(UserError(message: result.error!.message));
      emit(UserNull());
    } else if (result.data != null) {
      user = result.data;
      await fetchCurrenciesByEmail(user!);

      emit(UserFull(user: user!));
    } else {
      user = result.data;

      emit(UserNull());
    }
  }

  signinApple() async {
    if (!await TheAppleSignIn.isAvailable()) {
      //  _errorMessage.sink.add('This Device is not eligible for Apple Sign in');
      return null; //Break from the program
    }

    final res = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    //_processRunning.sink.add(true);

    switch (res.status) {
      case AuthorizationStatus.authorized:
        try {
          //Get Token
          final AppleIdCredential appleIdCredential = res.credential!;
          final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken!),
              accessToken:
                  String.fromCharCodes(appleIdCredential.authorizationCode!));
          // FirebaseAuth.instance.signInWithCredential(credential);
          var result =
              await _userServiceController.signInWithCredential(credential);
          if (result.error != null) {
            print(result.error?.message);
            user = result.data;
            emit(UserError(message: result.error?.message ?? "Cancelled"));
            emit(UserNull());
          } else if (result.data != null) {
            user = result.data;
            await fetchCurrenciesByEmail(user!);
            emit(UserFull(user: user!));
          } else {
            user = result.data;
            emit(UserNull());
          }

          // _processRunning.sink.add(false);
        } on PlatformException catch (error) {
          //_processRunning.sink.add(false);
          //_errorMessage.sink.add(error.message);
        } on FirebaseAuthException catch (error) {
          //_processRunning.sink.add(false);
          // _errorMessage.sink.add(error.message);
        }
        break;
      case AuthorizationStatus.error:
        //_processRunning.sink.add(false);
        //_errorMessage.sink.add('Apple authorization failed');
        break;
      case AuthorizationStatus.cancelled:
        // _processRunning.sink.add(false);
        break;
    }
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

//String generateNonce([int length = 32]) {
//   final charset =
//       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//   final random = Random.secure();
//   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
//       .join();
// }
  Future<MyUser?> signInWithApple() async {
    emit(UserLoading());
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        //nonce: nonce
      );
   
  
      final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      final credential2 = oAuthProvider.credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,

        //rawNonce: rawNonce,
      );

      print(credential2);
      var result =
          await _userServiceController.signInWithCredential(credential2);

      if (result.error != null) {
        print(result.error?.message);

        user = result.data;
        emit(UserError(message: result.error?.message ?? "Cancelled"));
        emit(UserNull());
      } else if (result.data != null) {
        user = result.data;
        await fetchCurrenciesByEmail(user!);
        emit(UserFull(user: user!));
      } else {
        user = result.data;
        emit(UserNull());
      }
    } catch (e) {
      emit(UserError(message: e.toString()));
      emit(UserNull());
    }
  }

  Future<MyUser?> signInWithGoogle() async {
    emit(UserLoading());
    var result = await _userServiceController.signInWithGoogle();
    if (result.error != null) {
      user = result.data;
      emit(UserError(message: result.error?.message ?? "Cancelled"));
      emit(UserNull());
    } else if (result.data != null) {
      user = result.data;
      await fetchCurrenciesByEmail(user!);
      emit(UserFull(user: user!));
    } else {
      user = result.data;
      emit(UserNull());
    }
  }

  Future<void> signOut() async {
    emit(UserLoading());
    var result = await _userServiceController.signOut();
    if (result.error != null) {
      user = result.data;
      emit(UserError(message: result.error!.message));
      emit(UserNull());
    }
    user = result.data;
    emit(UserNull());
  }

  void overwriteDataToDb() {
    //  _cacheManager.addItems(differentCurrensies);bunuda bir dene***************************************
    differentCurrensies.forEach((element) {
      _cacheManager.putItem(element.id, element);
    });
  }

  Future<List<MainCurrencyModel>?> fetchCurrenciesByEmail(MyUser user) async {
    differentCurrensies.clear();
    List<MainCurrencyModel>? listCurrenciesFromService;
    List<MainCurrencyModel>? listCurrenciesFromDb;

    IResponseModel<List<MainCurrencyModel>?> serviceResponse =
        await _userServiceController.fetchCoinInfoByEmail(user.email ?? "");

    if (serviceResponse.error != null) {
      emit(UserError(message: serviceResponse.error!.message));
    } else if (serviceResponse.data != null) {
      listCurrenciesFromDb = _fetchAllAddedCoinsFromDatabase();

      listCurrenciesFromService = serviceResponse.data;
      if (listCurrenciesFromService != null) {
        if (listCurrenciesFromDb != null) {
          for (var itemFromService in listCurrenciesFromService) {
            if (!(listCurrenciesFromDb.contains(itemFromService))) {
              differentCurrensies.add(itemFromService);
            }
          }
          if (differentCurrensies.isNotEmpty) {
            emit(UserUpdate());
            emit(UserFull(user: user));
          }
        }
      }
    }
    return listCurrenciesFromService;
  }

  bool _emailPasswordControl(String email, String password) {
    var result = true;
    if (password.length <= 6) {
      passwordErrorMessage = "Password must be at least 6 characters ";
      result = false;
    } else {
      passwordErrorMessage = null;
    }
    if (!email.contains("@")) {
      emailErrorMessage = "invalid email";
      result = false;
    } else {
      emailErrorMessage = null;
    }
    return result;
  }

  Future<void> backUpWhenTapped() async {
    List<MainCurrencyModel>? mainCurrencyList =
        _fetchAllAddedCoinsFromDatabase();

    await _userServiceController.updateUserCurrenciesInformation(user!,
        listCurrency: mainCurrencyList);
    await getCurrentUser();
  }
}
