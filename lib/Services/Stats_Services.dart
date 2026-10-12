import 'dart:convert';
import 'package:covid_19/Models/WorldStatsModel.dart';
import 'package:http/http.dart' as http;
import 'Utilities/App_Url.dart';

class StatsServices {
  Future<WorldStatsModel> fetchWorldStatsRecord() async {
    final response = await http.get(Uri.parse(AppUrl.worldStatsApi));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return WorldStatsModel.fromJson(data);
    } else {
      throw Exception('Error:${response.statusCode}');
    }
  }


  Future<List<dynamic>> countriesListApi() async {
    final response = await http.get(Uri.parse(AppUrl.countriesList));
    var data;
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Error:${response.statusCode}');
    }
  }
}