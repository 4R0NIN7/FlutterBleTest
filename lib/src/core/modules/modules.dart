import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';
import 'package:uber_app_flutter/src/data/datasources/api/api_client.dart';
import 'package:uber_app_flutter/src/data/repository/device_details_repository_impl.dart';
import 'package:uber_app_flutter/src/data/repository/scanning_repository_impl.dart';
import 'package:uber_app_flutter/src/domain/repositories/scanning_repository.dart';
import 'package:uber_app_flutter/src/domain/usecases/connect_to_device_usecase.dart';
import 'package:uber_app_flutter/src/domain/usecases/get_characteristics_per_day_usecase.dart';
import 'package:uber_app_flutter/src/domain/usecases/get_count_not_synchronized_readings_usecase.dart';
import 'package:uber_app_flutter/src/domain/usecases/get_last_reading_usecase.dart';
import 'package:uber_app_flutter/src/domain/usecases/get_readings_by_day_usecase.dart';
import 'package:uber_app_flutter/src/domain/usecases/read_data_usecase.dart';
import 'package:uber_app_flutter/src/domain/usecases/send_data_usecase.dart';
import 'package:uber_app_flutter/src/domain/usecases/set_date_usecase.dart';

import '../../data/datasources/localsource/database/database.dart';
import '../../domain/repositories/device_details_repository.dart';
import '../../domain/usecases/scan_devices_usecase.dart';
import '../../presentation/feature/deviceDetails/controller/device_details_controller.dart';
import '../../presentation/feature/scanner/controller/scanner_controller.dart';
import '../util/dateManagement/time_manager.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() async {
    _setDependencies();
    _setRepositories();
    _setUseCases();
    _setScanningController();
    _setDeviceDetailsController();
  }

  _setDeviceDetailsController() {
    final connectToDeviceUseCase = Get.find<ConnectToDeviceUseCase>();
    final setDateUseCase = Get.find<SetDateUseCase>();
    final getLastReadingUseCase = Get.find<GetLastReadingUseCase>();
    final getCountNotSynchronizedUseCase =
        Get.find<GetCountNotSynchronizedUseCase>();
    final readDataUseCase = Get.find<ReadDataUseCase>();
    final sendDataUseCase = Get.find<SendDataUseCase>();
    final getCharacteristicsPerDay = Get.find<GetCharacteristicsPerDay>();
    final getReadingsByDayUseCase = Get.find<GetReadingsByDayUseCase>();
    Get.lazyPut<DeviceDetailsController>(() => DeviceDetailsController(
        connectToDeviceUseCase: connectToDeviceUseCase,
        setDateUseCase: setDateUseCase,
        readDataUseCase: readDataUseCase,
        getLastReadingUseCase: getLastReadingUseCase,
        getCountNotSynchronizedUseCase: getCountNotSynchronizedUseCase,
        sendDataUseCase: sendDataUseCase,
        getCharacteristicsPerDay: getCharacteristicsPerDay,
        getReadingsByDayUseCase: getReadingsByDayUseCase));
  }

  _setRepositories() {
    Get.lazyPut<ScanningRepository>(() => ScanningRepositoryImpl());
    Get.lazyPut<DeviceDetailsRepository>(() => DeviceDetailsRepositoryImpl());
  }

  _setScanningController() {
    final scanDevicesUseCase = Get.find<StartScanningDevicesUseCase>();
    Get.lazyPut<ScannerController>(
        () => ScannerController(scanDevicesUseCase: scanDevicesUseCase));
  }

  _setUseCases() {
    final scanningRepository = Get.find<ScanningRepository>();
    final deviceDetailsRepository = Get.find<DeviceDetailsRepository>();
    Get.lazyPut<StartScanningDevicesUseCase>(
        () => StartScanningDevicesUseCase(scanningRepository));
    Get.lazyPut<ConnectToDeviceUseCase>(
        () => ConnectToDeviceUseCase(deviceDetailsRepository));
    Get.lazyPut<GetCharacteristicsPerDay>(
        () => GetCharacteristicsPerDay(deviceDetailsRepository));
    Get.lazyPut<ReadDataUseCase>(
        () => ReadDataUseCase(deviceDetailsRepository));
    Get.lazyPut<SendDataUseCase>(
        () => SendDataUseCase(deviceDetailsRepository));
    Get.lazyPut<SetDateUseCase>(() => SetDateUseCase(deviceDetailsRepository));
    Get.lazyPut<GetCountNotSynchronizedUseCase>(
        () => GetCountNotSynchronizedUseCase(deviceDetailsRepository));
    Get.lazyPut<GetLastReadingUseCase>(
        () => GetLastReadingUseCase(deviceDetailsRepository));
    Get.lazyPut<GetReadingsByDayUseCase>(
        () => GetReadingsByDayUseCase(deviceDetailsRepository));
  }

  _setDependencies() {
    Get.lazyPut<FlutterReactiveBle>(() => FlutterReactiveBle(),
        tag: 'BleClient');
    Get.lazyPut<ApiClient>(() => FakeApiClient());
    Get.lazyPut<MyDatabase>(() => MyDatabase());
    Get.lazyPut<TimeManager>(() => TimeManager());
  }
}
