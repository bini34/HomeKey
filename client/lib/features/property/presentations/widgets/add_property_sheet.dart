import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homekey_mobile/features/property/model/property_model.dart';
import 'package:homekey_mobile/features/property/presentations/widgets/button.dart';
import 'package:homekey_mobile/features/property/provider/property_provider.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AddPropertySheet extends ConsumerStatefulWidget {
  @override
  _AddPropertySheetState createState() => _AddPropertySheetState();
}

class _AddPropertySheetState extends ConsumerState<AddPropertySheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _areaController = TextEditingController();
  final _bedroomController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedType = 'House';
  List<String> _selectedAmenities = [];
  List<String> _selectedActivities = [];
  File? _selectedImageFile;

  final List<String> _availableAmenities = [
    'WiFi',
    'Parking',
    'Air Conditioning',
    'Heating',
    'Washing Machine',
    'Dryer',
    'Pool',
    'Gym',
    'Elevator',
    'Security System',
    'Pet Friendly',
    'Balcony',
    'Garden',
    'Furnished',
    'Cable TV',
  ];

  final List<String> _availableNearbyActivities = [
    'Shopping',
    'Dining',
    'Parks',
    'Schools',
    'Hospitals',
    'Public Transport',
    'Entertainment',
    'Fitness Centers',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _bedroomController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _showAmenitiesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.all(20),
              // Make the sheet taller but not full screen
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Select Amenities',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _availableAmenities.length,
                      itemBuilder: (context, index) {
                        final amenity = _availableAmenities[index];
                        final isSelected = _selectedAmenities.contains(amenity);

                        return CheckboxListTile(
                          title: Text(amenity),
                          value: isSelected,
                          activeColor: Color(0xFFEF7D57),
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                if (!_selectedAmenities.contains(amenity)) {
                                  _selectedAmenities.add(amenity);
                                }
                              } else {
                                _selectedAmenities.remove(amenity);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Update the main state with selected amenities
                        // This is already done as we're modifying the same list
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEF7D57),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Done', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showActivitiesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.all(20),
              // Make the sheet taller but not full screen
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Select Nearby Activities',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _availableNearbyActivities.length,
                      itemBuilder: (context, index) {
                        final activity = _availableNearbyActivities[index];
                        final isSelected = _selectedActivities.contains(
                          activity,
                        );

                        return CheckboxListTile(
                          title: Text(activity),
                          value: isSelected,
                          activeColor: Color(0xFFEF7D57),
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                if (!_selectedActivities.contains(activity)) {
                                  _selectedActivities.add(activity);
                                }
                              } else {
                                _selectedActivities.remove(activity);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // Update the main state with selected amenities
                        // This is already done as we're modifying the same list
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEF7D57),
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Done', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showImagePickerModal() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });

      if (!mounted) return;
      await showDialog(
        context: context,
        builder:
            (context) => _ImagePreviewDialog(
              imageFile: _selectedImageFile!,
              onConfirm:
                  () => {
                    print("Image selected: ${_selectedImageFile!.path}"),
                    Navigator.of(context).pop(),
                  },
              onCancel: () {
                setState(() {
                  _selectedImageFile = null;
                });
                Navigator.of(context).pop();
              },
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This is the key change: wrap with Padding and use viewInsets
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Add New Property',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                appImageUploadButton(
                  onPressed: () {
                    _showImagePickerModal();
                    // Implement image upload functionality
                  },
                  labelText: 'Upload Property Image',
                  buttonText: 'Select Image',
                  icon: Icons.image,
                ),
                SizedBox(height: 16),
                // Amenities selector
                InkWell(
                  onTap: _showAmenitiesSheet,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amenities',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        _selectedAmenities.isEmpty
                            ? Text(
                              'Tap to select amenities',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            )
                            : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  _selectedAmenities
                                      .map(
                                        (amenity) => Chip(
                                          label: Text(
                                            amenity,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          backgroundColor: Color(
                                            0xFFEF7D57,
                                          ).withOpacity(0.2),
                                          labelStyle: TextStyle(
                                            color: Color(0xFFEF7D57),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Activities selector
                InkWell(
                  onTap: _showActivitiesSheet,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Near by Activities',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        _selectedActivities.isEmpty
                            ? Text(
                              'Tap to select near by activities',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 14,
                              ),
                            )
                            : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  _selectedActivities
                                      .map(
                                        (activity) => Chip(
                                          label: Text(
                                            activity,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          backgroundColor: Color(
                                            0xFFEF7D57,
                                          ).withOpacity(0.2),
                                          labelStyle: TextStyle(
                                            color: Color(0xFFEF7D57),
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'Property Type',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ['House', 'Flat', 'Villa', 'Studio']
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price (\$)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _areaController,
                  decoration: InputDecoration(
                    labelText: 'Area (sq.m)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an area';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _bedroomController,
                  decoration: InputDecoration(
                    labelText: 'Bedrooms',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter bedroom count';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEF7D57),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('Add Property', style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final property = Property(
        // authorId: '', // Will be set by server based on auth
        title: _titleController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        type: _selectedType,
        area: double.parse(_areaController.text),
        bedroom: int.parse(_bedroomController.text),
        location: Location(
          type: 'Point',
          coordinates: [0, 0], // You might want to get real coordinates
          address: _addressController.text,
        ),
        createdAt: DateTime.now(),
        amenities: _selectedAmenities, // Add the amenities to the property
      );

      print("hola hola ${_selectedAmenities}");

      try {
        await ref
            .read(propertyControllerProvider.notifier)
            .createProperty(
              _titleController.text,
              _descriptionController.text,
              double.parse(_priceController.text),
              _selectedType, // Ensure this is "Flat", "House", "Villa", or "Studio"
              double.parse(_areaController.text),
              Location(
                type: 'Point',
                coordinates: [
                  0.0,
                  0.0,
                ], // Replace with valid longitude/latitude if needed
                address: _addressController.text,
                description:
                    _descriptionController.text, // Optional, matches backend
              ),
              int.parse(_bedroomController.text),
              DateTime.now().toIso8601String(),
              _selectedActivities, // Pass nearby activities to the API call
              _selectedAmenities, // Pass amenities to the API call
              _selectedImageFile, // Pass the selected image file
              // amenities: _selectedAmenities, // Pass amenities to the API call
            );
        Navigator.pop(context);
      } catch (e) {
        print("Bonjour Error adding property: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add property')));
      }
    }
  }
}

class _ImagePreviewDialog extends StatelessWidget {
  final File imageFile;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _ImagePreviewDialog({
    required this.imageFile,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    // final localizations = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    //  color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    //  color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'select photo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Image Preview
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // color: AppColors.primaryColor.withOpacity(0.2),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  imageFile,
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onCancel,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Text(
                      'cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: AppColors.primaryColor,
                      backgroundColor: Color(0xFFEF7D57),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'set photo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
