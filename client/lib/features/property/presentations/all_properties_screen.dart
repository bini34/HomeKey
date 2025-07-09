import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homekey_mobile/features/property/model/property_model.dart';
import 'package:homekey_mobile/features/property/provider/property_provider.dart';
import 'package:homekey_mobile/screens/rent_now_screen.dart';

class AllPropertiesScreen extends ConsumerStatefulWidget {
  final String categoryTitle;
  final String? initialFilter;

  const AllPropertiesScreen({
    Key? key,
    required this.categoryTitle,
    this.initialFilter,
  }) : super(key: key);

  @override
  _AllPropertiesScreenState createState() => _AllPropertiesScreenState();
}

class _AllPropertiesScreenState extends ConsumerState<AllPropertiesScreen> {
  String _selectedFilter = "All";
  RangeValues _priceRange = RangeValues(0, 1000);
  List<String> _amenities = [];

  final List<String> filters = [
    "All",
    "House",
    "Condo",
    "Apartment",
    "Townhouse",
    "Villa",
  ];

  final List<String> amenitiesList = [
    "WiFi",
    "Pool",
    "Gym",
    "Parking",
    "Air Conditioning",
    "Kitchen",
    "Washer",
    "TV",
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter ?? "All";
  }

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(propertiesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Text(
          widget.categoryTitle,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: Colors.black),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: propertiesAsync.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error:
                  (error, stack) =>
                      Center(child: Text('Error loading properties: $error')),
              data: (properties) => _buildPropertyList(properties),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = filter == _selectedFilter;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFFEF7D57) : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPropertyList(List<Property> properties) {
    // Apply filters if needed
    List<Property> filteredProperties = properties;

    // if (_selectedFilter != "All") {
    //   filteredProperties =
    //       properties.where((property) {
    //         // This is a simple example - you would need to adjust based on your property model
    //         return property.type?.toLowerCase() ==
    //             _selectedFilter.toLowerCase();
    //       }).toList();
    // }

    if (_selectedFilter != "All") {
      filteredProperties =
          properties.where((property) {
            return property.type?.toLowerCase() ==
                _selectedFilter.toLowerCase();
          }).toList();
    }

    // Apply price filter
    filteredProperties =
        filteredProperties.where((property) {
          return property.price >= _priceRange.start &&
              property.price <= _priceRange.end;
        }).toList();

    // Apply amenities filter if any selected
    if (_amenities.isNotEmpty) {
      filteredProperties =
          filteredProperties.where((property) {
            // Assuming property has an amenities list
            // Adjust based on your actual property model
            List<String> propertyAmenities = property.amenities ?? [];
            return _amenities.any(
              (amenity) => propertyAmenities.contains(amenity),
            );
          }).toList();
    }

    if (filteredProperties.isEmpty) {
      return Center(
        child: Text(
          'No properties match your filters',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredProperties.length,
      itemBuilder: (context, index) {
        final property = filteredProperties[index];
        return _buildPropertyCard(property);
      },
    );
  }

  Widget _buildPropertyCard(Property property) {
    return GestureDetector(
      onTap: () {
        // Navigate to property details
        // Navigator.pushNamed(context, '/rent_now');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentNowScreen(propertyId: property.id!),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property image with rating badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child:
                        property.imageCover != null
                            ? Image.network(
                              property.imageCover!,
                              fit: BoxFit.cover,
                            )
                            : Center(
                              child: Icon(
                                Icons.home,
                                size: 50,
                                color: Colors.grey[400],
                              ),
                            ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          property.ratingAverage.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFEF7D57),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      property.type ?? 'Property',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.favorite_border,
                      color: Colors.grey[700],
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            // Property details
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${property.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF7D57),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey, size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location.address ?? 'Unknown location',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      _buildPropertyFeature(
                        Icons.aspect_ratio,
                        '${property.area.toStringAsFixed(0)} sqm',
                      ),
                      SizedBox(width: 16),
                      _buildPropertyFeature(
                        Icons.bed,
                        '${property.bedroom} bed',
                      ),
                      SizedBox(width: 16),
                      _buildPropertyFeature(
                        Icons.bathtub_outlined,
                        '1 bath', // Assuming 1 bath for simplicity
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 16),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder:
          (context) => StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding: EdgeInsets.all(24),
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              _priceRange = RangeValues(0, 1000);
                              _amenities = [];
                            });
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(color: Color(0xFFEF7D57)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Price Range
                    Text(
                      'Price Range',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${_priceRange.start.round()}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '\$${_priceRange.end.round()}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    RangeSlider(
                      values: _priceRange,
                      min: 0,
                      max: 1000,
                      divisions: 20,
                      activeColor: Color(0xFFEF7D57),
                      inactiveColor: Colors.grey[300],
                      labels: RangeLabels(
                        '\$${_priceRange.start.round()}',
                        '\$${_priceRange.end.round()}',
                      ),
                      onChanged: (values) {
                        setModalState(() {
                          _priceRange = values;
                        });
                      },
                    ),
                    SizedBox(height: 24),

                    // Amenities
                    Text(
                      'Amenities',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            amenitiesList.map((amenity) {
                              final isSelected = _amenities.contains(amenity);
                              return GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    if (isSelected) {
                                      _amenities.remove(amenity);
                                    } else {
                                      _amenities.add(amenity);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? Color(0xFFEF7D57)
                                            : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    amenity,
                                    style: TextStyle(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    // Apply button
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Apply the filters
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFEF7D57),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Apply Filters',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }
}
