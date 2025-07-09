import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homekey_mobile/features/auth/model/user_model.dart';
import 'package:homekey_mobile/features/auth/provider/auth_provider.dart';
import 'package:homekey_mobile/features/property/model/property_model.dart';
import 'package:homekey_mobile/features/property/provider/property_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userPropertyControllerProvider.notifier).loadUserProperties();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;
    final userPropertiesAsync = ref.watch(userPropertyControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(context),
              _buildUserInfoSection(user),
              _buildContactDetailsSection(user),
              _buildMyPropertiesSection(userPropertiesAsync, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              child: Image.asset('assets/11.jpg', fit: BoxFit.cover),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Transform.translate(
            offset: Offset(0, -30),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 38,
                backgroundImage: AssetImage('assets/01.jpg'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoSection(UserModel? user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.name ?? 'Guest User',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user?.email ?? 'guest@example.com',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetailsSection(UserModel? user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contact Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          // if (user?.phoneNumber != null) ...[
          //   Row(
          //     children: [
          //       Icon(Icons.phone_outlined, size: 16, color: Colors.grey),
          //       SizedBox(width: 4),
          //       Text(
          //         user!.phoneNumber!,
          //         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          //       ),
          //     ],
          //   ),
          //   SizedBox(height: 8),
          // ],
          Row(
            children: [
              Icon(Icons.mail_outline, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                user?.email ?? 'guest@example.com',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyPropertiesSection(
    AsyncValue<List<Property>> userPropertiesAsync,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'My Properties',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.deepOrange),
                onPressed: () {
                  // showModalBottomSheet(
                  //   context: ref.context,
                  //   builder: (context) => AddPropertySheet(),
                  // );
                  ref
                      .read(userPropertyControllerProvider.notifier)
                      .loadUserProperties();
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          userPropertiesAsync.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error loading properties'),
            data: (properties) {
              if (properties.isEmpty) {
                return Center(
                  child: Text(
                    'No properties yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: properties.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  return _buildPropertyCard(properties[index], context, ref);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(
    Property property,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child:
                    property.images.isNotEmpty
                        ? Image.network(
                          property.images.first,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                        : Image.asset(
                          'assets/01.jpg',
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            property.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(Icons.star, size: 14, color: Colors.amber),
                        Text('4.5', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.grey),
                        SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            '${property.location.address ?? 'Unknown Location'}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        _infoChip('${property.area} m²'),
                        SizedBox(width: 4),
                        _infoChip('${property.bedroom} BD'),
                        SizedBox(width: 4),
                        _infoChip(property.type),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      '\$${property.price.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEF7D57),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () => _showDeleteDialog(context, property.id!, ref),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(6),
                child: Icon(Icons.delete_outline, size: 16, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    String propertyId,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Property'),
            content: Text('Are you sure you want to delete this property?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await ref
                        .read(userPropertyControllerProvider.notifier)
                        .deleteProperty(propertyId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Property deleted successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete property: $e')),
                    );
                  }
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  Widget _infoChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, color: Colors.grey[700]),
      ),
    );
  }
}
