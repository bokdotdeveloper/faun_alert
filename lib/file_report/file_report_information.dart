import 'dart:io';

import 'package:faun_alert/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FileReportInformation extends StatefulWidget {
  final String animalId;
  final String incidentType;
  final Map<String, dynamic> initialData;

  const FileReportInformation({
    Key? key,
    required this.animalId,
    required this.incidentType,
    required this.initialData,
  }) : super(key: key);

  @override
  State<FileReportInformation> createState() => _FileReportInformationState();
}

class _FileReportInformationState extends State<FileReportInformation> {
  late TextEditingController locationController;
  late TextEditingController contactNoController;
  late TextEditingController incidentDateController;
  late TextEditingController additionalInfoController;

  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  File? _imageFile;
  LatLng? _currentLatLng;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    locationController = TextEditingController();
    contactNoController = TextEditingController();
    incidentDateController = TextEditingController();
    additionalInfoController = TextEditingController();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    _currentLatLng = LatLng(position.latitude, position.longitude);

    // Reverse geocoding to get address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    String address = '';
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
    } else {
      address = '${position.latitude}, ${position.longitude}';
    }

    setState(() {
      locationController.text = address;
    });
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      incidentDateController.text = picked.toIso8601String().split('T').first;
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  // Replace with your Cloudinary upload preset and cloud name
  static const String cloudName = 'dyp7aay1y';
  static const String uploadPreset = 'ml_default';

  Future<String?> uploadImageToCloudinary(File image) async {
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );
    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    final resStr = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final resJson = jsonDecode(resStr);
      return resJson['secure_url'];
    } else {
      print('Cloudinary upload failed: ${response.statusCode}');
      print('Cloudinary response: $resStr');
      return null;
    }
  }

  Future add() async {
    if (locationController.text.isEmpty ||
        contactNoController.text.isEmpty ||
        incidentDateController.text.isEmpty ||
        additionalInfoController.text.isEmpty ||
        _currentLatLng == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }
    try {
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await uploadImageToCloudinary(_imageFile!);
        if (imageUrl == null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Image upload failed')));
          return;
        }
      }
      await addAnimalDetails(
        widget.animalId,
        locationController.text,
        imageUrl,
        _currentLatLng!.longitude.toString(),
        _currentLatLng!.latitude.toString(),
        contactNoController.text,
        incidentDateController.text,
        additionalInfoController.text,
        DateTime.now().toIso8601String(),
        userId ?? '',
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Report submitted')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  Future addAnimalDetails(
    String animal_id,
    String location,
    String? imageUrl,
    String longitude,
    String latitude,
    String contactNo,
    String incidentDate,
    String additionalInfo,
    String submittedAt,
    String uid,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('reports').doc().set({
        'animalId': animal_id,
        'location': location,
        'longitude': longitude,
        'latitude': latitude,
        'contact_no': contactNo,
        'incident_date': incidentDate,
        'additional_info': additionalInfo,
        'incident_type': widget.incidentType,
        'image_url': imageUrl,
        'submitted_at': DateTime.now(),
        'uid': uid,
        'status': 'pending',
      });
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actionsPadding: EdgeInsets.all(8),
        title: Text(
          'File Report Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Add notification logic here
              debugPrint(
                'Notification bell pressed',
              ); // Use debugPrint for logging
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: locationController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child:
                    _currentLatLng == null
                        ? const Center(child: CircularProgressIndicator())
                        : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: _currentLatLng!,
                            zoom: 16,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId('currentLocation'),
                              position: _currentLatLng!,
                            ),
                          },
                          onMapCreated: (controller) {
                            _mapController = controller;
                          },
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                        ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: contactNoController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: incidentDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Incident Date',
                    border: OutlineInputBorder(),
                  ),
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: additionalInfoController,
                  decoration: const InputDecoration(
                    labelText: 'Additional Info',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _imageFile != null
                        ? Image.file(_imageFile!, height: 120)
                        : const Text('No image selected'),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Pick/Take Image'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: add,
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Submit Report',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Inter Bold',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
