import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/BL.dart';
import '../models/constants.dart';
import '../services/page_service.dart';
import '../services/shared_preferences.dart';

class BusinessListingWidg extends StatelessWidget {
  BusinessListingWidg({Key? key, required this.businessListing})
      : super(key: key);
  BusinessListing businessListing;

  @override
  Widget build(BuildContext context) {
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          businessListing.name,
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                      businessListing.firstNumber != ''
                          ? ListTile(
                              onTap: () {
                                _makePhoneCall(businessListing.firstNumber);
                              },
                              iconColor: Colors.blue,
                              leading: const Icon(Icons.phone),
                              title: Text(
                                businessListing.firstNumber,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : const SizedBox(),
                      businessListing.secondNumber != ''
                          ? ListTile(
                              onTap: () {
                                _makePhoneCall(businessListing.secondNumber);
                              },
                              iconColor: Colors.blue,
                              leading: const Icon(Icons.phone),
                              title: Text(
                                businessListing.secondNumber,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ))
                          : const SizedBox(),
                      businessListing.email != ''
                          ? ListTile(
                              onTap: () {
                                _makeEmail(businessListing.email);
                              },
                              iconColor: Colors.green,
                              leading: const Icon(
                                Icons.email,
                              ),
                              title: Text(
                                businessListing.email,
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ))
                          : const SizedBox(),
                      (businessListing.bookLink != null)
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
            Provider.of<UserProvider>(context).isOffLine ?? false
                ? Image.file(
                    File('${UserData.path}/images/${businessListing.logo}'),
                    fit: BoxFit.contain,
                    height: 60,
                    width: 60,
                  )
                : CachedNetworkImage(
                    imageUrl:
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
                      "${businessListing.firstNumber}   ,   ${businessListing.secondNumber}",
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    (businessListing.email != '')
                        ? Text(
                            businessListing.email,
                            style: TextStyle(color: Colors.green.shade800),
                          )
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
}
