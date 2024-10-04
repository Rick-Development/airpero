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


class TvBillView extends StatefulWidget {
  const TvBillView({super.key});

  @override
  State<TvBillView> createState() => TvBillViewState();
}

class TvBillViewState extends State<TvBillView> {
  late TextEditingController ctrl;
  bool viewDetails = true;
  BillPaymentsController billPaymentsController = Get.put(BillPaymentsController());
  late TextEditingController  amoutController;
  late TextEditingController smartcardController;
  late GetStorage storage;
  List<Map<String, dynamic>> tv_plans = [];
  List<Map<String, dynamic>> tv_packages = [];
  late bool isLoading = true;

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
    BillPaymentsController billPaymentsController = Get.put(BillPaymentsController());

    // Await the future to get the actual data
    tv_plans = await billPaymentsController.getTvBundles();
    tv_packages = await billPaymentsController.getTvPackages('dstv');
    isLoading = false;
    billPaymentsController.isLoading.value = false;
    // Now you can use the `bundles` list
    print(tv_plans);
  }

  @override
  Widget build(BuildContext context) {
    dynamic plan;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Cable Tv',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx((){
        return  billPaymentsController.isLoading.value ? const UsableLoading() :
        CustomScrollView(slivers: [
          SliverFillRemaining(
              child: Stack(
                  children: [Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(MediaQuery.of(context).padding.top + 14),
                        Obx((){
                          return  CustomTextfield(
                            label: 'Select Channel',
                            hintText: billPaymentsController.selectedTvPlan.value != ''
                                ? billPaymentsController.selectedTvPlan.value
                                : "DSTV",
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
                                                'Select Tv',
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
                                          children: List.generate(tv_plans.length, (index) {
                                            final bundle = tv_plans[index];
                                            return InkWell(
                                              onTap: () async {
                                                billPaymentsController.isLoading.value = true;
                                                billPaymentsController.setSelectTvPlan(bundle['title']);
                                                plan = bundle;
                                                tv_packages = await  billPaymentsController.getTvPackages(bundle['title']);

                                                billPaymentsController.isLoading.value = false;
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
                                                  if (index != tv_plans.length - 1)
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
                              );
                            },
                          );
                        }),
                        const Gap(23),
                        Obx((){
                          return  CustomTextfield(
                            label: 'Select Package',
                            hintText: billPaymentsController.selectedTvPackage.value != ''
                                ? billPaymentsController.selectedTvPackage.value
                                : "Select Package",
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
                                                    'Select Package',
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
                                            SingleChildScrollView(
                                              child:  Column(
                                                children: List.generate(tv_packages.length, (index) {
                                                  final bundle = tv_packages[index];
                                                  return SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            billPaymentsController.setSelectTvPackage(bundle['PACKAGE_NAME']);
                                                            amoutController.text = bundle['PACKAGE_AMOUNT'];
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
                                                                title: bundle['PACKAGE_NAME'],
                                                                img: bundle['img'].toString().toLowerCase(),
                                                              ),
                                                              const Gap(16),
                                                              if (index != tv_packages.length - 1)
                                                                const Divider(color: AppColors.greyBorderColor),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                            const Gap(36),
                                          ],
                                        )),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                        const Gap(23),
                        CustomTextfield(
                          label: 'Smartcard Number',
                          hintText: 'Enter smartcard number',
                          ctrl: smartcardController,
                        ),
                        const Gap(23),
                        CustomTextfield(
                          label: 'Amount',
                          hintText: '₦${amoutController.text}',
                          ctrl: amoutController,
                          keyboardType: TextInputType.number,
                          readOnly: true,
                        ),
                        const Spacer(),
                        primaryButton(context, color: AppColors.primaryColor, title: 'Confirm',
                            onTap: () async {
                              if(smartcardController.text.isEmpty ) {
                                Get.snackbar('Error', 'Enter your smartcard number',snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red, colorText: Colors.white,
                                  icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),);
                              }
                              // else if(ctrl.text.isEmpty ) {
                              //   Get.snackbar('Error', 'Enter your smartcard number',snackPosition: SnackPosition.BOTTOM,
                              //     backgroundColor: Colors.red, colorText: Colors.white,
                              //     icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),);
                              // }
                              else if(amoutController.text.isEmpty ) {
                                Get.snackbar('Error', 'Select your package',snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red, colorText: Colors.white,
                                  icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),);
                              }else {
                                storage.write('cable_tv', {
                                  'plan': plan,
                                  'amount': amoutController.text,
                                  'channel': billPaymentsController.selectedTvPlan,
                                  'package': billPaymentsController.selectedTvPackage,
                                  'smartcard': smartcardController.text
                                });
                                print(storage.read('cable_tv'));

                                await showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return const PinBottomsheetView(action: 'cable_tv',);
                                  },
                                );
                              }
                            }),
                        const Gap(36),
                      ],
                    ),
                  ),
                    Obx((){
                      return billPaymentsController.isLoading.value ? UsableLoading() : Container();
                    })
                  ]
              )
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
    Expanded( // To ensure the text fits within available space
    child: SingleChildScrollView(
    scrollDirection: Axis.horizontal, // Use Axis.horizontal for horizontal scrolling
      child:Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
        )
    )
    ),
        Image.asset('assets/images/$img.png'),
      ],
    );
