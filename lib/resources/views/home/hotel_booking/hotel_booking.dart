import 'package:waiz/resources/views/home/hotel_booking/search_hotel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../widgets/custom_textfield.dart';

class HotelBooking extends StatelessWidget {
  const HotelBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(MediaQuery.of(context).padding.top + 24),
              InkWell(
                onTap: Navigator.of(context).pop,
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back),
                    const Gap(24),
                    Text(
                      'Hotel Booking',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              CustomTextfield(
                hintText: 'Search for country, Hotel',
                svgPrefix: 'hotel_search',
                trailingSvg: 'filter',
                readOnly: true,
                callback: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => const SearchHotel(),
                  ));
                },
              ),
              const Gap(11),
              Text(
                'Recommended for you',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Gap(18),
              SizedBox(
                height: 350 * MediaQuery.of(context).textScaler.scale(1),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) => Column(
                    children: [
                      recommendedWidget(context, title: 'The An’s Vill Hotel'),
                    ],
                  ),
                ),
              ),
              const Gap(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Destination',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    'See all',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF003130),
                        ),
                  ),
                ],
              ),
              const Gap(14),
              popularDestinations(
                context,
                title: 'Anu Hotel',
                subtitle: 'Pimple Gurav,Pune',
                amount: '165.3',
              ),
              popularDestinations(
                context,
                title: 'Anu Hotel',
                subtitle: 'Pimple Gurav,Pune',
                amount: '165.3',
              ),
              popularDestinations(
                context,
                title: 'Anu Hotel',
                subtitle: 'Pimple Gurav,Pune',
                amount: '165.3',
              ),
              popularDestinations(
                context,
                title: 'Anu Hotel',
                subtitle: 'Pimple Gurav,Pune',
                amount: '165.3',
              ),
              //

              Gap(MediaQuery.of(context).padding.bottom + 24),
            ],
          ),
        ),
      ),
    );
  }
}

Widget popularDestinations(
  BuildContext context, {
  required String title,
  required String subtitle,
  required String amount,
}) =>
    Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F121212),
            offset: Offset(4, 4),
            blurRadius: 16,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/hotel_list.png',
            frameBuilder: (_, child, __, ___) {
              return Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: child,
              );
            },
          ),
          const Gap(16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(builder: (context, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Anu Hotel',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF003130),
                          ),
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/euro.svg',
                          height: 16,
                          width: 16,
                        ),
                        // const Gap(2),
                        Text(
                          '200,7 ',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                        ),
                        Text(
                          '/night',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: const Color(0xFF878787),
                                  ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              const Gap(8),
              Text(
                'Pimple Gurav, Pune',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
              ),
              const Gap(8),
              Wrap(
                spacing: 4,
                children: [
                  SvgPicture.asset('assets/svgs/rating.svg'),
                  SvgPicture.asset('assets/svgs/rating.svg'),
                  SvgPicture.asset('assets/svgs/rating.svg'),
                  SvgPicture.asset('assets/svgs/rating.svg'),
                  SvgPicture.asset('assets/svgs/rating.svg'),
                  Text(
                    '5.0',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: const Color(0xFF101010),
                        ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );

Widget recommendedWidget(
  BuildContext context, {
  required String title,
  String? rating,
}) =>
    Container(
      padding: const EdgeInsets.only(bottom: 12),
      margin: const EdgeInsets.only(right: 16),
      width: 253,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F121212),
            offset: Offset(4, 4),
            blurRadius: 16,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/hotel_image.png'),
          const Gap(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/rating.svg',
                      colorFilter: const ColorFilter.mode(
                        Colors.yellow,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      rating ?? '5.0',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Pimple Gurav, Pune',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
            ),
          ),
          const Gap(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/svgs/euro.svg',
                  height: 20,
                  width: 20,
                ),
                const Gap(2),
                Text(
                  '200,7 ',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                ),
                Text(
                  '/night',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: const Color(0xFF878787),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
