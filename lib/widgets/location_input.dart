import 'dart:convert';
// import 'package:geocoding/geocoding.dart';
import 'package:chotot/screens/mapScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:chotot/models/place.dart';
import 'package:chotot/controllers/update_info.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.onSelectLocation,
    required this.pickedLocationAdress,
    this.state,
  });
  final void Function(PlaceLocation location) onSelectLocation;
  final PlaceLocation? pickedLocationAdress;
  final String? state;
  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  PlaceLocation? _currentLocation;
  var _isGettingLocation = false;
  UpdateInfoController updateInfoController = Get.put(UpdateInfoController());
  String get locationImage {
    _pickedLocation = widget.pickedLocationAdress ?? _pickedLocation;
    if (_pickedLocation == null) {
      return '';
    }

    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:S%7C$lat,$lng&key=AIzaSyBVR432H7VtiC45UpByhbYM1J_tBlJvnes';
  }

  Future<void> _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://rsapi.goong.io/Geocode?latlng=$latitude,$latitude&api_key=WOXLNGkieaqVH3DPxcDpJoInSLk7QQajAHdzmyhB');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];
    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: latitude,
        longitude: longitude,
        address: address,
      );
      _isGettingLocation = false;
    });
    _convertCoordinatefromAddress(
        _pickedLocation!.latitude, _pickedLocation!.longitude);
    widget.onSelectLocation(_pickedLocation!);
    setState(() {});
  }

  Future<void> _convertCoordinatefromAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://rsapi.goong.io/Geocode?latlng=$lat,$lng&api_key=WOXLNGkieaqVH3DPxcDpJoInSLk7QQajAHdzmyhB');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address = resData['results'][0]['formatted_address'];
    setState(() {
      updateInfoController.addressController.text = address;
    });
  }

  Future<void> _getCurrentLocation(String? state) async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;
    if (lat == null || lng == null) {
      return;
    }
    if (state == 'capnhat') {
      updateInfoController.lat = lat;
      updateInfoController.lng = lng;
    }
    _currentLocation =
        PlaceLocation(latitude: lat, longitude: lng, address: '');

    // _savePlace(lat, lng);
    setState(() {});
  }

  void _selectOnMap(String? state, PlaceLocation currentLocation) async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(currentLocation: currentLocation),
      ),
    );

    if (pickedLocation == null) {
      return;
    }
    if (state == 'capnhat') {
      updateInfoController.lat = pickedLocation.latitude;
      updateInfoController.lng = pickedLocation.longitude;
    }

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  void initState() {
    // TODO: implement initState
    _pickedLocation = widget.pickedLocationAdress;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'Chưa có địa điểm',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
            fontFamily: GoogleFonts.rubik().fontFamily,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
    );
    if (_pickedLocation != null || widget.pickedLocationAdress != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // TextButton.icon(
            //   onPressed: () {
            //     _getCurrentLocation(widget.state);
            //   },
            //   icon: const Icon(Icons.location_on),
            //   label: const Text('Lấy tọa độ thiết bị'),
            // ),
            TextButton.icon(
              onPressed: () async {
                await _getCurrentLocation('');
                _selectOnMap(widget.state, _currentLocation!);
              },
              icon: const Icon(Icons.map),
              label: const Text('Chọn trên bản đồ'),
            ),
          ],
        ),
      ],
    );
  }
}
