import 'package:chotot/controllers/login_controller.dart';

import 'package:chotot/data/ly_lich.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart';

class NapTienScreen extends StatefulWidget {
  const NapTienScreen({super.key});

  @override
  State<NapTienScreen> createState() => _NapTienScreenState();
}

class _NapTienScreenState extends State<NapTienScreen> {
  // NapTienController napTienController = Get.put(NapTienController());
  LoginController loginController = Get.put(LoginController());
  TextEditingController amountController = TextEditingController();

  TextEditingController orderInfoController = TextEditingController(text: '');
  var tempOrderInfo = '';

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Nạp Tiền',
              //     style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              //         fontFamily: GoogleFonts.rubik().fontFamily,
              //         color: Colors.black87)),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Số tiền cần nạp: ',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontFamily: GoogleFonts.rubik().fontFamily,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 185, 184, 184)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                  child: TextFormField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      hintText: '0',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (str) {
                      // var price = int.parse(str);
                      // var comma = NumberFormat('###,###,###,###');
                      // TextController.text =
                      //     comma.format(price).replaceAll(' ', '');
                      setState(() {
                        tempOrderInfo =
                            'Nap tien cho tai khoan ${lyLichInfo[0].phone}. So tien: ${amountController.text} VND';
                        orderInfoController.text = tempOrderInfo;
                      });
                    },
                    validator: (value) {
                      if (value == null ||
                          value.isNum ||
                          value.isEmpty ||
                          value.trim().length <= 1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('required!'),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Nội dung nạp tiền',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontFamily: GoogleFonts.rubik().fontFamily,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 185, 184, 184)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                  child: TextFormField(
                    controller: orderInfoController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: '...',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.streetAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.trim().length <= 1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('required!'),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    foregroundColor: const Color.fromRGBO(5, 109, 101, 1),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 112, 234, 101),
                    ),
                  ),
                  onPressed: () {
                    _launchUrl(Uri.parse(
                        'https://vstserver.com/services/get_vnpay_payment/${loginController.hostId}?token=anhkhongdoiqua&amount=${amountController.text}&order_info=${orderInfoController.text}'));
                  },
                  child: Text(
                    'Nạp tiền',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontFamily: GoogleFonts.rubik().fontFamily,
                          color: const Color.fromARGB(255, 112, 234, 101),
                          fontSize: 18,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
