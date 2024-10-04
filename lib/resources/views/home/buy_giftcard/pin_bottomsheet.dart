import 'package:waiz/app/http/controllers/bill_payments.dart';
import 'package:waiz/resources/views/home/bills_payment/bill_success.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';

import '../../../../app/Models/user/User.dart';
import '../../../../app/http/controllers/exchange_controller.dart';
import '../../../../app/http/controllers/payment_controller.dart';

class PinBottomsheetView extends StatefulWidget {
  final String? successText;
  final Widget? next;
  final String? action;
  const PinBottomsheetView({super.key, this.successText, this.next, this.action});

  @override
  State<PinBottomsheetView> createState() => _PinBottomsheetViewState();
}

class _PinBottomsheetViewState extends State<PinBottomsheetView> {
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController();
  }

  @override
  void dispose() {
    _ctrl = TextEditingController();
    super.dispose();
  }

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
                  borderRadius: BorderRadius.circular(28)),
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
            Pinput(
              controller: _ctrl,
              length: 4,
              onCompleted: (val) async {
    print(val);
    if(User().pin.toString() == val.toString()){
      if (widget.action == 'data') {
        BillPaymentsController bill = Get.put(
            BillPaymentsController());

        bill.isLoading.value = true;
        await bill.buyData();
        Navigator.pop(context);
        bill.isLoading.value = false;

      }else if (widget.action == 'cable_tv') {
        BillPaymentsController bill = Get.put(
            BillPaymentsController());
        var buy = await bill.subscribeTv();
        if (buy) {
          Get.to(BillSuccess());
        } else {
          Get.snackbar('Error', 'Transaction Failed',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red, colorText: Colors.white,
            icon: const Icon(
                Icons.warning_amber_rounded, color: Colors.white),);
        }

      }else if (widget.action == 'electricity') {
        BillPaymentsController bill = Get.put(
            BillPaymentsController());

        bill.isLoading.value = true;
        await bill.subscribeElectricity();
        Navigator.pop(context);
        bill.isLoading.value = false;

      } else if (widget.action == 'betting') {
        BillPaymentsController bill = Get.put(
            BillPaymentsController());
        bill.isLoading.value = true;
        await bill.fundBetting();
        Navigator.pop(context);
        bill.isLoading.value = false;


      } else if (widget.action == 'add_money') {

        // Get.delete<PaymentController>();
        PaymentController bill = Get.put(
            PaymentController());
        bill.isLoading.value = true;
        await bill.manualDepositUpdate();
        Navigator.pop(context);
        bill.isLoading.value = false;
      }else if (widget.action == 'exchange') {
        // Get.delete<PaymentController>();
        ExchangeController bill = Get.put(
            ExchangeController());
        bill.isLoading.value = true;
        await bill.exchangeConfirm();
        // Navigator.pop(context);
        bill.isLoading.value = false;
      }    else {
        BillPaymentsController bill = Get.put(
            BillPaymentsController());
        GetStorage storage = GetStorage();

        bill.isLoading.value = true;
        await bill.buyAirtime();
        Navigator.pop(context);
        bill.isLoading.value = false;

      }
    }else{
      // print('${User().pin.toString() == val.toString()}:  ${User().pin.toString()}  ${val.toString()}');
      Get.snackbar(
        'Error',
        'Incorrect pin',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
      );
    }
              }

            ),
            const Gap(24),
          ],
        ),
      ),
    );
  }
}
