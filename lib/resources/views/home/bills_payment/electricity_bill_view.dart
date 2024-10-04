import 'package:waiz/app/http/controllers/bill_payments.dart';
import 'package:waiz/resources/utils/app_colors.dart';
import 'package:waiz/resources/widgets/usable_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../utils/button.dart';
import '../../../widgets/custom_textfield.dart';
import '../buy_giftcard/pin_bottomsheet.dart';

class ElectricityBillView extends StatefulWidget {
  const ElectricityBillView({super.key});

  @override
  State<ElectricityBillView> createState() => ElectricityBillViewState();
}

class ElectricityBillViewState extends State<ElectricityBillView> {
  BillPaymentsController billPaymentsController = BillPaymentsController();
  late Future<Map<String, dynamic>> electricityData;
  late TextEditingController ctrl;
  late TextEditingController meterNumberController;
  late TextEditingController amount;
  bool viewDetails = true;
  late GetStorage storage;
  List<Map<String, dynamic>> electricity_plans = [];
  List<Map<String, dynamic>> electricity_packages = [];
  late Map<String, dynamic> plan = {};

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController(text: '₦');
    meterNumberController = TextEditingController();
    amount = TextEditingController();
    storage = GetStorage();
    fetch();
  }
  // Assuming this is in an async function
  Future<void> fetch() async {
    print('Started loading');
    // BillPaymentsController billPaymentsController = Get.put(BillPaymentsController());

    // Await the future to get the actual data
    electricity_plans = await billPaymentsController.getElectricityPlans();
    electricity_packages = await  billPaymentsController.getElectricityPackages('Eko Electric - EKEDC (PHCN)');
    electricityData = billPaymentsController.fetchElectricityData();
    print('Loaded');
    billPaymentsController.isLoading.value = false;

  }
  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Obx((){
        return billPaymentsController.isLoading.value ? const UsableLoading():
        CustomScrollView(slivers: [
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
                          'Electricity',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(32),
                  Obx((){
                    return CustomTextfield(
                      label: 'City',
                      ctrl: TextEditingController(text: billPaymentsController.selectedElectricityPlan.value != ''
                          ? billPaymentsController.selectedElectricityPlan.value
                          : 'Select City'),
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
                                      child:SingleChildScrollView(
                                        child:  Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(),
                                            Text(
                                              'Electricity',
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
                                    ),
                                    const Gap(22),
                                    Column(
                                      children: List.generate(electricity_plans.length, (index) {
                                        final bundle = electricity_plans[index];
                                        return InkWell(
                                          onTap: () async {
                                            billPaymentsController.isLoading.value = true;
                                            billPaymentsController.setSelectElectricityPlan(bundle['title'].toString().replaceAll("_", " "));
                                            billPaymentsController.electricCompanyCode(bundle['id']);
                                            print(billPaymentsController.electric_company_code);
                                            plan = bundle;
                                            await billPaymentsController.getElectricityPackages(bundle['title']);
                                            billPaymentsController.isLoading.value = false;
                                            Navigator.pop(context);
                                          },
                                          child: Column(
                                            children: [
                                              electricSheetWidget(
                                                context,
                                                title: bundle['title'].toString().replaceAll("_", ' '),
                                              ),
                                              const Gap(16),
                                              if (index != electricity_plans.length - 1)
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
                  const Gap(32),
                  Obx((){
                    return CustomTextfield(
                      label: 'Meter Type',
                      ctrl: TextEditingController(text: billPaymentsController.selectedElectricityPackage.value != ''
                          ? billPaymentsController.selectedElectricityPackage.value
                          : 'Select Meter Type'),
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
                                      child:SingleChildScrollView(
                                        child:  Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            const SizedBox(),
                                            Text(
                                              'Electricity',
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
                                    ),
                                    const Gap(22),
                                    Column(
                                      children: List.generate(electricity_packages.length, (index) {
                                        final bundle = electricity_packages[index];
                                        return InkWell(
                                          onTap: () {
                                            billPaymentsController.setSelectElectricityPackage(bundle['PRODUCT_TYPE'].toString());
                                            plan = bundle;
                                            // ctrl.text = bundle['price'].toString();
                                            // print(data_bundle);
                                            // print(billPaymentsController.selectedDataBundle.value); // Use .value
                                            Navigator.pop(context);
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(bundle['PRODUCT_TYPE'].toString()),
                                                  Text('₦${bundle['MINIMUN_AMOUNT'].toString()} - ₦${bundle['MAXIMUM_AMOUNT'].toString()}',
                                                  style: const TextStyle(
                                                    fontFamily: 'Roboto'
                                                  ),),
                                                ],
                                              ),
                                              // ),
                                              // electricSheetWidget(
                                              //   context, title: '${bundle['PRODUCT_TYPE'].toString()}    ',
                                              //   // title: bundle['title'].toString().replaceAll("_", ' '),
                                              // ),
                                              const Gap(16),
                                              if (index != electricity_packages.length - 1)
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
                    label: 'Meter Number',
                    hintText: 'Number',
                    ctrl: meterNumberController,
                  ),
                  const Gap(41),
                  CustomTextfield(
                    label: 'Amount',
                    hintText: '₦',
                    ctrl: amount,
                    keyboardType: TextInputType.number,
                  ),
              const Gap(41),
              
                  // const Spacer(),
                  primaryButton(context, color: AppColors.primaryColor, title: 'Confirm',
                      onTap: () async {
                        print(ctrl.text);
                        if(plan.isEmpty) {
                          Get.snackbar('Error', 'Select your plan',snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red, colorText: Colors.white,
                            icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),);
                        }else if(meterNumberController.text.isEmpty ) {
                          Get.snackbar('Error', 'Enter a valid Prepaid number',snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red, colorText: Colors.white,
                            icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),);
                        }else if(amount.text.isEmpty ) {
                          Get.snackbar('Error', 'Enter the amount',snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red, colorText: Colors.white,
                            icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),);
                        }else if(ctrl.text.isEmpty ) {
                          Get.snackbar('Error', 'Select a plan',snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red, colorText: Colors.white,
                            icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),);
                        }else {
                          storage.write('electricity', {
                            'plan': plan,
                            'amount': amount.text,
                            'channel': billPaymentsController.selectedElectricityPlan,
                            'meter_number': meterNumberController.text,
                            'electric_company_code':billPaymentsController.electric_company_code.toString()
                          });
                          // print(storage.read('electricity'));

                          await showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return const PinBottomsheetView(action: 'electricity',);
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

Widget electricSheetWidget(
  BuildContext context, {
  required String title,
}) =>
    Row(
      children: [
        Image.asset('assets/images/ie.png'),
        const Gap(18),
        Text(
          '$title electric',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
        ),
      ],
    );

