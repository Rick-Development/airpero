import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../app/http/controllers/bill_payments.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/button.dart';
import '../../../widgets/custom_textfield.dart';
import '../buy_giftcard/pin_bottomsheet.dart';
import 'package:get/get.dart';

class BuyDataView extends StatefulWidget {
  const BuyDataView({super.key});

  @override
  State<BuyDataView> createState() => BuyDataViewtate();
}

class BuyDataViewtate extends State<BuyDataView> {
  late TextEditingController ctrl;
  late TextEditingController phone_controller;
  bool viewDetails = true;
  BillPaymentsController billPaymentsController = Get.put(BillPaymentsController());
  List<Map<String, dynamic>> bundles = [];
  dynamic data_bundle;

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController();
    phone_controller = TextEditingController();
    fetchDataBundles();
  }

  @override
  void dispose() {
    // ctrl.dispose();
    // phone_controller.dispose();
    super.dispose();
  }

  // Assuming this is in an async function
  Future<void> fetchDataBundles() async {
    BillPaymentsController billPaymentsController = Get.put(BillPaymentsController());

    // Await the future to get the actual data
    bundles = await billPaymentsController.getdataBundles();
    billPaymentsController.dataamount.value = '0';
    // Now you can use the `bundles` list
    // print(bundles);
    // return bundles;
  }


  @override
  Widget build(BuildContext context) {
    GetStorage storage  = GetStorage();
    print('======== BUNDLES =======================================================');
    print(bundles);
    print('======== BUNDLES =======================================================');
    // fetchDataBundles();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Data',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),
                ),
                const Gap(18),
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
                  // clipBehavior: Clip.hardEdge,
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
                                    networkWidget(context, img: 'mtn', name: 'MTN', action: ()=> {billPaymentsController.setNetworkLogo('mtn'),billPaymentsController.selectedDataBundle.value = '',fetchDataBundles(), Navigator.pop(context)}),
                                    const Gap(16),
                                    const Divider(color: AppColors.greyBorderColor),
                                    const Gap(16),
                                    networkWidget(context, img: 'airtel', name: 'Airtel', action: ()=> {billPaymentsController.setNetworkLogo('airtel'),billPaymentsController.selectedDataBundle.value = '',fetchDataBundles(), Navigator.pop(context)}),
                                    const Gap(16),
                                    const Divider(color: AppColors.greyBorderColor),
                                    const Gap(16),
                                    networkWidget(context, img: 'glo', name: 'GLO', action: ()=>{ billPaymentsController.setNetworkLogo('glo'),billPaymentsController.selectedDataBundle.value = '',fetchDataBundles(), Navigator.pop(context)}),
                                    const Gap(16),
                                    const Divider(color: AppColors.greyBorderColor),
                                    const Gap(16),
                                    networkWidget(context, img: '9mobile', name: '9Mobile', action: ()=> { billPaymentsController.setNetworkLogo('9mobile'),billPaymentsController.selectedDataBundle.value = '',fetchDataBundles(), Navigator.pop(context)}),
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
                const Gap(38),
                const Gap(30),
                // Text(bundles.toString()
                // ),
            Obx(() {
              return SingleChildScrollView(
                child: Column( // Wrap the content in a Column to allow vertical scrolling
                  children: [
                    CustomTextfield(
                      label: 'Select Bundle',
                      hintText: billPaymentsController.selectedDataBundle.value != ''
                          ? billPaymentsController.selectedDataBundle.value
                          : "Select Data bundle",
                      keyboardType: TextInputType.number,
                      trailingSvg: 'dropdown',
                      readOnly: true,
                      callback: () async {
                        await showModalBottomSheet(
                          context: context,
                          builder: (_) => IntrinsicHeight(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              width: MediaQuery.of(context).size.width,
                              child: SingleChildScrollView(
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
                                            'Select Bundle',
                                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SvgPicture.asset('assets/svgs/cancel.svg'),
                                        ],
                                      ),
                                    ),
                                    const Gap(20),
                                    Column(
                                      children: List.generate(billPaymentsController.dataBundles.length, (index) {
                                        final bundle = bundles[index];
                                        return SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    print('Selected Bundle: ${bundle['PRODUCT_NAME']} - ${bundle['PRODUCT_ID']}');
                                                    billPaymentsController.setSelectDataBundle(bundle['PRODUCT_NAME']);
                                                    data_bundle = bundle;
                                                    billPaymentsController.dataamount.value = bundle['PRODUCT_ID'].toString();
                                                    ctrl.text = bundle['PRODUCT_ID'].toString();
                                                    print('Selected Bundle in Controller: ${billPaymentsController.selectedDataBundle.value}');
                                                    Navigator.pop(context);
                                                  },
                                                  child:SingleChildScrollView(
                                                     child:  Column(
                                                        children: [
                                                          bundleWidget(
                                                            context,
                                                            title: bundle['PRODUCT_NAME'] ?? 'Unknown Product',
                                                            // value: bundle['PRODUCT_ID'] ?? 'Unknown ID',
                                                            value: ''
                                                          ),
                                                          const Gap(16),
                                                          if (index != bundles.length - 1)
                                                            const Divider(color: AppColors.greyBorderColor),
                                                        ],
                                                      )
                                                  ),
                                                )
                                              ],
                                            )
                                        );
                                      }),
                                    ),
                                    const Gap(46),
                                  ],
                                ),
                              )
                            ),
                          ),
                        );
                      },
                    ),

                  ],
                ),
              );
            }),

            Obx((){
              return
                CustomTextfield(
                  // ctrl: ctrl,
                  hintText: '₦${billPaymentsController.dataamount.value.toString()}.00',
                  readOnly: true,
                );
            }),
            const Spacer(),
                 primaryButton(context,
                     color: AppColors.primaryColor, title: 'Confirm',
                     onTap: () async {
                   print(ctrl.text);
                   if(phone_controller.text.isEmpty ) {
                     Get.snackbar('Error', 'Enter a valid Phone number',snackPosition: SnackPosition.BOTTOM,
                       backgroundColor: Colors.red, colorText: Colors.white,
                       icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),);
                   }else if(ctrl.text.isEmpty ) {
                     Get.snackbar('Error', 'Select a plan',snackPosition: SnackPosition.BOTTOM,
                       backgroundColor: Colors.red, colorText: Colors.white,
                       icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),);
                   }else {
                     storage.write('buy_data', {
                       'bundle': data_bundle,
                       'amount': ctrl.text,
                       'phone_number': phone_controller.text,
                       'network': billPaymentsController.networkLogo
                     });
                     print(storage.read('buy_data'));

                     await showModalBottomSheet(
                       context: context,
                       builder: (context) {
                         return const PinBottomsheetView(action: 'data',);
                       },
                     );
                   }
                }),
                const Gap(36),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

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
Widget bundleWidget(
    BuildContext context, {
      required String title,
      required String value,
    }) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded( // To ensure the text fits within available space
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Use Axis.horizontal for horizontal scrolling
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  fontFamily: 'Roboto'

              ),
              overflow: TextOverflow.ellipsis, // Prevents overflow
            ),
          ),
        ),
        const SizedBox(width: 10), // Optional space between title and value
        SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Use Axis.horizontal for horizontal scrolling
          child: Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                fontFamily: 'Roboto'
            ),
            overflow: TextOverflow.ellipsis, // Prevents overflow
          ),
        ),
      ],
    );
