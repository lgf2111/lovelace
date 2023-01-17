import 'dart:convert';
import 'package:lovelace/models/user_detail.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/session.dart';

StorageMethods storageMethods = StorageMethods();
Session session = Session();

class AccountMethods {
  Future<List> read() async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;

    try {
      output = await session.get('/account/profile');
      try {
        dynamic outputJson = json.decode(output);

        if (outputJson['read'] == true) {
          isSuccess = true;
          message = "Read successful";
        } else {
          message = outputJson['response'];
        }
      } catch (e) {
        message = "An error occurred";
      }
    } catch (e) {
      output = e.toString();
    }

    print(output);

    return [output, message, isSuccess];
  }

  Future<List> update({required UserDetails userDetails}) async {
    Map<String, String> outputJson = {};
    String output = "";
    String message = "";
    bool isSuccess = true;
    List updateDetailsList;
    List updateProfilePicList;
    List updateDisplayPicList;
    // List<Map<String, String>> filesMap = [
    //   {"name": "profile_picture", "path": userDetails.profilePic},
    //   {"name": "display_picture", "path": userDetails.displayPic}
    // ];
    updateDetailsList = await updateDetails(userDetails: userDetails);
    outputJson['details'] = updateDetailsList[0];
    message += updateDetailsList[1];
    print(updateDetailsList[2]);
    isSuccess = isSuccess && updateDetailsList[2];
    if (userDetails.profilePic != "") {
      updateProfilePicList = await updateFile(
          fileName: "profile_pic", filePath: userDetails.profilePic);
      outputJson['profile_pic'] = updateProfilePicList[0];
      message += updateProfilePicList[1];
      isSuccess = isSuccess && updateProfilePicList[2];
    }
    if (userDetails.displayPic != "") {
      updateDisplayPicList = await updateFile(
          fileName: "display_pic", filePath: userDetails.displayPic);
      outputJson['display_pic'] = updateDisplayPicList[0];
      message += updateDisplayPicList[1];
      isSuccess = isSuccess && updateDisplayPicList[2];
    }
    // outputJson = {
    //   "details": updateDetailsList[0],
    //   "profile_pic": updateProfilePicList[0],
    //   "display_pic": updateDisplayPicList[0],
    // };
    // message = updateDetailsList[1] +
    //     updateProfilePicList[1] +
    //     updateDisplayPicList[1];
    // isSuccess = updateDetailsList[2] && updateProfilePicList[2] && updateDisplayPicList[2];
    // // updateDetails(userDetails: userDetails).then((value) {
    // //   outputJson['details'] = value[0];
    // //   // output += value[0];
    // //   message += value[1];
    // //   isSuccess = isSuccess && value[2];
    // // });
    // if (userDetails.profilePic != "") {
    //   updateFile(fileName: "profile_pic", filePath: userDetails.profilePic)
    //       .then((value) => {
    //             outputJson['profile_pic'] = value[0],
    //             // output += value[0],
    //             message += value[1],
    //             isSuccess = isSuccess && value[2],
    //           });
    // }
    // if (userDetails.displayPic != "") {
    //   updateFile(fileName: "display_pic", filePath: userDetails.displayPic)
    //       .then((value) => {
    //             outputJson['display_pic'] = value[0],
    //             message += value[1],
    //             isSuccess = isSuccess && value[2],
    //           });
    // }
    print(isSuccess);
    if (isSuccess) {
      List response = await read();
      print(response);
      dynamic sOutput = json.decode(response[0]);
      bool sIsSuccess = response[2];
      if (sIsSuccess) {
        storageMethods.write("userDetails", sOutput["response"]);
      }
      // read().then((value) {
      //   dynamic sOutput = json.decode(value[0]);
      //   bool sIsSuccess = value[2];
      //   if (sIsSuccess) {
      //     storageMethods.write("userDetails", sOutput["response"]);
      //   }
      // });
    }
    output = json.encode(outputJson);
    print(output);
    return [output, message, isSuccess];
  }

  Future<List> updateDetails({required UserDetails userDetails}) async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;
    try {
      output = await session.post(
        '/account/profile/update',
        userDetails,
      );
      try {
        dynamic outputJson = jsonDecode(output);

        if (outputJson['update'] == true) {
          isSuccess = true;
          message = "Update successful";
        } else {
          message = outputJson['response'];
        }
      } catch (e) {
        message = "An error occurred";
      }
    } catch (e) {
      output = e.toString();
    }

    print(output);

    return [output, message, isSuccess];
  }

  Future<List> updateFile(
      {required String fileName, required String filePath}) async {
    String output;
    String message = "An error occurred";
    bool isSuccess = false;
    try {
      output = await session.post(
        '/account/profile/update/$fileName',
        [fileName, filePath],
        isFilePath: true,
      );
      try {
        dynamic outputJson = jsonDecode(output);

        if (outputJson['update'] == true) {
          isSuccess = true;
          message = "Update successful";
        } else {
          message = outputJson['response'];
        }
      } catch (e) {
        message = "An error occurred";
      }
    } catch (e) {
      output = e.toString();
    }

    print(output);

    return [output, message, isSuccess];
  }
}
