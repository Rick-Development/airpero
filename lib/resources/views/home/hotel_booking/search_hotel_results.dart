import 'package:waiz/resources/views/home/hotel_booking/single_hotel_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

import '../../../widgets/custom_textfield.dart';

class SearchHotelResults extends StatelessWidget {
  const SearchHotelResults({super.key});

  @override
  Widget build(BuildContext context) {
    final locations = [
      'AN  Palace Hotel',
      'AN  Palace Hotel',
      'AN  Palace Hotel',
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(MediaQuery.of(context).padding.top + 24),

              const CustomTextfield(
                hintText: 'Search for country, Hotel',
                svgPrefix: 'arrow_back',
                trailingSvg: 'filter',
              ),
              const Gap(25),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  filterChip(context, filtername: 'Sort', svg: 'sort'),
                  filterChip(context, filtername: 'Banner', svg: 'cancel'),
                  filterChip(context, filtername: 'Price', svg: 'dropdown'),
                  filterChip(context, filtername: 'Trending'),
                ],
              ),
              //
              const Gap(26),
              const Divider(
                color: Color(0xFFEDEDED),
              ),
              const Gap(24),
              //
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '12 ADNs found',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: const Color(0xFF3E3E3E),
                        ),
                  ),
                  // #3E3E3ECC
                  Text(
                    'Price per night',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: const Color(0xFF3E3E3E),
                        ),
                  ),
                ],
              ),
              const Gap(22),
              Wrap(
                spacing: 24,
                direction: Axis.vertical,
                children: List.generate(
                  locations.length,
                  (index) => recommendedWidget(
                    context,
                    title: locations[index],
                  ),
                ),
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

Widget filterChip(
  BuildContext context, {
  required String filtername,
  String? svg,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        border: Border.all(
          color: const Color(0xFFD9D9D9),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            filtername,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
          ),
          if (svg != null) ...[
            const Gap(6),
            SvgPicture.asset(
              'assets/svgs/$svg.svg',
              height: 14,
              width: 14,
            ),
          ]
        ],
      ),
    );

Widget recommendedWidget(
  BuildContext context, {
  required String title,
  String? rating,
}) =>
    InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const SingleHotelView(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 25),
        // margin: const EdgeInsets.only(right: 16),
        width: MediaQuery.of(context).size.width - 50,
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
            SizedBox(
                height: 210,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/hotel_image.png',
                  fit: BoxFit.cover,
                )),
            const Gap(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
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
              child: Text(
                '2.7 km form centre .\nsafe parking  facility',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: const Color(0xFF878787),
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
      ),
    );
