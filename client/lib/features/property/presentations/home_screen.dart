// screens/home_screen.dart (update)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:homekey_mobile/features/chat/presentation/chat_list_screen.dart';
import 'package:homekey_mobile/features/property/model/property_model.dart';
import 'package:homekey_mobile/features/property/presentations/all_properties_screen.dart';
import 'package:homekey_mobile/features/property/provider/property_provider.dart';
import 'package:homekey_mobile/screens/rent_now_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/add_property_sheet.dart';
import '../../../screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),
    AllPropertiesScreen(categoryTitle: "New Properties"), // Updated this line
    // Center(child: Text('Messages')),
    ChatListScreen(), // Assuming you have a ChatListScreen
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPropertySheet(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFFEF7D57),
        shape: CircleBorder(),
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Container(
        height: 56, // Reduced from 60 to make it more compact
        padding: EdgeInsets.only(bottom: 4), // Optional: Adjust text position
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      color:
                          _selectedIndex == 0 ? Color(0xFFEF7D57) : Colors.grey,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            _selectedIndex == 0
                                ? Color(0xFFEF7D57)
                                : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.new_releases_outlined,
                      color:
                          _selectedIndex == 1 ? Color(0xFFEF7D57) : Colors.grey,
                    ),
                    Text(
                      'New',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            _selectedIndex == 1
                                ? Color(0xFFEF7D57)
                                : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: SizedBox()), // Space for FAB
            Expanded(
              child: InkWell(
                onTap: () {
                  // void _emailUs(BuildContext context) async {
                  //   final Uri emailLaunchUri = Uri(
                  //     scheme: 'mailto',
                  //     path: "homekey@gmail.com",
                  //   );

                  //   launchUrl(emailLaunchUri);
                  // }

                  // _emailUs(context);

                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.message_outlined,
                      color:
                          _selectedIndex == 2 ? Color(0xFFEF7D57) : Colors.grey,
                    ),
                    Text(
                      'Messages',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            _selectedIndex == 2
                                ? Color(0xFFEF7D57)
                                : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 3;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      color:
                          _selectedIndex == 3 ? Color(0xFFEF7D57) : Colors.grey,
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            _selectedIndex == 3
                                ? Color(0xFFEF7D57)
                                : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPropertySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.85,
            child: AddPropertySheet(),
          ),
    );
  }
}

class HomeContent extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeContent> createState() => _HomeContentState();
}

// Extract the home content to a separate widget
class _HomeContentState extends ConsumerState<HomeContent> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(propertyControllerProvider.notifier).loadProperties();
    });
  }

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(propertiesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Categories',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       _buildCategoryIcons(),
      //       _buildSection('Newly Added', true, context),
      //       _buildPropertyList(context, propertiesAsync),
      //       _buildSection('Best Offers', true, context),
      //       _buildPropertyList(context, propertiesAsync),
      //     ],
      //   ),
      // ),
      body: RefreshIndicator(
        onRefresh: () async {
          // This will trigger a refresh of the properties
          // await ref.refresh(propertiesProvider.future);
          // Also refresh the property controller if needed
          // ref.read(propertyControllerProvider.notifier).loadProperties();
          await ref.refresh(propertiesProvider.future);

          // Option 2: Or use the controller
          // await ref.read(propertyControllerProvider.notifier).loadProperties();

          // You can also show a snackbar on success if you want
          // ScaffoldMessenger.of(
          //   context,
          // ).showSnackBar(SnackBar(content: Text('Properties refreshed')));
        },
        child: SingleChildScrollView(
          physics:
              AlwaysScrollableScrollPhysics(), // Required for RefreshIndicator
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryIcons(context),
              _buildSection('Newly Added', true, context),
              _buildPropertyList(context, propertiesAsync),
              _buildSection('Best Offers', true, context),
              _buildPropertyList(context, propertiesAsync),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildCategoryIcons() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 16),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         _buildCategoryItem(Icons.home, 'House'),
  //         _buildCategoryItem(Icons.apartment, 'Condos'),
  //         _buildCategoryItem(Icons.business, 'Apartment'),
  //         _buildCategoryItem(Icons.house_siding, 'Townhouses'),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildCategoryIcons(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {"icon": Icons.home, "label": "Flat", "type": "Flat"},
      {"icon": Icons.house, "label": "House", "type": "House"},
      {"icon": Icons.villa, "label": "Villa", "type": "Villa"},
      {"icon": Icons.apartment, "label": "Studio", "type": "Studio"},
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            categories.map((category) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => AllPropertiesScreen(
                            categoryTitle: category["label"]!,
                            initialFilter: category["type"]!,
                          ),
                    ),
                  );
                },
                child: _buildCategoryItem(
                  category["icon"] as IconData,
                  category["label"]!,
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: Color(0xFFEF7D57), size: 30),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildSection(String title, bool showSeeAll, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (showSeeAll)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AllPropertiesScreen(categoryTitle: title),
                  ),
                );
              },
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFEF7D57),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPropertyList(
    BuildContext context,
    AsyncValue<List<Property>> propertiesAsync,
  ) {
    return propertiesAsync.when(
      loading:
          () => Container(
            height: 280,
            child: Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, stack) => Container(
            height: 280,
            child: Center(child: Text('Error loading properties')),
          ),
      data: (properties) {
        return Container(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return _buildPropertyCard(
                property.title,
                property.ratingAverage.toString(),
                property.price.toStringAsFixed(0),
                property.location.address ?? 'Unknown location',
                property.area.toStringAsFixed(0),
                property.bedroom.toString(),
                '1', // Assuming 1 bath for simplicity
                context,
                property,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPropertyCard(
    String title,
    String rating,
    String price,
    String location,
    String sqm,
    String bed,
    String bath,
    BuildContext context,
    Property property,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/rent_now')
        // ;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RentNowScreen(propertyId: property.id!),
          ),
        );
        // Navigate to property details
        // Navigator.pushNamed(context, '/property_details', arguments: property);
      },
      child: Container(
        width: 220,
        margin: EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 160,
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
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 2),
                        Text(
                          rating,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey, size: 14),
                SizedBox(width: 2),
                Text(
                  location,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$sqm sq.m',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$bed bd',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$bath ba',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$$price',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF7D57),
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
