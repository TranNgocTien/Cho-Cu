import 'package:basic_utils/basic_utils.dart';
import 'package:chotot/data/get_job_item_data.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:getwidget/getwidget.dart';

class JobItemScreen extends StatelessWidget {
  const JobItemScreen({super.key, required this.nameService});
  final String nameService;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          nameService,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontFamily: GoogleFonts.montserrat().fontFamily,
              ),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: jobItemList.length,
          itemBuilder: (context, index) {
            final priceReverse = StringUtils.addCharAtPosition(
                StringUtils.reverse(jobItemList[index].price), ".", 3,
                repeat: true);
            return GFListTile(
                avatar: GFAvatar(
                  shape: GFAvatarShape.circle,
                  backgroundColor: const Color.fromARGB(128, 105, 240, 175),
                  child: Image.asset('image/automobile-with-wrench.png'),
                ),
                // titleText: vouchersValid[index].name,
                title: Text(jobItemList[index].name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith()),
                subTitle: Text('${StringUtils.reverse(priceReverse)} VNĐ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                          fontWeight: FontWeight.w900,
                        )),
                description: Text(jobItemList[index].description,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                        )),
                // icon: Icon(Icons.home, color: Colors.red),
                padding: EdgeInsets.zero,
                radius: 50,
                onTap: () {
                  Navigator.pop(context, jobItemList[index].name);
                }
                // title: Text('$dateTo-$dateFrom'),
                );
          },
        ),
      ),
    );
  }
}
