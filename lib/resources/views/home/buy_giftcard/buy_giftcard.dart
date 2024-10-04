import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import '../../../../app/http/controllers/giftcards/giftcard_controller.dart';
import 'buy_single_giftcard.dart';
import 'package:get/get.dart';

class BuyGiftcardView extends StatefulWidget {
  const BuyGiftcardView({super.key});

  @override
  State<BuyGiftcardView> createState() => BuyGiftcardViewState();
}

class BuyGiftcardViewState extends State<BuyGiftcardView> {
  final GiftCardController giftCardController = Get.put(GiftCardController());
  final TextEditingController searchController = TextEditingController();

  bool viewDetails = true;

  @override
  void initState() {
    super.initState();
    // Fetch products and categories when the page loads
    giftCardController.getProducts();
    giftCardController.getCategories();

    searchController.addListener(() {
      giftCardController.searchProducts(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    var products = giftCardController.filteredProducts;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      'Buy Gift Card',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(28),
              const Gap(11),
              CustomTextfield(
                controller: searchController,
                hintText: 'Search for Giftcard',
                trailingSvg: 'search',
              ),
              const Gap(11),
              Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 items per row
                        crossAxisSpacing: 8.0, // Space between columns
                        mainAxisSpacing: 8.0,  // Space between rows
                        childAspectRatio: 0.8, // Aspect ratio to adjust the card's height
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        // Get the product details from the list
                        final product = products[index];
                        final image = product["logoUrls"].isNotEmpty
                            ? product["logoUrls"][0]
                            : "https://via.placeholder.com/50"; // Default image if logo is missing
                        final text = product["productName"];
                        final logiUrls = product["logoUrls"][0].toString();
                        final recipientCurrencyCode = product["recipientCurrencyCode"].toString();

                        // Generate the gift card widget for this product
                        return giftcardWidget(context, image, text,{
                          'productName': text,
                          'productId': product["productId"].toString(),
                          'senderFee':product["senderFee"].toString(),
                          'logoUrls':logiUrls,
                          'recipientCurrencyCode': recipientCurrencyCode,
                          'country':product["country"]['name'].toString(),
                          'isoName':product["country"]["isoName"].toString(),
                        });
                      },
                    ), // Display the grid of gift cards
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget giftcardWidget(BuildContext context, String image, String text,Map<String, dynamic> cardDetails) => InkWell(
  onTap: () {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => BuySingleGiftcardView(image: image, text:text, cardDetails:cardDetails),
    ));
  },
  child: Container(
    width: 150,
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(image),
        const Gap(15),
        Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: 12,
          ),
        )
      ],
    ),
  ),
);


class CustomTextfield extends StatelessWidget {
  final String hintText;
  final String trailingSvg;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;

  const CustomTextfield({
    Key? key,
    required this.hintText,
    required this.trailingSvg,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged, // Ensure this callback is used correctly
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset(
            'assets/icons/$trailingSvg.svg',
            width: 20,
            height: 20,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}