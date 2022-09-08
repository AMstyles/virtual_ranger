import 'package:flutter/material.dart';
import 'package:virtual_ranger/pages/Custom/AnimeVals.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ranger/services/page_service.dart';
import '../business_listings.dart';
import '../faq_page.dart';
import '../guide_page.dart';
import '../kestrel_club_page.dart';
import '../news_and_deals_page.dart';
import '../profile_page.dart';
import '../rule_page.dart';
import '../settings_page.dart';
import '../sighting_list.dart';

class DrawerContainer extends StatelessWidget {
  DrawerContainer({Key? key}) : super(key: key);

  //pages
  final List<Widget> pages = [
    ProfilePage(),
    NewsAndDealsPage(),
    GuidePage(),
    Kestrel_club_page(),
    SightingslistPage(),
    FAQPage(),
    RulesPage(),
    BusinessListingsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Provider.of<Anime>(context).closeDrawer,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 4,
            blurRadius: 12,
          )
        ]),
        transform: Matrix4.translationValues(
            Provider.of<Anime>(context).xOffset,
            Provider.of<Anime>(context).yOffset,
            0)
          ..scale(Provider.of<Anime>(context).scaleFactor),
        child: AbsorbPointer(
          absorbing: Provider.of<Anime>(context).isOpen ? true : false,
          child: pages[Provider.of<PageProvider>(context).currentPageNum],
        ),
      ),
    );
  }
}
