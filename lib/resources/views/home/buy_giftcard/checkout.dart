// import 'package:waiz/resources/views/home/buy_giftcard/pin_bottomsheet.dart';
import 'package:waiz/app/Models/user/User.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../../app/http/controllers/giftcards/giftcard_controller.dart';
import '../../../../app/http/controllers/giftcards/sell_giftcard_controller.dart';
import '../../../utils/button.dart';
import "package:get/get.dart";
import '../../../widgets/pin_bottom_sheet.dart';


class CheckoutView extends StatefulWidget {
  final  Map<String,dynamic> checkoutDetails;
  final String email;
  final dynamic phone_number;
  final dynamic quantity;
  final dynamic amount;
  const CheckoutView({super.key, required this.checkoutDetails, required this.email, required this.phone_number,required this.quantity,required this.amount });

  @override
  State<CheckoutView> createState() => CheckoutViewState();
}

class CheckoutViewState extends State<CheckoutView> {
  SellGiftCardController sellGiftCardController = Get.put(SellGiftCardController());
  final GiftCardController giftCardController = Get.put(GiftCardController());
  bool viewDetails = true;
  @override
  @override
  void initState() {
    super.initState();

    // Defer the setCurrency call to after the build phase is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sellGiftCardController.setCurrency(widget.checkoutDetails['recipientCurrencyCode'].toString(),double.parse(widget.checkoutDetails['senderFee'].toString()));

      // Optionally display the snackbar after the build phase
      // Get.snackbar('Product Information', "${widget.checkoutDetails['productName']}");
    });

    // print("Checkout Details: ${widget.checkoutDetails}");
  }


  @override
  Widget build(BuildContext context) {
    // Extract image outside build method logic
    // Split the string by ' - ' to separate the two currency parts
    List<String> parts = widget.amount.split(' - ');

    // Extract EUR part and split to get the currency code and amount
    List<String> eurPart = parts[0].split(' ');
    String eurCurrency = eurPart[0];  // EUR
    double eurAmount = double.parse(eurPart[1]);  // 100.00

    // Extract NGN part and split to get the currency code and amount
    List<String> ngnPart = parts[1].split(' ');
    String ngnCurrency = ngnPart[0];  // NGN
    double ngnAmount = double.parse(ngnPart[1]);  // 180000.00

    // Print extracted currency codes and amounts
    print('EUR Currency: $eurCurrency, EUR Amount: $eurAmount');
    print('NGN Currency: $ngnCurrency, NGN Amount: $ngnCurrency');
    // double sub_total = double.parse(widget.checkoutDetails['senderFee']) * widget.quantity;
    double formattedTotal = ngnAmount * widget.quantity;
    var formatter = NumberFormat("#,##0.00", "en_US");
    String sub_total = formatter.format(ngnAmount);
    String total = formatter.format(formattedTotal);
    String image = widget.checkoutDetails['logoUrls'].toString();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(MediaQuery.of(context).padding.top + 24),
            InkWell(
              onTap: Navigator.of(context).pop,
              splashColor: Colors.transparent,
              child: Row(
                children: [
                  const Icon(Icons.arrow_back),
                  const Gap(24),
                  Text(
                    widget.checkoutDetails['productName'],
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
            ),
            const Gap(33),
             CircleAvatar(
              backgroundImage: NetworkImage(image),
              radius: 32,
            ),
            const Gap(9),
            Text(
                widget.checkoutDetails['productName'],
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
            ),
            const Gap(23),
            rowWidget(context, title: 'Recipient:', value: widget.email),
            rowWidget(context, title: 'SMS:', value: widget.phone_number),
            rowWidget(context, title: 'Quantity:', value: '${widget.quantity.toString()} * ${widget.checkoutDetails['productName']}'),
            rowWidget(context, title: 'From:', value: User().fullName),
            rowWidget(context, title: 'Unit price:', value:'$eurCurrency $eurAmount'),
            rowWidget(context, title: 'Subtotal:', value: '$ngnCurrency $sub_total'),
            rowWidget(context, title: 'Total fee:', value:  '$ngnCurrency $total'),
            const Spacer(flex: 4),
            primaryButton(context, title: 'Confirm', onTap: () async {
              await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return  PinBottomsheetView(quantity: widget.quantity, phone_number: widget.phone_number,checkoutDetails: widget.checkoutDetails, email: widget.email,eurAmount: eurAmount,eurCurrency: eurCurrency,ngnCurrency: ngnCurrency,sub_total: ngnAmount.round(), total: formattedTotal.round());
                  });
            }),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}

Widget rowWidget(
  BuildContext context, {
  required String title,
  required String value,
}) =>
    Container(
      margin: const EdgeInsets.only(bottom: 23),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
              fontFamily: 'Roboto'
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  // fontWeight: FontWeight.w500,
                  fontSize: 12,
                fontFamily: 'Roboto'
                ),
          ),
        ],
      ),
    );
