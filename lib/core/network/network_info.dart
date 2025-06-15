import 'package:connectivity_plus/connectivity_plus.dart';

// Abstract interface for checking network connectivity, used in the data layer to ensure online operations.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// Implementation of NetworkInfo using the connectivity_plus package.
// Checks if the device is connected to the internet (Wi-Fi or mobile data).
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  // Constructor accepts Connectivity instance (injected via dependency injection).
  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    // Checks connectivity status; returns true if connected to any network.
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}