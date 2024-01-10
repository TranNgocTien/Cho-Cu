// import 'package:chotot/screens/login.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

class TaiKhoanItem extends StatelessWidget {
  const TaiKhoanItem({
    super.key,
    required this.title,
    required this.image,
    this.screen,
    this.onTap,
  });
  final String title;
  final String image;
  final Widget? screen;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap == null
            ? screen != null
                ? Navigator.push(
                    context, MaterialPageRoute(builder: (ctx) => screen!))
                : showDialog(
                    context: Get.context!,
                    builder: (context) {
                      return const SimpleDialog(
                        contentPadding: EdgeInsets.all(20),
                        children: [
                          Text(
                            'no screen',
                          ),
                        ],
                      );
                    })
            : onTap!();
      },
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 5, top: 10, bottom: 5),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Image.asset(
                image,
                height: 35,
                width: 35,
              ),
            ),
            const SizedBox(width: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              padding: const EdgeInsets.only(top: 20, bottom: 15),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Color.fromRGBO(160, 160, 159, 0.906),
                  ),
                ),
              ),
              child: Text(title,
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                  textAlign: TextAlign.start),
            )
          ],
        ),
      ),
    );
  }
}
