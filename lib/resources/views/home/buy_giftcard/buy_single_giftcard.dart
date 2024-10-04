import 'package:waiz/app/Models/user/User.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../app/http/controllers/giftcards/giftcard_controller.dart';
import '../../../../app/http/controllers/giftcards/sell_giftcard_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/button.dart';
import '../../../widgets/custom_textfield.dart';
import 'checkout.dart';
import "package:get/get.dart";

class BuySingleGiftcardView extends StatefulWidget {
  final image;
  final  text;
  final Map<String, dynamic> cardDetails;
  const BuySingleGiftcardView({super.key, required this.image,  required this.text, required this.cardDetails});

  @override
  State<BuySingleGiftcardView> createState() => BuySingleGiftcardViewState();
}

class BuySingleGiftcardViewState extends State<BuySingleGiftcardView> {
  SellGiftCardController sellGiftCardController = Get.put(SellGiftCardController());
  final GiftCardController giftCardController = Get.put(GiftCardController());
  bool viewDetails = true;


  @override
  void initState() {
    super.initState();

    // Suspend initialization for 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      sellGiftCardController.setCurrency(widget.cardDetails['recipientCurrencyCode'],widget.cardDetails['senderFee']);

      // Optionally display the snackbar after the build phase
      Get.snackbar('Product Information', "${widget.cardDetails['productName']}");
    });

    print("Checkout Details: ${widget.cardDetails}");
  }


  @override
  Widget build(BuildContext context) {
    sellGiftCardController.selectedPrice.value = '';
    // Map<String, dynamic> cardDetails = widget.cardDetails;
    TextEditingController email_controller = TextEditingController();
    TextEditingController phone_controller = TextEditingController();
    TextEditingController quantity_controller = TextEditingController();
    email_controller.text = User().email;
    phone_controller.text = '+${User().mobile}';

    print( widget.cardDetails);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Row(
          children: [
            Text(
              'Buy Gift Card',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const Gap(33),
            CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              backgroundImage: NetworkImage(widget.image),  // Use NetworkImage here
              radius: 32,
            ),
            const Gap(9),
            Text(
              widget.text,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
            ),
            const Gap(23),
            Obx(() {
              // sellGiftCardController.selectedPrice.value = '';
              sellGiftCardController.setCurrency(widget.cardDetails['recipientCurrencyCode'],double.parse(widget.cardDetails['senderFee']));
              // Ensure priceList has unique values
              final uniquePriceList = sellGiftCardController.priceList.toSet().toList();

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2), // Padding for better alignment
                decoration: BoxDecoration(
                  color: Colors.white, // Dropdown background color
                  borderRadius: BorderRadius.circular(32), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3), // Shadow for depth effect
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300), // Border color
                ),
                child: DropdownButton<String>(
                  value: sellGiftCardController.selectedPrice.value.isEmpty
                      ? sellGiftCardController.selectedPrice.value = uniquePriceList[0]
                      : sellGiftCardController.selectedPrice.value,
                  hint: Text(
                    'Select Amount',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  isExpanded: true,
                  items: uniquePriceList.map((String price) {
                    return DropdownMenuItem<String>(
                      value: price,
                      child: Text(
                        price,
                        style: const TextStyle(
                          color: Colors.black87, // Text color
                          fontSize: 14, // Font size
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    sellGiftCardController.selectedPrice.value = newValue!; // Update the selected price
                  },
                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600), // Arrow icon
                  underline: const SizedBox(), // Remove underline
                  dropdownColor: Colors.white, // Dropdown background color
                  borderRadius: BorderRadius.circular(10), // Rounded corners for the dropdown
                ),
              );
            }),

            const Gap(11),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quantity',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                ),
                const Gap(6),
                Row(
                  children: [
                    InkWell(
                    onTap: ()=> sellGiftCardController.reduceQuantity(),
    child: Container(
    padding: const EdgeInsets.symmetric(
    vertical: 13,
    horizontal: 8,
    ),
    decoration: const BoxDecoration(
    borderRadius:  BorderRadius.only(
    topLeft: Radius.circular(20),
    bottomLeft: Radius.circular(20),
    ),
    color: AppColors.primaryColor,
    ),
    child: const Icon(
    Icons.remove,
    color: Colors.white,
    ),
    )
    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        color: const Color(0xFFF8F7F7),
                        child: Obx( (){
                          return Text(
                            '${sellGiftCardController.quantity}',
                            style:
                            Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 21,
                            ),

                          ); }),
                      ),
                    ),
                    InkWell(
                        onTap: ()=> sellGiftCardController.addQuantity(),
                        child:Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 13,
                            horizontal: 8,
                          ),
                          decoration: const BoxDecoration(
                            borderRadius:  BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            color: AppColors.primaryColor,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        )),
                  ],
                )
              ],
            ),
            const Gap(18),
            CustomTextfield(
              label: 'Gift card details will be sent to',
              hintText: '${User().email}',
              ctrl: email_controller,
            ),
            const Gap(25),
            CustomTextfield(
              label: 'Receive number',
              hintText: '+${User().mobile}',
              // svgPrefix: 'dropdown',
              ctrl: phone_controller,
              enabled: true,
            ),
            const Gap(25),
            Text(
              'Redeem instructions',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: const Color(0xFF003130),
                  ),
            ),
            const Spacer(flex: 3),
            primaryButton(context, title: 'Confirm', onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => CheckoutView(checkoutDetails: widget.cardDetails,email: email_controller.text,phone_number: phone_controller.text,quantity: sellGiftCardController.quantity.value,amount:  sellGiftCardController.selectedPrice.value,),
              ));
            }),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
