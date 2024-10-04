import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../app/http/controllers/giftcards/sell_giftcard_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/button.dart';
import '../../../widgets/custom_textfield.dart';
import 'checkout.dart';
import "package:get/get.dart";

class SellSingleGiftcardView extends StatefulWidget {
  const SellSingleGiftcardView({super.key});

  @override
  State<SellSingleGiftcardView> createState() => SellSingleGiftcardViewState();
}

class SellSingleGiftcardViewState extends State<SellSingleGiftcardView> {
  SellGiftCardController sellGiftCardController = Get.put(SellGiftCardController());
  bool viewDetails = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const Gap(33),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/apple-gc.png'),
              radius: 32,
            ),
            const Gap(9),
            Text(
              'Apple Pay E-Gift Card',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const Gap(23),
        Obx(() {
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
                  ? null
                  : sellGiftCardController.selectedPrice.value,
              hint: Text(
                'Select Amount',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              isExpanded: true,
              items: sellGiftCardController.priceList.map((String price) {
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
            const CustomTextfield(
              label: 'Gift card details will be sent to',
              hintText: 'Please enter email ID',
            ),
            const Gap(25),
            const CustomTextfield(
              label: 'Receive number',
              hintText: '0000 0000 0000 0000',
              // svgPrefix: 'dropdown',
              enabled: false,
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
                builder: (_) => const CheckoutView(),
              ));
            }),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
