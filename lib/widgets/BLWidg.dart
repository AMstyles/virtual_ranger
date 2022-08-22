import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
        print(businessListing.businesType);
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
                              onTap: () {
                                _makePhoneCall(businessListing.firstNumber);
                              },
                              iconColor: Colors.blue,
                              leading: const Icon(Icons.phone),
                              title: Text(businessListing.firstNumber))
                          : const SizedBox(),
                      businessListing.secondNumber != ''
                          ? ListTile(
                              onTap: () {
                                _makePhoneCall(businessListing.secondNumber);
                              },
                              iconColor: Colors.blue,
                              leading: const Icon(Icons.phone),
                              title: Text(businessListing.secondNumber))
                          : const SizedBox(),
                      businessListing.email != ''
                          ? ListTile(
                              onTap: () {
                                _makeEmail(businessListing.email);
                              },
                              iconColor: Colors.green,
                              leading: const Icon(Icons.email),
                              title: Text(businessListing.email))
                          : const SizedBox(),
                      (businessListing.type == 'Accommodation')
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                (businessListing.bookLink != null)
                                    ? CupertinoButton(
                                        color: CupertinoColors.activeGreen,
                                        child: const Text('book now'),
                                        onPressed: () async {
                                          final url = Uri.parse(
                                              businessListing.bookLink!);
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(
                                              url,
                                              mode: LaunchMode
                                                  .externalApplication,
                                              webOnlyWindowName: '_blank',

                                              //mode: LaunchMode.inAppWebView,
                                            );
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                      )
                                    : const SizedBox(),
                                CupertinoButton(
                                  color: CupertinoColors.destructiveRed,
                                  child: const Text('Close'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            )
                          : CupertinoButton(
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
        color: Theme.of(context).scaffoldBackgroundColor,
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
                        ? Text(businessListing.email)
                        : const SizedBox(),
                    Text(businessListing.address),

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

  //!methods
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> _makeEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }

  Future<void> _makeBooking() async {
    String str = 'https://hsolutions.app/h-book/user/virtualRanger';
    Uri url = Uri.parse(str);
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    } else {
      launchUrl(url);
    }
  }
}
