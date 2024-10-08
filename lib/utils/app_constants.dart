class AppConstants {
  static const String appName = 'Waiz';

  //BASE_URLhttps://airpero.com/
  static const String baseUrl = 'https://me.airpero.com/api'; // baseUrl/api

  //END_POINTS_URL
  static const String registerUrl = '/register';
  static const String loginUrl = '/login';
  static const String forgotPassUrl = '/recovery-pass/get-email';
  static const String forgotPassGetCodeUrl = '/recovery-pass/get-code';
  static const String updatePassUrl = '/update-pass';
  static const String appConfigUrl = '/app-config';
  static const String languageUrl = '/language';
  static const String profileUrl = '/profile';
  static const String profileUpdateUrl = '/profile-update';
  static const String profileImageUploadUrl = '/profile-update/image';
  static const String profilePassUpdateUrl = '/update-password';
  static const String emailUpdateUrl = '/email-update';
  static const String verificationUrl = '/verify';
  static const String identityVerificationUrl = '/kyc-submit';
  static const String twoFaSecurityUrl = '/2FA-security';
  static const String twoFaSecurityEnableUrl = '/2FA-security/enable';
  static const String twoFaSecurityDisableUrl = '/2FA-security/disable';
  static const String twoFaVerifyUrl = '/twoFA-Verify';
  static const String mailUrl = '/mail-verify';
  static const String smsVerifyUrl = '/sms-verify';
  static const String resendCodeUrl = '/resend-code';
  static const String pusherConfigUrl = "/pusher-config";

  static const String transactionUrl = '/transaction-list';
  static const String fundHistoryUrl = '/fund-list';
  static const String payoutListUrl = '/payout-list';
  static const String dashboardUrl = '/dashboard';

  //----virtual cards
  static const String virtualCardsUrl = "/virtual-cards";
  static const String cardBlockUrl = "/virtual-card/block";
  static const String cardOrderForm = "/virtual-card/order";
  static const String cardOrderFormSubmit = "/virtual-card/order/submit";
  static const String cardOrderFormReSubmit = "/virtual-card/order/re-submit";
  static const String cardOrderConfirm = "/virtual-card/confirm";
  static const String cardTransaction = "/virtual-card/transaction";

  //----recipients
  static const String recipientsListUrl = "/recipient-list";
  static const String recipientdetailsUrl = "/recipient-details";
  static const String recipientNameUpdateUrl = "/recipient-update-name";
  static const String recipientDeleteUrl = "/recipient-delete";
  static const String getServicesUrl = "/get-services";
  static const String addRecipientUrl = "/recipient-store";

  //----money transfer
  static const String transferCurrencies = "/transfer-amount";
  static const String transferRecipient = "/transfer-recipient";
  static const String transferReview = "/transfer-review";
  static const String transferPaymentStore = "/transfer-payment-store";
  static const String transferPost = "/money-transfer-post";
  static const String transferHistory = "/transfer-list";
  static const String transferPay = "/transfer-pay";
  static const String transferDetails = "/transfer-details";
  static const String currencyRate = "/currency-rate";
  static const String transferOtp = "/transfer-otp";

  //----support ticket
  static const String supportTicketListUrl = '/ticket-list';
  static const String supportTicketCreateUrl = '/create-ticket';
  static const String supportTicketReplyUrl = '/reply-ticket';
  static const String supportTicketViewUrl = '/ticket-view';
  static const String supportTicketCloseUrl = '/close-ticket';

  //-----Payout
  static const String payoutUrl = "/payout-methods";
  static const String payoutRequestUrl = "/payout-request";
  static const String payoutSubmitUrl = "/payout-confirm";
  static const String getBankFromBankUrl = "/payout/get-bank/form";
  static const String getBankFromCurrencyUrl = "/payout/get-bank/list";
  static const String flutterwaveSubmitUrl = "/payout-confirm/flutterwave";
  static const String paystackSubmitUrl = "/payout-confirm/paystack";
  static const String payoutConfirmUrl = "/payout-confirm";

  //-----Add fund
  static const String gatewaysUrl = "/gateways";
  static const String manualPaymentUrl = "/addFundConfirm";
  static const String paymentRequest = "/payment-request";
  static const String onPaymentDone = "/payment-done";
  static const String webviewPayment = "/payment-webview";
  static const String cardPayment = "/card-payment";

  static const String notificationSettingsUrl = "/notification-settings";
  static const String notificationPermissionUrl = "/notification-permission";
  static const String referUrl = "/referral-list";

  //------wallet
  static const String walletStore = "/wallet-store";
  static const String defaultWallet = "/default-wallet";
  static const String walletTransaction = "/wallet-transaction";
  static const String moneyExchange = "/money-exchange";

  //-------money transfer request
  static const String getMoneyTransferRequest = "/money-request-form";
  static const String postMoneyTransferRequest = "/money-request";
  static const String moneyRequestHistory = "/money-request-list";
  static const String moneyRequestAction = "/money-request-action";
  static const String recipientstore = "/recipient-user-store";
}

//----------IMAGE DIRECTORY---------//
String rootImageDir = "assets/images";
String rootIconDir = "assets/icons";
String rootJsonDir = "assets/json";
