import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/BL.dart';
import '../models/constants.dart';

class BusinessListingWidg extends StatelessWidget {
  BusinessListingWidg({Key? key, required this.businessListing})
      : super(key: key);
  BusinessListing businessListing;

  @override
  Widget build(BuildContext context) {
    //BusinessListing businessListing = ;
    return GestureDetector(
      onTap: () {
        showBottomSheet(
            context: context,
            builder: ((context) {
              return SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  height: 400,
                  child: Center(
                      child: Column(
                    children: [
                      businessListing.firstNumber != ''
                          ? ListTile(
                              iconColor: Colors.blue,
                              leading: const Icon(Icons.phone),
                              title: Text(businessListing.firstNumber))
                          : const SizedBox(),
                      businessListing.secondNumber != ''
                          ? ListTile(
                              iconColor: Colors.blue,
                              leading: const Icon(Icons.phone),
                              title: Text(businessListing.secondNumber))
                          : const SizedBox(),
                      businessListing.email != ''
                          ? ListTile(
                              iconColor: Colors.green,
                              leading: const Icon(Icons.email),
                              title: Text(businessListing.email))
                          : const SizedBox(),
                      CupertinoButton(
                        color: CupertinoColors.destructiveRed,
                        child: const Text('Close'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  )),
                ),
              );
            }));
      },
      child: Container(
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
      ),
    );
  }
}
