// // features/chat/service/socket_service.dart
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SocketService {
//   late IO.Socket socket;

//   void connect(String userId) {
//     socket = IO.io(
//       'http://10.119.27.17:8800',
//       IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .enableAutoConnect()
//           .build(),
//     );

//     socket.onConnect((_) {
//       print('Socket connected');
//       socket.emit('new-user-add', userId);
//     });

//     socket.onDisconnect((_) => print('Socket disconnected'));
//   }

//   void sendMessage(Map<String, dynamic> message) {
//     socket.emit('send-message', message);
//   }

//   void listenForMessages(Function(Map<String, dynamic>) onMessageReceived) {
//     socket.on('receive-message', (data) => onMessageReceived(data));
//   }

//   void disconnect() {
//     socket.disconnect();
//   }
// }

// features/chat/service/socket_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  String? _currentUserId;
  bool _isInitialized = false;

  bool get isConnected => _socket?.connected ?? false;

  void initialize(String userId) {
    if (_isInitialized && _currentUserId == userId && isConnected) {
      print('Socket already connected for user: $userId');
      return;
    }

    _currentUserId = userId;

    // Disconnect existing socket if there is one
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
    }

    _socket = IO.io(
      'http://10.119.27.17:8800',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      print('Socket connected for user: $userId');
      _socket!.emit('new-user-add', userId);
    });

    _socket!.onDisconnect((_) => print('Socket disconnected'));

    _isInitialized = true;
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_socket != null && isConnected) {
      _socket!.emit('send-message', message);
    } else {
      print('Cannot send message: Socket not connected');
      // Try to reconnect
      if (_currentUserId != null) {
        initialize(_currentUserId!);
      }
    }
  }

  void listenForMessages(Function(Map<String, dynamic>) onMessageReceived) {
    if (_socket != null) {
      // Remove existing listeners to prevent duplicates
      _socket!.off('receive-message');
      _socket!.on('receive-message', (data) => onMessageReceived(data));
    }
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
    }
  }

  void dispose() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
    _isInitialized = false;
    _currentUserId = null;
  }
}
