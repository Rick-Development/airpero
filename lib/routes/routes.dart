class WebRoutes {
  static const String baseUrl = "https://billvaolt.payvalue.com.ng";

//pin
  static const String pin = '$baseUrl/api/change-pin'; // POST
  // static const String pin = "http://localhost:8000/api/get-brokers";
  // Bill Payment
  static const String purchaseAirtime = '$baseUrl/api/purchase-airtime'; // POST
  static const String purchaseData = '$baseUrl/api/purchase-data'; // POST
  static const String fundBettingWallet = '$baseUrl/api/fund-betting-wallet'; // POST
  static const String fundElectricity = '$baseUrl/api/subscribe-electricity'; // POST
  static const String queryTransaction = '$baseUrl/api/query-transaction'; // POST
  static const String cancelTransaction = '$baseUrl/api/cancel-transaction'; // POST
  static const String verifyCustomerID = '$baseUrl/api/verify-customer-id'; // POST
  static const String cableTV = '$baseUrl/api/cable-tv'; // POST
  // static const String fundBetting = '$baseUrl/fund-betting-wallet';


  // Authentication
  static const String register = '$baseUrl/api/register'; // POST
  static const String login = '$baseUrl/api/login'; // POST
  static const String logout = '$baseUrl/api/logout'; // GET
  static const String forgotPasswordEmail = '$baseUrl/api/password/email'; // POST
  static const String forgotPasswordVerifyCode = '$baseUrl/api/password/verify-code'; // POST
  static const String forgotPasswordReset = '$baseUrl/api/password/reset'; // POST

  // Authorization
  static const String authorization = '$baseUrl/api/authorization'; // GET
  static const String resendVerifyCode = '$baseUrl/api/resend-verify'; // GET
  static const String verifyEmail = '$baseUrl/api/verify-email'; // POST
  static const String verifyMobile = '$baseUrl/api/verify-mobile'; // POST
  static const String verifyG2FA = '$baseUrl/api/verify-g2fa'; // POST

  // User Data
  static const String userDataSubmit = '$baseUrl/api/user-data-submit'; // POST
  static const String dashboard = '$baseUrl/api/dashboard'; // GET
  static const String getDeviceToken = '$baseUrl/api/get/device/token'; // POST
  static const String userInfo = '$baseUrl/api/user-info'; // GET

  // KYC
  static const String kycForm = '$baseUrl/api/kyc-form'; // GET
  static const String kycSubmit = '$baseUrl/api/kyc-submit'; // POST

  // Transactions
  static const String depositHistory = '$baseUrl/api/deposit/history'; // GET
  static const String transactions = '$baseUrl/api/transactions'; // GET

  // QR Code
  static const String qrCodeScan = '$baseUrl/api/qr-code/scan'; // POST
  static const String qrCode = '$baseUrl/api/qr-code'; // GET
  static const String qrCodeDownload = '$baseUrl/api/qr-code/download'; // POST
  static const String qrCodeRemove = '$baseUrl/api/qr-code/remove'; // POST

  // Profile & Security
  static const String profileSetting = '$baseUrl/api/profile-setting'; // POST
  static const String changePassword = '$baseUrl/api/change-password'; // POST
  static const String logoutOtherDevices = '$baseUrl/api/logout-other-devices'; // POST

  // Wallets
  static const String wallets = '$baseUrl/api/wallets'; // GET

  // OTP
  static const String otpVerify = '$baseUrl/api/otp-verify'; // POST
  static const String otpResend = '$baseUrl/api/otp-resend'; // POST

  // Money Out
  static const String agentCheckExist = '$baseUrl/api/agent/exist'; // POST
  static const String moneyOut = '$baseUrl/api/money-out'; // GET
  static const String moneyOutConfirm = '$baseUrl/api/money-out'; // POST
  static const String moneyOutDone = '$baseUrl/api/money-out-done'; // POST

  // Make Payment
  static const String merchantCheckExist = '$baseUrl/api/merchant/exist'; // POST
  static const String makePayment = '$baseUrl/api/make-payment'; // GET & POST
  static const String makePaymentDone = '$baseUrl/api/make-payment-done'; // POST

  // Transfer Money
  static const String transfer = '$baseUrl/api/transfer/money'; // GET & POST
  static const String transferMoneyDone = '$baseUrl/api/transfer/money-done'; // POST
  static const String checkUserExist = '$baseUrl/api/user/exist'; // POST

  // Request Money
  static const String allRequests = '$baseUrl/api/requests'; // GET
  static const String requestedHistory = '$baseUrl/api/my/requested/history'; // GET
  static const String requestMoney = '$baseUrl/api/request/money'; // GET & POST
  static const String requestAccept = '$baseUrl/api/accept/request'; // POST
  static const String requestReject = '$baseUrl/api/accept/reject'; // POST
  static const String requestAcceptDone = '$baseUrl/api/accept/done'; // POST

  // Vouchers
  static const String voucherList = '$baseUrl/api/voucher/list'; // GET
  static const String voucherCreate = '$baseUrl/api/create/voucher'; // GET & POST
  static const String voucherCreateDone = '$baseUrl/api/create/voucher-done'; // POST
  static const String voucherRedeem = '$baseUrl/api/voucher/redeem'; // POST
  static const String voucherRedeemLog = '$baseUrl/api/voucher/redeem/log'; // GET

  // Money Exchange
  static const String exchangeMoney = '$baseUrl/api/exchange/money'; // GET & POST
  // static const String exchangeMoneyHistory = '$baseUrl/api/exchange/money'; // GET & POST

  // Invoice
  static const String invoiceAll = '$baseUrl/api/invoice/all'; // GET
  static const String invoiceCreate = '$baseUrl/api/invoice/create'; // GET & POST
  static const String invoiceEdit = '$baseUrl/api/invoice/edit'; // GET
  static const String invoiceUpdate = '$baseUrl/api/invoice/update'; // POST
  static const String invoiceSendMail = '$baseUrl/api/invoice/send-to-mail'; // GET
  static const String invoicePublish = '$baseUrl/api/invoice/publish'; // GET
  static const String invoiceDiscard = '$baseUrl/api/invoice/discard'; // GET

  // Withdraw
  static const String withdrawMethods = '$baseUrl/api/withdraw/methods'; // GET
  static const String addWithdrawMethod = '$baseUrl/api/withdraw/add-method'; // POST
  static const String editWithdrawMethod = '$baseUrl/api/withdraw/edit-method'; // GET
  static const String withdrawMoney = '$baseUrl/api/withdraw/money'; // POST
  static const String withdrawPreview = '$baseUrl/api/withdraw/preview'; // GET
  static const String withdrawSubmit = '$baseUrl/api/withdraw/submit'; // POST
  static const String withdrawHistory = '$baseUrl/api/withdraw/history'; // GET

  // Payment
  static const String depositMethods = '$baseUrl/api/deposit/methods'; // GET
  static const String depositInsert = '$baseUrl/api/deposit/insert'; // POST
  static const String depositConfirm = '$baseUrl/api/deposit/confirm'; // GET
  static const String depositManualConfirm = '$baseUrl/api/deposit/manual/confirm'; // POST
  static const String depositManualUpdate = '$baseUrl/api/deposit/manual'; // POST

  // Tawk.to link
  static const String tawktoLink = "https://tawk.to/chat/66e7f17b50c10f7a00aab067/1i7t0ejf3";
}

class ApiRoutes {
  static const String baseUrl = "https://billvaolt.payvalue.com.ng";
  static const String register = '$baseUrl/api/register';
  static const String login = '$baseUrl/api/login';
  static const String home = "$baseUrl/mobile/home";
  static const int sessionTimeoutThreshold =
  0; // Will refresh the access token 5 minutes before it expires
  static const bool loginWithPassword = true; // if false hide the form login
  //if false hide the fields password and confirm password from signup form
  //for security reason and the password generated after verification mail
  static const bool signupWithPassword = true;
}