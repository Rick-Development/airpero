import 'package:waiz/resources/widgets/usable_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../app/http/controllers/bill_payments.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/button.dart';
import '../../../widgets/custom_textfield.dart';
import '../buy_giftcard/pin_bottomsheet.dart';


class BettingView extends StatefulWidget {
  const BettingView({super.key});

  @override
  State<BettingView> createState() => BettingViewState();
}

class BettingViewState extends State<BettingView> {
  late TextEditingController ctrl;
  bool viewDetails = true;
  BillPaymentsController billPaymentsController = Get.put(BillPaymentsController());
  late TextEditingController  amoutController;
  late TextEditingController smartcardController;
  late GetStorage storage;
  List<Map<String, dynamic>> brokers = [];

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController(text: '₦');
    fetchTvPlans();
    amoutController  = TextEditingController();
    smartcardController = TextEditingController();
    storage = GetStorage();
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }


  // Assuming this is in an async function
  Future<void> fetchTvPlans() async {

    // Await the future to get the actual data
    brokers = await billPaymentsController.getBrokers();
    // Now you can use the `bundles` list
    // print(brokers);
    billPaymentsController.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    dynamic plan;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Betting',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx((){
        return  billPaymentsController.isLoading.value == true ? const UsableLoading() : CustomScrollView(slivers: [
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(MediaQuery.of(context).padding.top + 14),
                  Obx((){
                    return  CustomTextfield(
                      label: 'Select Broker',
                      hintText: billPaymentsController.selectedBroker.value != ''
                          ? billPaymentsController.selectedBroker.value
                          : "Select Broker",
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
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(),
                                          Text(
                                            'Select Broker',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SvgPicture.asset('assets/svgs/cancel.svg'),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: List.generate(brokers.length, (index) {
                                        final bundle = brokers[index];
                                        return InkWell(
                                          onTap: () {
                                            billPaymentsController.setSelectedBroker(bundle['title']);
                                            plan = bundle;
                                            // ctrl.text = bundle['price'].toString();
                                            // print(data_bundle);
                                            // print(billPaymentsController.selectedDataBundle.value); // Use .value
                                            Navigator.pop(context);
                                          },
                                          child: Column(
                                            children: [
                                              tvSheetWidget(
                                                context,
                                                title: bundle['title'],
                                                img: bundle['img'],
                                              ),
                                              const Gap(16),
                                              if (index != brokers.length - 1)
                                                const Divider(color: AppColors.greyBorderColor),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                    const Gap(36),
                                  ],
                              ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  const Gap(23),
                  CustomTextfield(
                    label: 'Sporty ID',
                    hintText: 'Enter your sport id',
                    ctrl: smartcardController,
                  ),
                  const Gap(41),
                  CustomTextfield(
                    label: 'Amount',
                    hintText: '₦',
                    ctrl: amoutController,
                    keyboardType: TextInputType.number,
                  ),
                  const Spacer(),
                  primaryButton(context, color: AppColors.primaryColor, title: 'Confirm',
                      onTap: () async {
                        print(ctrl.text);
                        if(smartcardController.text.isEmpty ) {
                          Get.snackbar('Error', 'Enter your Sport ID',snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red, colorText: Colors.white,
                            icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),);
                        }else if(amoutController.text.isEmpty ) {
                          Get.snackbar('Error', 'Enter an amount',snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red, colorText: Colors.white,
                            icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),);
                        }else if(ctrl.text.isEmpty ) {
                          Get.snackbar('Error', 'Select a plan',snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red, colorText: Colors.white,
                            icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),);
                        }else {
                          storage.write('betting', {
                            'plan': plan,
                            'amount': amoutController.text,
                            'channel': billPaymentsController.selectedBroker,
                            'sport_id': smartcardController.text
                          });
                          print(storage.read('betting'));

                          await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return const PinBottomsheetView(action: 'betting',);
                            },
                          );
                        }
                      }),
                  const Gap(36),
                ],
              ),
            ),
          ),
        ]);
      }),
    );
  }
}

Widget tvSheetWidget(
    BuildContext context, {
      required String title,
      required String img,
    }) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        Image.asset('assets/images/$img.png'),
      ],
    );
