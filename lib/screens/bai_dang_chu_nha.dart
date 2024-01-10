import 'package:chotot/widgets/docu_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chotot/data/docu_data.dart';

import 'package:chotot/controllers/get_stuffs.dart';
// import 'package:chotot/screens/thongTinSanPham.dart';

class OwnerOrder extends StatefulWidget {
  const OwnerOrder({super.key});

  @override
  State<OwnerOrder> createState() => _OwnerOrderState();
}

class _OwnerOrderState extends State<OwnerOrder> {
  final GetStuffs _getStuffs = Get.put(GetStuffs());
  var currentIndex = 1;

  Widget center = const Center(
    child: CircularProgressIndicator(),
  );

  getData() async {
    itemsOwner.clear();
    await _getStuffs.getStuffs(currentIndex - 1);
    if (itemsOwner.isNotEmpty) {
      setState(() {});
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(
          child: Text(
            'Bài đã đăng',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(54, 92, 69, 1),
                ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(54, 92, 69, 1),
        elevation: 0,
      ),
      body: itemsOwner.isNotEmpty
          ? itemsOwner.isNotEmpty
              ? AlignedGridView.count(
                  shrinkWrap: true,
                  itemCount: itemsOwner.length,
                  physics: const ScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemBuilder: (context, index) {
                    return DoCuGridItem(
                      docu: itemsOwner[index],
                    );
                  },
                )
              : const Center(
                  child: Text('Không có sản phẩm'),
                )
          : center,
    );
  }
}
