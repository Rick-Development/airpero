import 'package:waiz/resources/views/home/hotel_booking/review_hotel.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/button.dart';
import '../../../widgets/custom_textfield.dart';

class BookHotelNow extends StatefulWidget {
  const BookHotelNow({super.key});

  @override
  State<BookHotelNow> createState() => BookHotelNowState();
}

class BookHotelNowState extends State<BookHotelNow> {
  late TextEditingController ctrl;
  bool viewDetails = true;
  int number = 0;

  modNumber([bool add = true]) {
    if (mounted) {
      setState(() {
        if (add) {
          number++;
        } else {
          number--;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ctrl = TextEditingController(text: '₦');
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
                        'Hotel Details',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                      ),
                    ],
                  ),
                ),
                const Gap(36),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Please complete this section to let us know how\nmany guests will be staying and when. Enter\nyour check-in and Check-out dates to confirm\nyour hotel booking',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                  ),
                ),
                const Gap(36),
                const CustomTextfield(
                  label: 'Check In Date',
                  hintText: 'Date',
                  trailingSvg: 'date',
                ),
                const Gap(36),
                const CustomTextfield(
                  label: 'Check Out Date',
                  hintText: 'Date',
                  trailingSvg: 'date',
                ),
                const Gap(36),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFFEEEEF0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Guest',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              modNumber(false);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              child: const Icon(
                                Icons.remove,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          const Gap(22),
                          Text(
                            '$number',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 21,
                                ),
                          ),
                          const Gap(22),
                          InkWell(
                            onTap: modNumber,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const Spacer(),
                primaryButton(context, title: 'Next', onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const ReviewHotel(),
                  ));
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
