// screens/rent_now_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homekey_mobile/features/chat/presentation/chat_screen.dart';
import 'package:homekey_mobile/features/chat/provider/chat_provider.dart';
import 'package:homekey_mobile/features/property/model/property_model.dart';
import 'package:homekey_mobile/features/property/provider/property_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RentNowScreen extends ConsumerWidget {
  final String propertyId;

  const RentNowScreen({Key? key, required this.propertyId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyAsync = ref.watch(propertiesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: propertyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (properties) {
              final property = properties.firstWhere(
                (p) => p.id == propertyId,
                // orElse: () => Property.empty(),
              );

              print("property: $property");

              // if (property.id.isEmpty) {
              //   return const Center(child: Text('Property not found'));
              // }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  _buildPropertyInfo(property),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDescription(property),
                          _buildAmenities(property),
                          _buildActivities(property),
                          //_buildPriceDetails(property),
                        ],
                      ),
                    ),
                  ),
                  _buildNextButton(context, property, ref),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Property Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 24),
      ],
    );
  }

  void _emailUs(BuildContext context, String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{'subject': ''}),
    );

    launchUrl(emailLaunchUri);
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  Widget _buildPropertyInfo(Property property) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              property.images.isNotEmpty
                  ? property.imageCover!
                  : 'https://via.placeholder.com/80',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/01.jpg', // Make sure this image exists in your assets
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      //  '${property.location?.city}, ${property.location.country}',
                      '${property.location.address ?? 'Unknown Location'}',
                      // '',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text('4.5', style: const TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildAmenityTag('${property.area} sqm'),
                    const SizedBox(width: 8),
                    _buildAmenityTag('${property.bedroom} Bedroom'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, color: Colors.black87),
      ),
    );
  }

  Widget _buildDescription(Property property) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 24.0, bottom: 8.0),
          child: Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          property.description,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildAmenities(Property property) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 24.0, bottom: 8.0),
          child: Text(
            'Amenities',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              property.amenities
                  .map((amenity) => _buildAmenityTag(amenity))
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildActivities(Property property) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24.0, bottom: 8.0),
          child: Text(
            'Near by Activities, ',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              property.nearbyActivities
                  .map((act) => _buildAmenityTag(act))
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildPriceDetails(Property property) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Price Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildPriceRow(
            'Monthly Rent',
            '\$${property.price.toStringAsFixed(2)}',
          ),
          _buildPriceRow('Security Deposit', '\$150'),
          _buildPriceRow('Utilities', '\$150'),
          const Divider(),
          _buildPriceRow(
            'Total (first month)',
            '\$${(property.price + 300).toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String price, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(
    BuildContext context,
    Property property,
    WidgetRef ref,
  ) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        // onPressed: () {
        //   // Navigate to checkout or payment screen
        //   _emailUs(context, property.author?.email ?? '');
        // },
        onPressed: () async {
          try {
            print('socket Creating chat for property: ${property.author?.id}');
            final chatController = ref.read(chatControllerProvider.notifier);
            //final currentUserId = ''; // Replace with actual user ID
            // final propertyOwnerId = ''; // Replace with property owner ID
            final chat = await chatController.createChat(
              property.author?.id ?? '',
              // propertyOwnerId,
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(chat: chat)),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to create chat: $e')),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF7D57),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          'Email ${property.author?.name} to Rent Now',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
