import 'package:waiz/routes/page_index.dart';
import '../views/screens/money_request/money_request_history_details_screen.dart';
import '../views/screens/money_request/money_request_history_screen.dart';
import '../views/screens/money_request/money_request_screen.dart';
import 'routes_name.dart';

class RouteHelper {
  static List<GetPage> routes() => [
        GetPage(
            name: RoutesName.initial,
            page: () => SplashScreen(),
            transition: Transition.zoom),
        GetPage(
            name: RoutesName.onbordingScreen,
            page: () => OnbordingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.bottomNavBar,
            page: () => BottomNavBar(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.loginScreen,
            page: () => LoginScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.signUpScreen,
            page: () => SignUpScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.forgotPassScreen,
            page: () => ForgotPassScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.otpScreen,
            page: () => OtpScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.createNewPassScreen,
            page: () => CreateNewPassScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.homeScreen,
            page: () => HomeScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.transactionScreen,
            page: () => TransactionScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.moneyTransferScreen1,
            page: () => MoneyTransferScreen1(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.moneyTransferScreen3,
            page: () => MoneyTransferScreen3(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.moneyTransferScreen4,
            page: () => MoneyTransferScreen4(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.moneyTransferScreen5,
            page: () => MoneyTransferScreen5(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.moneyTransferHistoryScreen,
            page: () => MoneyTransferHistoryScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.moneyTransferDetailsScreen,
            page: () => MoneyTransferDetailsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.recipientsScreen,
            page: () => RecipientsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.addRecipientsScreen,
            page: () => AddRecipientsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.recipientsDetailsScreen,
            page: () => RecipientsDetailsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.cardScreen,
            page: () => VirtualCardScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.virtualCardFormScreen,
            page: () => VirtualCardFormScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.cardRequestConfirmScreen,
            page: () => CardRequestConfirmScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.cardTransactionScreen,
            page: () => CardTransactionScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.addFundScreen,
            page: () => AddFundScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.fundHistoryScreen,
            page: () => FundHistoryScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.payoutScreen,
            page: () => PayoutScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.payoutPreviewScreen,
            page: () => PayoutPreviewScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.payoutHistoryScreen,
            page: () => PayoutHistoryScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.flutterWaveWithdrawScreen,
            page: () => FlutterWaveWithdrawScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.profileSettingScreen,
            page: () => ProfileSettingScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.notificationPermissionScreen,
            page: () => NotificationPermissionScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.editProfileScreen,
            page: () => EditProfileScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.changePasswordScreen,
            page: () => ChangePasswordScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.supportTicketListScreen,
            page: () => SupportTicketListScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.supportTicketViewScreen,
            page: () => SupportTicketViewScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.createSupportTicketScreen,
            page: () => CreateSupportTicketScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.twoFaVerificationScreen,
            page: () => TwoFaVerificationScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.verificationListScreen,
            page: () => VerificationListScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.identityVerificationScreen,
            page: () => IdentityVerificationScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.notificationScreen,
            page: () => NotificationScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.manualPaymentScreen,
            page: () => ManualPaymentScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.referScreen,
            page: () => ReferScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.referListScreen,
            page: () => ReferListScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.referDetailsScreen,
            page: () => ReferDetailsScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.walletExchangeScreen,
            page: () => WalletExchangeScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.walletGetOtpScreen,
            page: () => WalletGetOtpScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.walletPaymentConfirmScreen,
            page: () => WalletPaymentConfirmScreen(),
            transition: Transition.fade),
        GetPage(
            name: RoutesName.paymentSuccessScreen,
            page: () => PaymentSuccessScreen(),
            transition: Transition.fade),
        GetPage(
          name: RoutesName.moneyRequestScreen,
            page: () => MoneyRequestScreen(),
            transition: Transition.fade),
        GetPage(
          name: RoutesName.moneyRequestHistoryScreen,
            page: () => MoneyRequestHistoryScreen(),
            transition: Transition.fade),
        GetPage(
          name: RoutesName.moneyRequestHistoryDetailsScreen,
            page: () => MoneyRequestHistoryDetailsScreen(),
            transition: Transition.fade),
      ];
}
