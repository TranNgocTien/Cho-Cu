import 'package:chotot/controllers/host_rate.dart';
// import 'package:chotot/controllers/worker_rate.dart';
import 'package:chotot/data/acceptorker_data.dart';
import 'package:chotot/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HostRateScreen extends StatefulWidget {
  const HostRateScreen({
    super.key,
    required this.profileImage,
    required this.workerName,
    required this.contractId,
    required this.jobId,
    required this.employeeId,
    required this.hostId,
  });
  final String workerName;
  final String profileImage;
  final String contractId;
  final String jobId;
  final String employeeId;
  final String hostId;
  @override
  State<HostRateScreen> createState() => _HostRateScreenState();
}

class _HostRateScreenState extends State<HostRateScreen> {
  HostRate hostRate = Get.put(HostRate());
  double rateD1 = 0;
  double rateD2 = 0;
  double rateD3 = 0;
  double rateD4 = 0;
  double rateD5 = 0;

  @override
  Widget build(BuildContext context) {
    dynamic imageProfile = widget.profileImage == ''
        ? const AssetImage('image/61568.jpg')
        : NetworkImage(widget.profileImage);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.green,
                child: CircleAvatar(
                  radius: 45.0,
                  backgroundColor: Colors.white,
                  backgroundImage: imageProfile,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(widget.workerName == ''
                  ? acceptWorkerData[0].employeeName
                  : widget.workerName),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Khả năng chuyên môn:',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                  ),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 0,
                    maxRating: 100,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 30,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      rateD1 = rating * 200 / 10;
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thái độ công việc:',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                  ),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 0,
                    maxRating: 100,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemSize: 30,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      rateD2 = rating * 200 / 10;
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Đến đúng giờ:',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                  ),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 0,
                    maxRating: 100,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemSize: 30,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      rateD3 = rating * 200 / 10;
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kỹ thuật/ kỹ năng:',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                  ),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 0,
                    maxRating: 100,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemSize: 30,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      rateD4 = rating * 200 / 10;
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mức độ hài lòng:',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                  ),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 0,
                    maxRating: 100,
                    itemSize: 30,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      rateD5 = rating * 200 / 10;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                  child: TextFormField(
                    controller: hostRate.contentController,
                    decoration: const InputDecoration(
                      hintText: 'Đánh giá chủ nhà ...',
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    autocorrect: false,
                    maxLines: 5,
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
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await hostRate.hostRate(
                      rateD1,
                      rateD2,
                      rateD3,
                      rateD4,
                      rateD5,
                      widget.contractId,
                      widget.jobId,
                      widget.employeeId,
                      widget.hostId,
                    );
                    Get.to(const MainScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Gửi đánh giá',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
