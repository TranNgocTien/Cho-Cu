import 'dart:async';

import 'package:basic_utils/basic_utils.dart';
import 'package:chotot/data/get_job_item_data.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:getwidget/getwidget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class JobItemScreen extends StatefulWidget {
  const JobItemScreen({super.key, required this.nameService});
  final String nameService;

  @override
  State<JobItemScreen> createState() => _JobItemScreenState();
}

class _JobItemScreenState extends State<JobItemScreen> {
  List image = [];
  List dienuoc = ['image/DICH VU DIEN-NUOC/KIEM TRA KHAC PHUC DIEN NUOC.png'];
  List maygiat = [
    'image/DICH VU MAY GIAT/1 VS CUA TREN.png',
    'image/DICH VU MAY GIAT/2 VS CUA TRUOC.png'
  ];
  List maylanh = [
    'image/DICH VU MAY LANH/1 VSML 1-1.5HP.png',
    'image/DICH VU MAY LANH/2 VSML 2-2.5HP.png',
    'image/DICH VU MAY LANH/3 VSML AM TRAN.png',
    'image/DICH VU MAY LANH/4 VSML TU DUNG.png',
    'image/DICH VU MAY LANH/5 VSML MULTI.png',
    'image/DICH VU MAY LANH/6 LAP DAT TREO TUONG (THAO NGUYEN BO).png',
    'image/DICH VU MAY LANH/7 LAP DAT TREO TUONG (LAP NGUYEN BO).png',
    'image/DICH VU MAY LANH/8 LAP DAT TREO TUONG(THAO VA LAP).png',
    'image/DICH VU MAY LANH/9 LAP DAT TREO TUONG (THAY DAN NONG.png',
    'image/DICH VU MAY LANH/10 LAP DAT TREO TUONG(THAY DAN LANH).png',
    'image/DICH VU MAY LANH/11 LAP DAT TU DUNG,AP TRAN, AM TRAN(THAO).png',
    'image/DICH VU MAY LANH/12 LAP DAT TU DUNG, AP TRAN, AM TRAN(LAP).png',
    'image/DICH VU MAY LANH/13 LAP DAT TU DUNG (THAO VA LAP).png',
    'image/DICH VU MAY LANH/14 LAP DAT TU DUNG,AP TRAN, AM TRAN(THAY DAN NONG).png',
    'image/DICH VU MAY LANH/15 LAP DAT TU DUNG,AM TRAN,AP TRAN(THAY DAN LANH).png',
    'image/DICH VU MAY LANH/16-20 SAC GAS.png',
    'image/DICH VU MAY LANH/16-20 SAC GAS.png',
    'image/DICH VU MAY LANH/16-20 SAC GAS.png',
    'image/DICH VU MAY LANH/16-20 SAC GAS.png',
    'image/DICH VU MAY LANH/16-20 SAC GAS.png',
  ];
  List quatmay = [
    'image/DICH VU QUAT MAY/1 VS QUAT DIEU HOA.png',
    'image/DICH VU QUAT MAY/2 VS QUAT KHO.png',
  ];
  List tulanh = [
    'image/DICH VU TU LANH/1 VS TU LANH THUONG.png',
    'image/DICH VU TU LANH/2 VS TU LANH 2 CANH.png',
    'image/DICH VU TU LANH/3 SUA CHUA TU LANH.png',
  ];
  List giadung = [
    'image/DV LAP DAT THIET BI GIA DUNG/LAP DAT THIET BI GIA DUNG.png',
  ];
  List maytinh = [
    'image/DV MAY TINH-IN/1 SUA CHUA MAY TINH.png',
    'image/DV MAY TINH-IN/2 BAO TRI MAY TINH.png',
    'image/DV MAY TINH-IN/3 BAO TRI MAY IN.png',
  ];

  List defaultList = [
    'image/automobile-with-wrench.png',
  ];
  chooseListImage(nameService) {
    switch (nameService) {
      case "Dịch vụ máy lạnh":
        return maylanh;
      case "Dịch vụ máy giặt":
        return maygiat;
      case "Dịch vụ quạt máy":
        return quatmay;
      case "Dịch vụ tủ lạnh":
        return tulanh;
      case "Dịch vụ sửa chữa điện – nước":
        return dienuoc;
      case "Dịch vụ lắp đặt thiết bị gia dụng":
        return giadung;
      case "Dịch vụ máy tính - máy in":
        return maytinh;
      default:
        return defaultList;
    }
  }

  var isLoading = false;
  @override
  void initState() {
    isLoading = true;
    image = chooseListImage(widget.nameService);
    Timer(const Duration(milliseconds: 2000), () async {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromRGBO(39, 166, 82, 1),
                Color.fromRGBO(1, 142, 33, 1),
                Color.fromRGBO(23, 162, 73, 1),
                Color.fromRGBO(84, 181, 111, 1),
              ],
            ),
          ),
        ),
        leading: Container(),
        title: Text(
          widget.nameService,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.white,
                fontSize: 20,
              ),
        ),
      ),
      body: SafeArea(
        child: isLoading == true
            ? Center(
                child: LoadingAnimationWidget.waveDots(
                  color: const Color.fromRGBO(1, 142, 33, 1),
                  size: 30,
                ),
              )
            : ListView.builder(
                itemCount: jobItemList.length,
                itemBuilder: (context, index) {
                  final priceReverse = StringUtils.addCharAtPosition(
                      StringUtils.reverse(jobItemList[index].price), ".", 3,
                      repeat: true);
                  return GFListTile(
                      avatar: GFAvatar(
                        shape: GFAvatarShape.circle,
                        backgroundColor:
                            const Color.fromARGB(255, 192, 244, 210),
                        child: jobItemList[index].img == '--'
                            ? Image.asset(
                                image[index],
                              )
                            : Image.network(
                                jobItemList[index].img,
                              ),
                      ),
                      // titleText: vouchersValid[index].name,
                      title: Text(jobItemList[index].name,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith()),
                      subTitle: Text('${StringUtils.reverse(priceReverse)} VNĐ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontWeight: FontWeight.w900,
                              )),
                      description: Text(jobItemList[index].description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              )),
                      // icon: Icon(Icons.home, color: Colors.red),
                      padding: EdgeInsets.zero,
                      radius: 50,
                      onTap: () {
                        Navigator.pop(context,
                            [jobItemList[index].id, jobItemList[index].name]);
                      }
                      // title: Text('$dateTo-$dateFrom'),
                      );
                },
              ),
      ),
    );
  }
}
