import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantpat/src/screen/change_password.dart';
import 'package:plantpat/src/screen/ipaddress.dart';
import 'dart:io';
import 'package:plantpat/src/screen/login_screen.dart';
import 'package:plantpat/src/screen/settings.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ImageProvider? userImage; 
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

    static File? imageeee;

  @override
  void initState() {
    super.initState();
    fetchProfileData(); 
  }

  Future<void> fetchProfileData() async {
    await getImageOfUser(Login.idd);
    setState(() {
      firstNameController.text = Login.FirstName;
      lastNameController.text = Login.LastName;
      emailController.text = Login.Email;
      phoneNumberController.text = Login.phonenumberr;
      addressController.text = Login.address;
    });
  }

  Future<void> getImageOfUser(int userId) async {
    try {
      final response = await http.get(Uri.parse('http://$ip:3000/plantpat/user/getProfileImage?userId=$userId'));
      if (response.statusCode == 200 || response.statusCode == 201) {
        dynamic responseData = jsonDecode(response.body);

        if (responseData is Map<String, dynamic> && responseData.containsKey('results')) {
          final userData = responseData['results'][0];
          final imageData = userData['profile_image'];

          if (imageData is Map<String, dynamic> && imageData.containsKey('data')) {
            final byteData = imageData['data'];
            final imageBytes = Uint8List.fromList(List<int>.from(byteData));

            setState(() {
              userImage = MemoryImage(imageBytes);
            });
          } else {
            print('Image data not found in response.');
          }
        } else {
          print('Failed to fetch user data.');
        }
      } else {
        print('Failed to fetch user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user image: $e');
    }
  }

  Future<void> profiledata() async {
    final url = Uri.parse('http://$ip:3000/plantpat/edit/editprofile');
    try {
      print('Updating profile with:');
      print('First Name: ${firstNameController.text}');
      print('Last Name: ${lastNameController.text}');
      print('Email: ${emailController.text}');
      print('Address: ${addressController.text}');
      print('Phone Number: ${phoneNumberController.text}');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': Login.idd,
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'email': emailController.text,
          'address': addressController.text,
          'phoneNumber': phoneNumberController.text,
        }),
      );

 final snackBar = response.statusCode == 200
        ? SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          )
        : SnackBar(
            content: Text('Failed to update profile'),
            backgroundColor: Colors.red,
          );

    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

      if (response.statusCode == 200) {
       
        print('Profile updated successfully');
        

        
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final message = responseData['message'] as String?;

        
        if (message != null) {
          print('Response message: $message');
          
          
          Login.FirstName = firstNameController.text;
          Login.LastName = lastNameController.text;
          Login.Email = emailController.text;
          Login.phonenumberr = phoneNumberController.text;
          Login.address = addressController.text;

          
          await fetchProfileData();

        } else {
          print('Message field is null in the response.');
        }

      } else {
        
        print('Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (e) {
      
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('74'.tr),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            

Navigator.pop(context);


          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              profiledata();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
GestureDetector(
  onTap: () {
    _imagePicker();
  },
  child: Stack(
    alignment: Alignment.center,
    children: [
      CircleAvatar(
        radius: 60,
        backgroundImage: userImage ?? AssetImage('assets/images/nohuman.png') as ImageProvider,
      ),
      Positioned(
        bottom: 8, 
        right: 8, 
        child: GestureDetector(
          onTap: () {
           _imagePicker();
          },
          child: Icon(
            Icons.edit,
            size: 30,
            color: Color(0xFF4B8E4B),
          ),
        ),
      ),
    ],
  ),
),
           //   SizedBox(height: 10),
              SizedBox(height: 20),
              _buildTextField('75'.tr, firstNameController),
              SizedBox(height: 20),
              _buildTextField('76'.tr, lastNameController),
              SizedBox(height: 20),
              _buildTextField('77'.tr, emailController),
              SizedBox(height: 20),
              _buildTextField('78'.tr, phoneNumberController),
              SizedBox(height: 20),
              _buildTextField('79'.tr, addressController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: profiledata,
                child: Text(
                  '80'.tr,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4B8E4B),
                  padding: EdgeInsets.symmetric(horizontal: 135, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.5),
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 7.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
              width: 1.0,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: label,
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
          ),
        ),
      ],
    );
  }



void _imagePicker() async {
  var imagePicker = ImagePicker();
  XFile? pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

  if (pickedImage != null) {
    setState(() {
      imageeee = File(pickedImage.path);
    });

    
    await uploadProfile(imageeee!);

    
    await getImageOfUser(Login.idd);
   


    if (pickedImage != null) {
      File imageFile = File(pickedImage.path);

   
      SettingsPageState.userImage = FileImage(imageFile);
     
      print('User image updated: ${SettingsPageState.userImage}');
    }

  }
}







  //   static Future<void> uploadProfile(
  //   File imageA,
  // ) async {
  //   var request = http.MultipartRequest(
  //     'PUT',
  //     Uri.parse('http://$ip:3000/plantpat/user/addProfileImage'),
  //   );

  //   request.fields['email'] = Login.Email;
  //   request.fields['userId'] = Login.idd.toString();

  //   print( request.fields['email']);
  //   print(request.fields['userId']);

  //   print("oooooooooooookkkkkkkk");

  //   // for (int i = 0; i < imageA.length; i++) {
  //   var stream =
  //       http.ByteStream(imageA.openRead().cast()); // Convert image to bytes
  //   var length = await imageA.length(); // Get image file length
  //   var multipartFile = http.MultipartFile(
  //     'image', // Consider using 'image' here, depends on your server-side implementation
  //     stream,
  //     length,
  //     filename: imageA.path.split('/').last,
  //   );
  //   request.files.add(multipartFile);
  //   //  }

  //   try {
  //     var response = await request.send();
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       print('Upload successful');
  //       // Handle success
  //     } else {
  //       print('Upload failed with status: ${response.statusCode}');
  //       // Handle error
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     // Handle error
  //   }
  // }



static Future<void> uploadProfile(File imageA) async {
  var request = http.MultipartRequest(
    'PUT',
    Uri.parse('http://$ip:3000/plantpat/user/addProfileImage'),
  );

  request.fields['email'] = Login.Email;
  request.fields['userId'] = Login.idd.toString();

  print('Email: ${request.fields['email']}');
  print('UserId: ${request.fields['userId']}');
  print('Uploading image...');

  var stream = http.ByteStream(imageA.openRead().cast());
  var length = await imageA.length();
 var multipartFile = http.MultipartFile(
  'image', 
  stream,
  length,
  filename: imageA.path.split('/').last,
);
  request.files.add(multipartFile);

  try {
    var response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Upload successful');
      
    } else {
      print('Upload failed with status: ${response.statusCode}');
     
    }
  } catch (e) {
    print('Error: $e');
  
  }
}



  
}
