import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../app/http/controllers/bill_payments.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/button.dart';
// import '../../../widgets/custom_textfield.dart';
import '../buy_giftcard/pin_bottomsheet.dart';

class BuyAirtimeView extends StatefulWidget {
  const BuyAirtimeView({super.key});

  @override
  State<BuyAirtimeView> createState() => BuyAirtimeViewState();
}

class BuyAirtimeViewState extends State<BuyAirtimeView> {
  late TextEditingController ctrl = TextEditingController();
  late TextEditingController phone_controller = TextEditingController();
  late GetStorage storage;

  bool viewDetails = true;

  @override
  void initState() {
    super.initState();
    // ctrl = TextEditingController(text: '₦');
    ctrl = TextEditingController(text: '₦');
    phone_controller = TextEditingController();
    storage = GetStorage();
  }

  // @override
  // void dispose() {
  //   // ctrl.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    BillPaymentsController billPaymentsController = Get.put(BillPaymentsController());
    var amount = '';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Airtime',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(MediaQuery.of(context).padding.top + 24),
                Container(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFB8B0B0),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          await showModalBottomSheet(
                            context: context,
                            builder: (_) => IntrinsicHeight(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    const Gap(40),
                                    InkWell(
                                      onTap: Navigator.of(context).pop,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(),
                                          Text(
                                            'Select Network',
                                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SvgPicture.asset('assets/svgs/cancel.svg'),
                                        ],
                                      ),
                                    ),
                                    const Gap(30),
                                    networkWidget(context, img: 'mtn', name: 'MTN', action: ()=> {billPaymentsController.setNetworkLogo('mtn'), Navigator.pop(context)}),
                                    const Gap(16),
                                    const Divider(color: AppColors.greyBorderColor),
                                    const Gap(16),
                                    networkWidget(context, img: 'airtel', name: 'Airtel', action: ()=> {billPaymentsController.setNetworkLogo('airtel'), Navigator.pop(context)}),
                                    const Gap(16),
                                    const Divider(color: AppColors.greyBorderColor),
                                    const Gap(16),
                                    networkWidget(context, img: 'glo', name: 'GLO', action: ()=>{ billPaymentsController.setNetworkLogo('glo'), Navigator.pop(context)}),
                                    const Gap(16),
                                    const Divider(color: AppColors.greyBorderColor),
                                    const Gap(16),
                                    networkWidget(context, img: '9mobile', name: '9Mobile', action: ()=> { billPaymentsController.setNetworkLogo('9mobile'), Navigator.pop(context)}),
                                    const Gap(36),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx((){
                              return Image.asset('assets/images/${billPaymentsController.networkLogo.value}.png');
                            }),
                            SvgPicture.asset('assets/svgs/dropdown.svg'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          onTap: () {},
                          controller: phone_controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 4),
                            hintText: 'Enter mobile number',
                            hintStyle: TextStyle(fontSize: 12),
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(35),
                Wrap(
                  runSpacing: 12,
                  spacing: 12,
                  children: [
                    priceButton(context, '50', () => billPaymentsController.setAirtimeShortcutAmount(50)),
                    priceButton(context, '100', () => billPaymentsController.setAirtimeShortcutAmount(100)),
                    priceButton(context, '200', () => billPaymentsController.setAirtimeShortcutAmount(200)),
                    priceButton(context, '300', () => billPaymentsController.setAirtimeShortcutAmount(300)),
                    priceButton(context, '500', () => billPaymentsController.setAirtimeShortcutAmount(500)),
                    priceButton(context, '1000', () => billPaymentsController.setAirtimeShortcutAmount(1000)),
                    priceButton(context, '2000', () => billPaymentsController.setAirtimeShortcutAmount(2000)),
                    priceButton(context, '3000', () => billPaymentsController.setAirtimeShortcutAmount(3000)),
                  ],
                ),
                const Gap(34),
                Obx(() {
                  return
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          // onEditingComplete: () {
                          //   if (ctrl.text.isEmpty) {
                          //     ctrl.text = billPaymentsController.airtimeShortcutAmount.value.toString();
                          //   }
                          // },
                          // onFieldSubmitted: (val) {
                          //   if (val.isEmpty) {
                          //     ctrl.text = billPaymentsController.airtimeShortcutAmount.value.toString();
                          //   }
                          // },
                          controller: ctrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '₦ ${billPaymentsController.airtimeShortcutAmount.value}',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: const BorderSide(color: Colors.blue),
                            ),
                          ),
                          style: const TextStyle(
                            fontFamily: "Roboto",
                          ),
                        ),
                      ],
                    );
                }),
                const Spacer(),
                primaryButton(
                  context,
                  title: 'Confirm',
                  color: AppColors.primaryColor,
                  onTap: () async {
                     if(phone_controller.text.isEmpty ) {
                      Get.snackbar('Error', 'Enter a valid Phone number',snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red, colorText: Colors.white,
                        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),);
                    }else if(ctrl.text.isEmpty ) {
                       Get.snackbar('Error', 'Enter a valid amount',snackPosition: SnackPosition.BOTTOM,
                           backgroundColor: Colors.red, colorText: Colors.white,
                         icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),);
                     }else {
                      storage.write('buy_airtime', {
                        'amount': ctrl.text,
                        'phone_number': phone_controller.text,
                        'network': billPaymentsController.networkLogo
                      });

                      await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return const PinBottomsheetView();
                        },
                      );
                    }
                  },
                ),
                const Gap(36),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

Widget priceButton(BuildContext context, String amount, dynamic action) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: AppColors.primaryColor,
  ),
  child: InkWell(
    onTap: action,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '₦',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 8,
            fontFamily: 'Roboto',
          ),
        ),
        Text(
          amount,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    ),
  ),
);

Widget networkWidget(BuildContext context, {required String name, required String img, dynamic action}) => InkWell(
  onTap: action,
  child:  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        name,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      Image.asset('assets/images/$img.png'),
    ],
  ),
);



class CustomTextfield extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController ctrl;
  final TextInputType keyboardType;

  const CustomTextfield({
    Key? key,
    required this.label,
    required this.hintText,
    required this.ctrl,
    required this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: ctrl,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22), // Border radius of 22
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(color: Colors.blue), // Change the color on focus
            ),
          ),
          style: const  TextStyle(
            fontFamily: "Roboto"
          ),

        ),
      ],
    );
  }
}
