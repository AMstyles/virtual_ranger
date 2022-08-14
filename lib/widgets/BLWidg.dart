import 'package:flutter/material.dart';

import '../models/BL.dart';
import '../models/constants.dart';

class BusinessListingWidg extends StatelessWidget {
  BusinessListingWidg({Key? key, required this.businessListing})
      : super(key: key);
  BusinessListing businessListing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          Image.network(
            BUSINESS_LISTINGS_IMAGE_URL + businessListing.logo,
            fit: BoxFit.contain,
            height: 60,
            width: 60,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    businessListing.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    businessListing.businesType,
                    style: const TextStyle(),
                  ),
                  // ignore: unnecessary_string_interpolations
                  Text(
                    "${businessListing.firstNumber} ${businessListing.secondNumber}",
                    style: const TextStyle(),
                  ),
                  (businessListing.email != '')
                      ? Text(businessListing.address)
                      : const SizedBox(),
                  const Divider(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
