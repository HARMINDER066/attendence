import 'dart:io';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/user.dart' as userModel;
import '../repository/user_repository.dart' as userRepo;
import 'package:http/http.dart' as http;
class UploadRepository {

  userModel.User currentUser = userRepo.currentUser.value;

  Future<String> uploadImage(File file,String field) async {
    final String _apiToken = 'api_token=${currentUser.apiToken}';
    final String url = '${GlobalConfiguration().getValue('api_base_url')}uploads/store?$_apiToken';
    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['uuid'] = Uuid().generateV4()
      ..fields['field']=field
      ..files.add(await http.MultipartFile.fromPath(
          'file', file.path,));
    var response = await request.send();
    if (response.statusCode == 200){
      print('Uploaded!');
      print(Uri.parse(url));
      return request.fields['uuid'];
    } else{
      print('Failed!');
      return "";
    }
  }

  // Future<bool> deleteUploaded(String uuid) async {}

  // Future<bool> deleteAllUploaded(List<String> uuids) async {}

}
