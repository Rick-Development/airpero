
Expanded(
// height: 120.h,
child: ListView.builder(
scrollDirection: Axis.horizontal,
itemCount:
walletCtrl.walletList.length +
1,
itemBuilder: (context, i) {
if (i <
walletCtrl
    .walletList.length) {
var data =
walletCtrl.walletList[i];
var formattedBalance = NumberFormat("#,##0.00", "en_US").format(double.parse(data.balance));
// String formattedBalance = (data.balance.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'));
return Container(

child: Column(
crossAxisAlignment:
CrossAxisAlignment
    .start,
children: <Widget>[
Row(
children: [
Container(
height: 15.h,
width: 15.h,
decoration:
BoxDecoration(
shape: BoxShape
    .rectangle,
image:
DecorationImage(
image: CachedNetworkImageProvider(
walletCtrl
    .countryImageList[
i]
    .toString()),
fit: BoxFit
    .cover,
),
),
),
// Spacer(),
HSpace(5.w),
Text(data.currencyCode),
HSpace(5.w),
],
),
VSpace(5.h),
Row(
children: [
Text(
showBalance ? "${formattedBalance}" : "*****",
maxLines: 1,
overflow: TextOverflow
    .ellipsis,
style: context
    .t.bodyMedium
    ?.copyWith(
fontSize: 23.sp,
fontWeight:
FontWeight.w600,
color: Theme.of(context).textTheme.labelLarge?.color,
),
),

PopupMenuButton(
onSelected:
(value) {},
// child: Icon(Icons.more_vert),
itemBuilder:
(BuildContext
bc) {
return [
PopupMenuItem(
onTap: () {
UsableBootomSheet();
walletCtrl.walletUUID = data
    .uuid
    .toString();
transactionCtrl.resetDataAfterSearching(
isFromOnRefreshIndicator:
true);
Get.to(() => TransactionScreen(
isFromWallet:
true,
isFromHomePage:
true));
TransactionController(
isFromWallet:
true);
transactionCtrl.getTransactionList(
isFromWallet:
true,
uuid: data
    .uuid
    .toString(),
page:
1,
transaction_id:
"",
start_date:
"",
end_date:
"");
},
height:
40.h,
child: Text(
storedLanguage[
'Transactions'] ??
'Transactions',
style: context
    .t
    .displayMedium,
)),
PopupMenuItem(
onTap:
() async {
await walletCtrl
    .getWalletExchData(
data,
i);
Get.toNamed(
RoutesName
    .walletExchangeScreen);
},
height:
40.h,
child: Text(
storedLanguage[
'Exchange Currency'] ??
'Exchange Currency',
style: context
    .t
    .displayMedium,
)),
if (data.walletDefault
    .toString() !=
"1")
PopupMenuItem(
onTap:
() async {
await walletCtrl.defaultWallet(
id: data.id.toString());
},
height:
40.h,
child:
Text(
storedLanguage['Make Default'] ??
'Make Default',
style: context
    .t
    .displayMedium,
)),
];
},
child: Padding(
padding:
const EdgeInsets
    .all(8.0),
child: Icon(
Icons.keyboard_arrow_down_outlined,
size: 30.h,
color: Theme.of(context).textTheme.labelLarge?.color,
),
),
),
]
),
],
),
);
}

return InkWell(
onTap: () {
appDialog(
context: context,
title: Row(
mainAxisAlignment:
MainAxisAlignment
    .spaceBetween,
children: [
Text(
storedLanguage[
'Create New Wallet'] ??
"Create New Wallet",
style:
t.bodyMedium),
InkResponse(
onTap: () {
Get.back();
},
child: Container(
padding:
EdgeInsets
    .all(7.h),
decoration:
BoxDecoration(
color: AppThemes
    .getFillColor(),
shape: BoxShape
    .circle,
),
child: Icon(
Icons.close,
size: 14.h,
color: Get
    .isDarkMode
? AppColors
    .whiteColor
    : AppColors
    .blackColor,
),
),
),
],
),
content: Column(
crossAxisAlignment:
CrossAxisAlignment
    .start,
mainAxisSize:
MainAxisSize.min,
children: [
Text(
storedLanguage[
'Recipient Currency'] ??
"Recipient Currency",
style: context
    .t.displayMedium
    ?.copyWith(
fontSize:
16.sp,
color: Get
    .isDarkMode
? AppColors
    .whiteColor
    : AppColors
    .paragraphColor),
),
VSpace(12.h),
GetBuilder<
WalletController>(
builder: (_) {
return Container(
height: 48.h,
decoration:
BoxDecoration(
color: AppThemes
    .getFillColor(),
borderRadius:
Dimensions
    .kBorderRadius,
border: Border.all(
color: AppThemes
    .borderColor(),
width: Dimensions
    .appThinBorder),
),
child: Row(
children: [
Container(
height:
16.h,
width:
16.h,
margin: EdgeInsets.only(
left:
16.w),
decoration:
BoxDecoration(
shape: BoxShape
    .circle,
image: DecorationImage(
image:
CachedNetworkImageProvider("${walletCtrl.selectedCountryFlug}"),
fit: BoxFit.cover),
),
),
Expanded(
child:
AppCustomDropDown(
paddingLeft:
10.w,
height:
50.h,
width: double
    .infinity,
items: walletCtrl
    .currencyList
    .map((e) =>
e.code +
" - " +
e.name)
    .toList(),
selectedValue:
walletCtrl.selectedCountryAndCurr,
onChanged:
(v) {
var list = walletCtrl.currencyList.firstWhere((e) =>
e.code + " - " + e.name ==
v);
walletCtrl.selectedCountryFlug = list
    .country!
    .image;
walletCtrl.selectedCountryAndCurr =
v;
walletCtrl.selectedCountryCode =
list.code;
walletCtrl
    .update();
},
hint: storedLanguage['Select currency'] ??
"Select currency",
selectedStyle: context
    .t
    .bodySmall
    ?.copyWith(fontSize: 14.sp),
bgColor:
AppThemes.getDarkCardColor(),
),
),
],
));
}),
VSpace(40.h),
Row(
mainAxisAlignment:
MainAxisAlignment
    .spaceBetween,
children: [
TextButton(
onPressed:
() {
Get.back();
},
child: Text(
"Close",
style: t
    .bodyMedium
    ?.copyWith(
color: AppColors.redColor))),
HSpace(30.w),
GetBuilder<
WalletController>(
builder: (_) {
return AppButton(
buttonHeight:
30.h,
buttonWidth:
_.isCreatingWallet
? 110
    .w
    : 90.w,
style: t.bodyMedium?.copyWith(
color: Get.isDarkMode
? AppColors
    .blackColor
    : AppColors
    .whiteColor),
onTap:
() async {
await _.walletStore(
currency_code: _
    .selectedCountryCode,
context:
context);
},
text: _.isCreatingWallet
? "Creating..."
    : "Create",
);
}),
],
),
],
));
},
child:  Icon(
Icons.add,
color: Get.isDarkMode
? AppColors.black60
    : AppColors.black20,
),
);
}
),
),