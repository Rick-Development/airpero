import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';
import '../../app/http/controllers/giftcards/giftcard_controller.dart';
import '../../app/http/controllers/pin_controller.dart';
import '../views/home/sell_giftcard/success.dart';

class PinBottomsheetView extends StatefulWidget {
  final String? successText;
  final Widget? next;
  final Map<String, dynamic> checkoutDetails;
  final String email;
  final String phone_number;
  final int quantity;
  final String eurCurrency;
  final double eurAmount;
  final String ngnCurrency;
  final int sub_total;
  final int total;
  const PinBottomsheetView({
    super.key,
    this.successText,
    this.next,
    required this.checkoutDetails,
    required this.email,
    required this.phone_number,
    required this.quantity,
    required this.eurAmount,
    required this.eurCurrency,
    required this.ngnCurrency,
    required this.sub_total,
    required this.total,
  });

  @override
  State<PinBottomsheetView> createState() => _PinBottomsheetViewState();
}

class _PinBottomsheetViewState extends State<PinBottomsheetView> {
  final PinController pinController = Get.put(PinController()); // Initialize PinController
  // GetX controller instance
  final GiftCardController giftCardController = Get.put(GiftCardController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const Gap(16),
            Container(
              width: 40,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.29),
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            const Gap(24),
            Text(
              'Enter your 4-digit pin',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(35),
            // Pinput for PIN input
            Pinput(
              length: 4,
              controller: pinController.pinController, // Use the controller from GetX
              onCompleted: (val) async {
                // Set the PIN in the controller
                pinController.setPin(val);
// Call buyGiftcard before navigating
                String result = await giftCardController.buyGiftcard(
                    productId: int.parse(widget.checkoutDetails['productId'].toString()),
                    email:widget.email, eurAmount: widget.eurAmount, phoneNumber: widget.phone_number,
                    quantity: widget.quantity, subTotal: widget.sub_total, total: widget.total,checkoutDetails: widget.checkoutDetails
                );



                // Check result and navigate accordingly
                if (result == 'Purchase successful') {

                  // Navigate to success view after PIN input
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => SellGiftcardSuccessView(
                        content: widget.successText,quantity: widget.quantity, phone_number: widget.phone_number,checkoutDetails: widget.checkoutDetails, email: widget.email,eurCurrency: widget.eurCurrency,eurAmount: widget.eurAmount,ngnCurrency: widget.ngnCurrency, sub_total: widget.sub_total, total: widget.total,
                      ),
                    ),
                  );
                } else {
                  print(result);
                  Get.snackbar('Error', result);
                }
              },
            ),
            const Gap(24),
          ],
        ),
      ),
    );
  }
}
