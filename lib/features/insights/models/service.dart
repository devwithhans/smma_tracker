import 'package:agency_time/features/client/data_processing/get_mrr.dart';

class ServiceData {
  String serviceId;
  String title;
  double mrr;
  Duration duration;
  double hourlyRate;
  List<ServiceEmployee> employees;
  Map tags;
  ServiceData({
    required this.serviceId,
    required this.title,
    required this.mrr,
    required this.employees,
    required this.duration,
    required this.hourlyRate,
    required this.tags,
  });
  static List<ServiceData> getService(
      {required Fee fee, required Map services}) {
    List<ServiceData> servicesResult = [];
    fee.services.forEach((key, value) {
      Map service = services[key] ?? {};
      Duration duration = Duration(seconds: service['duration'] ?? 0);
      double hourlyRate = (value.mrr / (duration.inSeconds / 3600));

      servicesResult.add(ServiceData(
        serviceId: key,
        title: 'Integrate title',
        mrr: value.mrr,
        employees: [],
        duration: duration,
        hourlyRate: hourlyRate,
        tags: service['tags'] ?? {},
      ));
    });

    return servicesResult;
  }
}

class ServiceEmployee {
  double procentage;
  double revenue;
  Duration duration;
  double hourlyRate;
  Map tags;

  ServiceEmployee({
    required this.procentage,
    required this.revenue,
    required this.duration,
    required this.hourlyRate,
    required this.tags,
  });
}
