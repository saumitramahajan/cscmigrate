import 'package:flutter/widgets.dart';
import 'package:mahindraCSC/z_repository/adminRepository.dart';

class AnnualDataProvider extends ChangeNotifier {
  AdminRepository adminRepository = AdminRepository();
  bool loading = false;
  String errorString = 'no error';
  List<Map<String, String>> listOfLocations = [];
  List<Map<String, String>> location = [];
  Map<String, String> locations = {};
  List<Map<String, dynamic>> listOfMonths = [];
  List<Map<String, dynamic>> listOfStatements = [];

  List<List<String>> rows = [];

  List<Map<String, String>> assessmentAnnualDataList = [];
  AnnualDataProvider() {
    getLocations();
  }

  Future<void> getAnnualDataAssessement() async {
    assessmentAnnualDataList = await adminRepository.getAssessmentAnnualData();
    loading = true;
    notifyListeners();
  }

  Future<void> getLocations() async {
    loading = true;
    notifyListeners();
    try {
      listOfLocations = await adminRepository.getLocation();

      loading = false;

      notifyListeners();
    } catch (e) {
      print('check error::' + e.toString() + '\n\n');

      loading = false;

      notifyListeners();
    }
  }

  Future<void> locationCsv() async {
    loading = true;
    notifyListeners();
    try {
      location = await adminRepository.locations();
      listOfStatements = await adminRepository.getStatements();

      rows = List.generate(listOfStatements.length, (index) {
        List<String> row = [];
        row.add(listOfStatements[index]['statement']);
        for (int i = 0; i < location.length; i++) {
          row.add(location[i]['parameter$index'] ?? 'NU');
        }

        return row;
      });

      List<String> sectors = List.generate(location.length, (index) {
        return location[index]['nameOfSector'];
      });

      sectors.insert(0, ' ');

      List<String> locas = List.generate(
          location.length, (index) => location[index]['location']);

      locas.insert(0, ' ');

      rows.insert(0, locas);
      rows.insert(0, sectors);
      loading = false;

      notifyListeners();
    } catch (e) {
      print('check error::' + e.toString() + '\n\n');

      loading = false;

      notifyListeners();
    }
  }

  Future<void> getMonth(String documentID, String name, String location) async {
    loading = true;
    notifyListeners();
    try {
      listOfMonths =
          await adminRepository.getMonths(documentID, name, location);

      loading = false;

      notifyListeners();
    } catch (e) {
      print('check error::' + e.toString() + '\n\n');
      errorString = errorString + e.toString();
      loading = false;

      notifyListeners();
    }
  }

  List<List<String>> getRows(int index) {
    List<List<String>> rows = [];
    rows.add(['Month', listOfMonths[index]['monthName'] ?? 'NA']);
    rows.add(['Name Of Sector', listOfMonths[index]['nameOfSector'] ?? 'NA']);
    rows.add(['Location', listOfMonths[index]['location'] ?? 'NA']);
    rows.add(['Man Power', listOfMonths[index]['manPower'] ?? 'NA']);
    rows.add(['Fatal', listOfMonths[index]['fatal'] ?? 'NA']);
    rows.add([
      'Reportable Accidents',
      listOfMonths[index]['reportableAccidents'] ?? 'NA'
    ]);
    rows.add([
      'Man Days Lost Due to Reportable Accidents',
      listOfMonths[index]['manDaysLost'] ?? 'NA'
    ]);
    rows.add([
      'Non Reportable Accidents',
      listOfMonths[index]['noReportableAccidents'] ?? 'NA'
    ]);
    rows.add([
      'Man Days Lost due to Non-Reportable Accidents',
      listOfMonths[index]['manDaysLostNra'] ?? 'NA'
    ]);
    rows.add([
      'First Aid Accidents',
      listOfMonths[index]['firstaidAccidents'] ?? 'NA'
    ]);
    rows.add(
        ['Total Accidents', listOfMonths[index]['totalAccidents'] ?? 'NA']);
    rows.add([
      'On Duty Road Accidents(Fatal)',
      listOfMonths[index]['fatalAccidents'] ?? 'NA'
    ]);
    rows.add([
      'On Duty Road Accidents(Serious)',
      listOfMonths[index]['seriousAccidents'] ?? 'NA'
    ]);

    rows.add([
      'Fire Incidents (Major)',
      listOfMonths[index]['fireIncident'] ?? 'NA'
    ]);
    rows.add([
      'Fire Incidents (Minor)',
      listOfMonths[index]['fireIncidentMinor'] ?? 'NA'
    ]);
    rows.add(['Kaizen/Poka-Yoke', listOfMonths[index]['kaizen'] ?? 'NA']);
    rows.add([
      'Identified UA/UC for month',
      listOfMonths[index]['identified'] ?? 'NA'
    ]);
    rows.add([
      'Safety Activity Rate',
      listOfMonths[index]['safetyActivityRate'] ?? 'NA'
    ]);
    rows.add(['Closure', listOfMonths[index]['closureOf'] ?? 'NA']);
    rows.add([
      'Theme Based Inspections',
      listOfMonths[index]['themeBasedInspections'] ?? 'NA'
    ]);

    rows.add([
      'Near Miss Incidents',
      listOfMonths[index]['nearMissIncident'] ?? 'NA'
    ]);

    return rows;
  }
}
