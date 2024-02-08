// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$restClientHash() => r'0ee58f1fd102b2016ed621885f1e8d52ed00da66';

/// See also [restClient].
@ProviderFor(restClient)
final restClientProvider = Provider<RestClient>.internal(
  restClient,
  name: r'restClientProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$restClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RestClientRef = ProviderRef<RestClient>;
String _$userRepositoryHash() => r'4a324f69804b6738f220b7c48b19aad627021894';

/// See also [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = Provider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserRepositoryRef = ProviderRef<UserRepository>;
String _$userLoginServiceHash() => r'62431221aac8e45888e74928ecf0b5836e72b999';

/// See also [userLoginService].
@ProviderFor(userLoginService)
final userLoginServiceProvider = Provider<UserLoginService>.internal(
  userLoginService,
  name: r'userLoginServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userLoginServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserLoginServiceRef = ProviderRef<UserLoginService>;
String _$getMeHash() => r'835de91f459d1216fe7813de1ce4ffa8c28975d4';

/// See also [getMe].
@ProviderFor(getMe)
final getMeProvider = FutureProvider<UserModel>.internal(
  getMe,
  name: r'getMeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getMeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetMeRef = FutureProviderRef<UserModel>;
String _$barberShopRepositoryHash() =>
    r'6d0002007739fdc670fde23fd8d3fb4050e2659b';

/// See also [barberShopRepository].
@ProviderFor(barberShopRepository)
final barberShopRepositoryProvider = Provider<BarbershopRepository>.internal(
  barberShopRepository,
  name: r'barberShopRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$barberShopRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BarberShopRepositoryRef = ProviderRef<BarbershopRepository>;
String _$getMyBarbershopHash() => r'c798de1f198881bea40f0d9a5b3c397b5f536d9d';

/// See also [getMyBarbershop].
@ProviderFor(getMyBarbershop)
final getMyBarbershopProvider = FutureProvider<BarbershopModel>.internal(
  getMyBarbershop,
  name: r'getMyBarbershopProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getMyBarbershopHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetMyBarbershopRef = FutureProviderRef<BarbershopModel>;
String _$loggoutHash() => r'dbfddbc45692d084eb9b5f51b7f25c0e1d0fd06d';

/// See also [loggout].
@ProviderFor(loggout)
final loggoutProvider = AutoDisposeFutureProvider<void>.internal(
  loggout,
  name: r'loggoutProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$loggoutHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LoggoutRef = AutoDisposeFutureProviderRef<void>;
String _$scheduleRepositoryHash() =>
    r'd8bb90e09ddffd4926259e9e2ec796a76739a37d';

/// See also [scheduleRepository].
@ProviderFor(scheduleRepository)
final scheduleRepositoryProvider =
    AutoDisposeProvider<ScheduleRepository>.internal(
  scheduleRepository,
  name: r'scheduleRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scheduleRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ScheduleRepositoryRef = AutoDisposeProviderRef<ScheduleRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
