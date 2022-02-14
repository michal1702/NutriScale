import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_app/api/api_connector.dart';

class SpoonacularApi extends ApiConnector {
  SpoonacularApi()
      : super(dotenv.env['SPOONACULAR_BASE_URL']!,
            dotenv.env['SPOONACULAR_API_KEY']!);

  @override
  Map<String, String> buildHeaders() {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    return headers;
  }

  Map<String, String> buildProductListParams(String query) {
    Map<String, String> parameters = {
      'query': query,
      'number': '10',
      'apiKey': apiKey
    };
    return parameters;
  }

  Map<String, String> buildProductParams() {
    Map<String, String> parameters = {
      'amount': '1',
      'unit': 'grams',
      'apiKey': apiKey
    };
    return parameters;
  }

  Map<String, String> buildRecipeParams(int maxCalories) {
    Map<String, String> parameters = {
      'apiKey': apiKey,
      'number': '10',
      'random': true.toString(),
      'maxCalories': maxCalories.toString(),
    };
    return parameters;
  }

  Map<String, String> buildRecipeInformationParams() {
    Map<String, String> parameters = {
      'apiKey': apiKey
    };
    return parameters;
  }

  Map<String, String> buildRecipeStepsParams() {
    Map<String, String> parameters = {
      'apiKey': apiKey,
      'stepBreakdown': true.toString()
    };
    return parameters;
  }
}
