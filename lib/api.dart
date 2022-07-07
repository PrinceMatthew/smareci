import 'package:appwrite/appwrite.dart';
import 'package:smareci/config.dart';

class ApiClient {
  Client get _client {
    Client client = Client();

    client
        .setEndpoint(Config.endPoint)
        .setProject(Config.project);

    return client;
  }

  static Databases get database => Databases(_instance._client, databaseId: Config.databaseID);
  static Account get account => Account(_instance._client);

  static final ApiClient _instance = ApiClient._internal();
  ApiClient._internal();
  factory ApiClient() => _instance;
}