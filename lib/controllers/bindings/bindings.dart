import '../money_request_controller.dart';
import 'controller_index.dart';
import '../add_recipient_controller.dart';
import '../recipients_controller.dart';

class InitBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
    Get.put(ProfileController());
    Get.put(PushNotificationController());
    Get.put(MoneyTransferController(), permanent: true);
    Get.put(VerificationController(), permanent: true);

    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<BottomNavController>(() => BottomNavController(), fenix: true);
    Get.lazyPut<SupportTicketController>(() => SupportTicketController(),
        fenix: true);
    Get.lazyPut<TransactionController>(() => TransactionController(),
        fenix: true);
    Get.lazyPut<FundHistoryController>(() => FundHistoryController(),
        fenix: true);
    Get.lazyPut<PayoutHistoryController>(() => PayoutHistoryController(),
        fenix: true);
    Get.lazyPut<PayoutController>(() => PayoutController(), fenix: true);
    Get.lazyPut<AddFundController>(() => AddFundController(), fenix: true);
    Get.lazyPut<NotificationSettingsController>(
        () => NotificationSettingsController(),
        fenix: true);
    Get.lazyPut<RecipientListController>(() => RecipientListController(),
        fenix: true);
    Get.lazyPut<RecipientDetailsController>(() => RecipientDetailsController(),
        fenix: true);
    Get.lazyPut<AddRecipientController>(() => AddRecipientController(),
        fenix: true);
    Get.lazyPut<TransferHistoryController>(() => TransferHistoryController(),
        fenix: true);
    Get.lazyPut<CardController>(() => CardController(), fenix: true);
    Get.lazyPut<CardTransactionController>(() => CardTransactionController(),
        fenix: true);
    Get.lazyPut<WalletController>(() => WalletController(), fenix: true);
    Get.lazyPut<ReferController>(() => ReferController(), fenix: true);
    Get.lazyPut<MoneyRequestController>(
        () => MoneyRequestController(),
        fenix: true);
    Get.lazyPut<MoneyRequestListController>(() => MoneyRequestListController(),
        fenix: true);
  }
}
