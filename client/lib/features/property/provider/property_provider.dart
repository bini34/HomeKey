// features/property/provider/property_provider.dart
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/property_repository.dart';
import '../model/property_model.dart';

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  return PropertyRepository();
});

final propertiesProvider = FutureProvider<List<Property>>((ref) async {
  final repository = ref.read(propertyRepositoryProvider);
  return repository.getProperties();
});

final propertyControllerProvider =
    StateNotifierProvider<PropertyController, AsyncValue<List<Property>>>((
      ref,
    ) {
      final repository = ref.read(propertyRepositoryProvider);
      return PropertyController(repository, ref);
    });

final userPropertiesProvider = FutureProvider<List<Property>>((ref) async {
  final repository = ref.read(propertyRepositoryProvider);
  return repository.getUserProperties();
});

final userPropertyControllerProvider =
    StateNotifierProvider<UserPropertyController, AsyncValue<List<Property>>>((
      ref,
    ) {
      final repository = ref.read(propertyRepositoryProvider);
      return UserPropertyController(repository);
    });

class UserPropertyController extends StateNotifier<AsyncValue<List<Property>>> {
  final PropertyRepository _repository;

  UserPropertyController(this._repository) : super(const AsyncValue.loading()) {
    loadUserProperties();
  }

  Future<void> loadUserProperties() async {
    state = const AsyncValue.loading();
    try {
      final properties = await _repository.getUserProperties();
      state = AsyncValue.data(properties);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteProperty(String propertyId) async {
    try {
      // Optimistically remove the property from the list
      final currentState = state;
      if (currentState is AsyncData<List<Property>>) {
        final newList =
            currentState.value.where((p) => p.id != propertyId).toList();
        state = AsyncValue.data(newList);
      }

      await _repository.deleteProperty(propertyId);

      // Refresh the list to ensure consistency
      await loadUserProperties();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

class PropertyController extends StateNotifier<AsyncValue<List<Property>>> {
  final PropertyRepository _repository;
  final Ref _ref;

  PropertyController(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    loadProperties();
  }

  Future<void> loadProperties() async {
    state = const AsyncValue.loading();
    try {
      final properties = await _repository.getProperties();
      state = AsyncValue.data(properties);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createProperty(
    String title,
    String description,
    double price,
    String type,
    double area,
    Location location,
    int bedroom,
    String createdAt,
    List<String> nearbyActivities,
    List<String> amenities,
    File? selectedImageFile, // Optional image file for the property
  ) async {
    try {
      await _repository.createProperty(
        title,
        description,
        price,
        type,
        area,
        location,
        bedroom,
        createdAt,
        nearbyActivities,
        amenities,
        selectedImageFile!, // Convert DateTime to ISO 8601 string
      );
      // await loadProperties(); // Refresh the list
      _ref.read(userPropertyControllerProvider.notifier).loadUserProperties();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}
