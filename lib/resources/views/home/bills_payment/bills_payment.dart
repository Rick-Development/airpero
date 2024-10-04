import 'package:waiz/resources/views/home/bills_payment/betting_view.dart';
import 'package:waiz/resources/views/home/bills_payment/tv_bill_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'airtime_bill_view.dart';
import 'airtime_to_cash_view.dart';
import 'data_bill_view.dart.dart';
import 'electricity_bill_view.dart';


class BillsPaymentView extends StatefulWidget {
  const BillsPaymentView({super.key});

  @override
  State<BillsPaymentView> createState() => BillsPaymentViewState();
}

class BillsPaymentViewState extends State<BillsPaymentView> {
  bool viewDetails = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
                    'Bills Payment',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
            ),
            const Gap(37),
            Text(
              'Essentials',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
            ),
            const Gap(20),
            Wrap(
              spacing: 28,
              runSpacing: 28,
              children: [
                essentialWidget(context, svg: 'phonebill', title: 'Airtime',
                    onTap: () {
                  Get.to(const BuyAirtimeView());
                }),
                essentialWidget(context, svg: 'databill', title: 'Data',
                    onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const BuyDataView(),
                    ),
                  );
                }),
                essentialWidget(
                  context,
                  svg: 'tvbill',
                  title: 'TV',
                  onTap: () =>  Get.to(const TvBillView()),
                ),
                essentialWidget(
                  context,
                  svg: 'electricitybill',
                  title: 'Electricity',
                  onTap: () {
                    Get.to(ElectricityBillView());
                  },
                ),
                essentialWidget(
                  context,
                  svg: 'betting',
                  title: 'Betting',
                  onTap: () {
                    Get.to( const BettingView());
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget essentialWidget(BuildContext context,
        {required String svg, required String title, VoidCallback? onTap}) =>
    InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        width: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 2,
              color: Colors.black.withOpacity(.2),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            SvgPicture.asset('assets/svgs/$svg.svg'),
            const Gap(8),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: const Color(0xFF3E9850),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );






