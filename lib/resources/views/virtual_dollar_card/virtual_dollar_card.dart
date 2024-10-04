import 'package:waiz/app/Models/user/User.dart';
import 'package:waiz/app/http/controllers/virtual_card_controller.dart';
import 'package:waiz/resources/views/home/add_money/add_money.dart';
// import 'package:waiz/resources/views/home/dashboard.dart';
import 'package:waiz/resources/views/profile/profile.dart';
import 'package:waiz/resources/views/profile/profile_setting.dart';
import 'package:waiz/resources/views/virtual_dollar_card/widgets/virtual_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../utils/button.dart';
import '../../widgets/transaction_card.dart';
import '../success_view.dart';
import 'card_details_view.dart';
import 'kyc_verification.dart';
import 'package:get/get.dart';

class VirtualDollarCard extends StatefulWidget {
  const VirtualDollarCard({super.key});
@override
  State<VirtualDollarCard> createState() => _VirtualDollarCard();
}
class _VirtualDollarCard extends State<VirtualDollarCard>{

  bool viewDetails = true;
  final VirtualDollarCardController virtualDollarCardController = Get.put(VirtualDollarCardController());

  bool isTransaction = false;
  late var depositHistory = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    GetStorage storage = GetStorage();
    bool isVerified = User().isKYCVerified;
    depositHistory = storage.read('deposit_history')[0]['history'];
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
     body:  isVerified ? ViewDetails() :
     SingleChildScrollView(
       child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(28),
            Container(
              // height: 200,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/card_bg.png'),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('assets/images/logo.png',
                      height: 35,width: 35,),
                      Image.asset('assets/images/visa.png'),
                    ],
                  ),
                  const Gap(39),
                  Text(
                    '',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                  ),
                  Row(
                    children: [
                      Image.asset('assets/images/card_part.png'),
                    ],
                  ),
                  const Gap(12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Card holder name',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                          ),
                          const Gap(10),
                          Text(
                            User().fullName,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Expiry date',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                          ),
                          const Gap(10),
                          Text(
                            '**/30',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(18),
            Text(
              ' Virtual card',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
            ),
            const Gap(11),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/svgs/budget.svg'),
                    const Gap(25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budget Effectively',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                        ),
                        const Gap(8),
                        Text(
                          'Limit spending by only using the\namount uploaded to your card',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/svgs/phone.svg'),
                    const Gap(25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Digital Native',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                        ),
                        const Gap(8),
                        Text(
                          'A digital card for your digital life',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(40),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/svgs/dollar.svg'),
                    const Gap(25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card Creating Fee',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                        ),
                        const Gap(8),
                        Text(
                          'USD 2.00 fee to create a USD card. ',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Gap(34),
            primaryButton(context, title: 'Proceed', onTap: () {
              if(User().isKYCVerified){
                Get.to(const SuccessView(
                  content: 'Your payment has been successful',
                  buttonText: 'View Card',
                ));
              }else{
                Get.to(const KycVerification());
              }
            }),
            const Gap(24),
          ],
        ),
      ),
      ),

    );
  }

  Widget ViewDetails() {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          virtualCard(context: context,viewDetails: viewDetails,virtualDollarCardController: virtualDollarCardController),
          const Gap(18),
          Text(
            'Card balance',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
      Text(
        viewDetails ? "USD " + virtualDollarCardController.balance.toString() : '****',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
           const Gap(21),
         actionIcons(),
          const Gap(21),
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Transactions",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const Gap(21),
              isTransaction ? SingleChildScrollView(
                child: Column(
                  children: List.generate(depositHistory.length, (index){
                    var trx = depositHistory[index];
                    String time = DateFormat('hh:mm a').format(DateTime.parse('${trx['created_at']}'));
                    String formatted = DateFormat('dd MMM yyyy').format(DateTime.parse('${trx['created_at']}'));
                    var val = trx['detail'][0];
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Gap(10),
                          TransactionCard(
                              title: '${trx['method_currency']} Deposit',
                              date: '$formatted',
                              bankInfo: '$val',
                              iconPath: 'assets/images/baby.png',
                              status: '${trx['status']}',
                              time: '$time',
                              transactionId: '${trx['trx']}',
                              amount: '2000'),
                          const Gap(10),
                        ]
                    );
                  }
                  ).toList(),
                )
              ) : const Center(
                child: Text('No Transactions'),
              )
            ],
          )
          // const Spacer(),
          // primaryButton(context,
          //     title: viewDetails ? 'Hide details' : 'View details',
          //     onTap: () {
          //       setState(() {
          //         viewDetails = !viewDetails;
          //       });
          //     }),
          // const Gap(24),
        ],
      ),
    ));
  }
  Widget actionIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {
            Get.to(const ProfileSettingView()); // Navigate using GetX
          },
          child: const Column(
            children: [
              Icon(Icons.add), // Display the icon
              Text("Top up"), // Display the text
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Get.to(const ProfileSettingView()); // Navigate using GetX
          },
          child: Column(
            children: [
              Transform.rotate(
                angle: -45, // Rotate 45 degrees in radians
                child: const Icon(Icons.arrow_downward_rounded),
              ),
              const  Text("Withdraw"), // Display the text
            ],
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
            viewDetails = !viewDetails;
            });
          },
          child: Column(
            children: [
              Icon(
                viewDetails ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              ) ,// Display the icon
              SizedBox(
                width: 60,
                child: Text(
                  viewDetails ? 'Hide details' : 'View details', // Display the text
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Get.to(const ProfileSettingView()); // Navigate using GetX
          },
          child: const Column(
            children: [
              Icon(Icons.receipt_outlined), // Display the icon
              Text("Statement"), // Display the text
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Get.to(const ProfileSettingView()); // Navigate using GetX
          },
          child: const Column(
            children: [
              Icon(Icons.more_horiz), // Display the icon
              Text("More"), // Display the text
            ],
          ),
        ),
      ],
    );
  }

}
