import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RaoBanScreen extends StatefulWidget {
  const RaoBanScreen({super.key});

  @override
  State<RaoBanScreen> createState() => _RaoBanScreenState();
}

class _RaoBanScreenState extends State<RaoBanScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredAddress = '';
  var _enteredPhoneNumber = '';
  var _enteredDescription = '';
  var _enteredPrice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rao bán',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontFamily: GoogleFonts.rubik().fontFamily,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(54, 92, 69, 1),
              ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(54, 92, 69, 1),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Địa chỉ của bạn: ',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontFamily: GoogleFonts.rubik().fontFamily,
                        color: const Color.fromRGBO(5, 109, 101, 1),
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
                      decoration: const InputDecoration(
                        hintText: 'Địa chỉ',
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
                              content: Text('Address input is required!'),
                            ),
                          );
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredAddress = value!;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Số điện thoại liên hệ:',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontFamily: GoogleFonts.rubik().fontFamily,
                        color: const Color.fromRGBO(5, 109, 101, 1),
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
                      decoration: const InputDecoration(
                        hintText: 'Số điện thoại của bạn! (Bắt buộc)',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.phone,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Phone input is required!'),
                            ),
                          );
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredPhoneNumber = value!;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Mô tả:',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontFamily: GoogleFonts.rubik().fontFamily,
                        color: const Color.fromRGBO(5, 109, 101, 1),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: const Color.fromARGB(255, 185, 184, 184)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Viết vài dòng mô tả sản phẩm ...',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.multiline,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length <= 1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Phone input is required!'),
                            ),
                          );
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredDescription = value!;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Giá mong muốn: (VNĐ)',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontFamily: GoogleFonts.rubik().fontFamily,
                        color: const Color.fromRGBO(5, 109, 101, 1),
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
                      decoration: const InputDecoration(
                        hintText: '0',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.parse(value.trim()) <= 1000) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Price must be higher!'),
                            ),
                          );
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredPrice = int.parse(value!);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(5, 109, 101, 1),
                          foregroundColor: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            'Thêm Ảnh Chụp',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.rubik().fontFamily,
                                ),
                          ),
                        ),
                      ),
                      Text(
                        'Hình ảnh : 0/3',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: const Color.fromRGBO(5, 109, 101, 1),
                              fontFamily: GoogleFonts.rubik().fontFamily,
                            ),
                      ),
                    ]),
                const SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(5, 109, 101, 1),
                          foregroundColor: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            'Dịch vụ đăng tin',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(
                                  color: Colors.white,
                                  fontFamily: GoogleFonts.rubik().fontFamily,
                                ),
                          ),
                        ),
                      ),
                      Text(
                        'Chọn dịch vụ đăng tin',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: const Color.fromRGBO(5, 109, 101, 1),
                              fontFamily: GoogleFonts.rubik().fontFamily,
                            ),
                      ),
                    ]),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Phí đăng:',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: const Color.fromRGBO(5, 109, 101, 1),
                              fontFamily: GoogleFonts.rubik().fontFamily,
                            ),
                      ),
                      Text(
                        '0 GP',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: const Color.fromRGBO(5, 109, 101, 1),
                              fontFamily: GoogleFonts.rubik().fontFamily,
                            ),
                      ),
                    ]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.075),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(5, 109, 101, 1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 8),
                      child: Text(
                        'Đăng tin',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Colors.white,
                              fontFamily: GoogleFonts.rubik().fontFamily,
                              fontSize: 20,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
