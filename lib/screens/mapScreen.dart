import 'dart:async';
// import 'dart:ui' as ui;
import 'package:chotot/models/addressUpdate.dart';
import 'package:flutter/material.dart';
import 'package:chotot/models/place.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:location/location.dart' as local;

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location =
        const PlaceLocation(latitude: 16.0, longitude: 106.0, address: ''),
    required this.currentLocation,
    this.isSelecting = true,
  });
  final PlaceLocation currentLocation;
  final PlaceLocation location;
  final bool isSelecting;
  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  TextEditingController addressMap = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer();
  HawkFabMenuController hawkFabMenuController = HawkFabMenuController();
  // late Uint8List markerIcon;
  LatLng? _pickedLocation;
  final List<Marker> _markers = [];
  double? cameraPositionLat;
  double? cameraPositionLng;
  // Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
  //       targetWidth: width);
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
  //       .buffer
  //       .asUint8List();
  // }

  // void getMarkerIcon() async {
  //   markerIcon =
  //       await getBytesFromAsset('image/icon/thong_tin_review_1.png', 100);
  // }

  @override
  void initState() {
    // getMarkerIcon();

    _markers.add(
      Marker(
          markerId: const MarkerId('Current position'),
          position: LatLng(
            widget.currentLocation.latitude,
            widget.currentLocation.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(240)),
    );

    super.initState();
  }

  @override
  void dispose() {
    addressMap.dispose();

    super.dispose();
  }

  late LatLng currentLocationFromGet;
  Future<void> _getCurrentLocation() async {
    local.Location location = local.Location();

    bool serviceEnabled;
    local.PermissionStatus permissionGranted;
    local.LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      // await AwesomeDialog(
      //   context: Get.context!,
      //   dialogType: DialogType.warning,
      //   animType: AnimType.rightSlide,
      //   title: 'Vui lòng cho phép ứng dụng theo dõi để sử dụng tính năng này',
      //   // barrierColor: const Color.fromRGBO(38, 166, 83, 1),
      //   autoHide: const Duration(milliseconds: 800),
      //   titleTextStyle: GoogleFonts.poppins(),
      // ).show();

      // if (!serviceEnabled) {
      //   return;
      // }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == local.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != local.PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }

    LatLng currentLocal = LatLng(lat, lng);
    currentLocationFromGet = currentLocal;
    var indexCurentMarker = _markers.indexWhere(
        (marker) => marker.markerId == const MarkerId('Current position'));
    _pickedLocation = currentLocationFromGet;
    _markers.removeAt(indexCurentMarker);
    _markers.add(
      Marker(
          markerId: const MarkerId('Current position'),
          position: LatLng(
            currentLocationFromGet.latitude,
            currentLocationFromGet.longitude,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(240)),
    );
  }

  void moveToCurrentLocation() async {
    GoogleMapController controller = await _controller.future;
    await _getCurrentLocation();
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: currentLocationFromGet == null
          ? LatLng(
              widget.currentLocation.latitude, widget.currentLocation.longitude)
          : LatLng(currentLocationFromGet.latitude,
              currentLocationFromGet.longitude),
      zoom: 18,
    )));
    setState(() {
      _pickedLocation = currentLocationFromGet == null
          ? LatLng(
              widget.currentLocation.latitude,
              widget.currentLocation.longitude,
            )
          : LatLng(currentLocationFromGet.latitude,
              currentLocationFromGet.longitude);
    });
  }

  Future<void> _convertAddressToCoordinate(string) async {
    List<Location> location = await locationFromAddress(string);

    final lat = location.last.latitude;

    final lng = location.last.longitude;

    if (lat == null || lng == null) {
      return;
    }

    cameraPositionLat = lat;
    cameraPositionLng = lng;

    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(cameraPositionLat!, cameraPositionLng!),
      zoom: 18,
    )));

    _markers.add(
      Marker(
        markerId: const MarkerId('m1'),
        position: LatLng(
          cameraPositionLat!,
          cameraPositionLng!,
        ),
      ),
    );
    setState(() {
      _pickedLocation = LatLng(lat, lng);
    });
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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                if (_pickedLocation == null) {
                  _pickedLocation = LatLng(widget.currentLocation.latitude,
                      widget.currentLocation.longitude);
                }
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: const Icon(Icons.arrow_back)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            widget.isSelecting
                ? 'Thiết lập vị trí của bạn'
                : 'Địa điểm của bạn',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
          ),
          // actions: [
          //   if (widget.isSelecting)
          //     IconButton(
          //       onPressed: () {
          //         Navigator.of(context).pop(_pickedLocation);
          //       },
          //       icon: const Icon(Icons.save),
          //     ),
          // ],
        ),
        body: HawkFabMenu(
          icon: AnimatedIcons.menu_arrow,
          fabColor: Colors.white,
          iconColor: Colors.black,
          hawkFabMenuController: hawkFabMenuController,
          items: [
            HawkFabMenuItem(
              label: 'Vị trí hiện tại',
              ontap: () {
                moveToCurrentLocation();
                setState(() {});
                // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Menu 1 selected')),
                // );
              },
              icon: const Icon(Icons.location_city),
              color: Colors.red,
              labelColor: Colors.blue,
            ),
            HawkFabMenuItem(
              label: 'Lưu vị trí đã chọn',
              ontap: () {
                _pickedLocation ??= LatLng(widget.currentLocation.latitude,
                    widget.currentLocation.longitude);
                Navigator.of(context).pop(_pickedLocation);

                // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Menu 2 selected')),
                // );
              },
              icon: const Icon(Icons.location_on),
              labelColor: Colors.white,
              labelBackgroundColor: Colors.blue,
            ),
          ],
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: GoogleMap(
                    onTap: (position) {
                      setState(() {
                        _pickedLocation = position;

                        _markers.add(
                          Marker(
                              markerId: const MarkerId('m1'),
                              position: _pickedLocation!),
                        );
                      });
                    },
                    zoomControlsEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    myLocationButtonEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.currentLocation.latitude,
                          widget.currentLocation.longitude),
                      zoom: 18,
                    ),
                    markers: Set.of(_markers),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: 50,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TypeAheadField<AddressUpdate?>(
                      hideOnError: true,
                      debounceDuration: const Duration(milliseconds: 500),
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: addressMap,
                        decoration: const InputDecoration(
                          focusColor: Colors.white,
                          border: InputBorder.none,
                          hintText: 'Tìm kiếm',
                        ),
                      ),
                      suggestionsCallback:
                          AddressUpdateApi.getAddressSuggestions,
                      itemBuilder: (context, AddressUpdate? suggestion) {
                        final address = suggestion!;
                        return ListTile(
                          title: Text(address.description),
                        );
                      },
                      noItemsFoundBuilder: (context) => SizedBox(
                        height: 100,
                        child: Center(
                          child: Text(
                            'Không tìm thấy địa chỉ.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontSize: 18,
                                ),
                          ),
                        ),
                      ),
                      onSuggestionSelected: (AddressUpdate? suggestion) async {
                        final address = suggestion!;
                        addressMap.text = address.description;
                        await _convertAddressToCoordinate(address.description);

                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: IconButton(
                  onPressed: () {
                    hawkFabMenuController.toggleMenu();
                  },
                  icon: const Icon(Icons.replay_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
