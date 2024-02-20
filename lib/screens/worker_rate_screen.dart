import 'package:chotot/controllers/worker_rate.dart';
import 'package:chotot/data/acceptorker_data.dart';
import 'package:chotot/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkerRateScreen extends StatefulWidget {
  const WorkerRateScreen({super.key});

  @override
  State<WorkerRateScreen> createState() => _WorkerRateScreenState();
}

class _WorkerRateScreenState extends State<WorkerRateScreen> {
  WorkerRate workerRate = Get.put(WorkerRate());
  double rate = 0;
  @override
  Widget build(BuildContext context) {
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
              const CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.green,
                child: CircleAvatar(
                  radius: 45.0,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('image/61568.jpg'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(acceptWorkerData[0].hostName),
              const SizedBox(
                height: 10,
              ),
              RatingBar.builder(
                initialRating: 0,
                minRating: 0,
                maxRating: 100,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  rate = rating * 200 / 10;
                },
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
                    controller: workerRate.contentController,
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
                    await workerRate.workerRate(rate);
                    Get.to(const MainScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Gửi đánh giá',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontFamily: GoogleFonts.montserrat().fontFamily,
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
