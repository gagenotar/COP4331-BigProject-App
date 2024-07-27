import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import '../components/trip.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journey_journal_app/pages/home_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Import the flutter_rating_bar package

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({Key? key, this.onSuccess, required this.credentials, required this.email}) : super(key: key);

  final Function()? onSuccess; // Define onSuccess callback
  final Map<String, dynamic> credentials;
  final String email;

  @override
  _AddEntryPageState createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  double _rating = 0.0; // Track rating as a double
  Uint8List? _imageData;
  String? _imageName;

  String createLocationJson(String street, String city, String state, String country) {
    final location = {
      'street': street,
      'city': city,
      'state': state,
      'country': country,
    };
    return jsonEncode(location); // Convert to JSON string
  }

  Future<void> _submitEntry() async {
    if (_imageData == null) {
      _showErrorDialog('Please select an image.');
      return;
    }

    String street = _streetController.text;
    String city = _cityController.text;
    String state = _stateController.text;
    String country = _countryController.text;

    String locationJson = createLocationJson(street, city, state, country);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://journey-journal-cop4331-71e6a1fdae61.herokuapp.com/api/app/addEntry'),
    );

    request.fields['userId'] = '${widget.credentials['id']}';
    request.fields['title'] = _titleController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['location'] = locationJson;
    request.fields['rating'] = _rating.toString(); // Convert rating to string

    var multipartFile = http.MultipartFile.fromBytes(
      'image', // Field name must match the server-side field name
      _imageData!,
      filename: _imageName,
    );

    request.files.add(multipartFile);

    var response = await request.send();
    var responseData = await http.Response.fromStream(response);

    print('Response status: ${response.statusCode}');
    print('Response body: ${responseData.body}');

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(responseData.body);
      print('Entry added with ID: ${responseJson['_id']}');
      if (widget.onSuccess != null) {
        widget.onSuccess!(); // Call onSuccess callback if defined
      }
      //potentially change to home page navigation
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomeScreen(credentials: widget.credentials, email: widget.email))
      );
    } else {
      // Handle submission failure
      print('Failed to add entry');
      _showErrorDialog('Error adding entry.');
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        print('Selected image: ${image.name}');
        final Uint8List imageData = await image.readAsBytes();
        setState(() {
          _imageData = imageData;
          _imageName = image.name;
        });
      } else {
        print('No image selected or canceled.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Submission Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/images/logo.png', // Make sure this image path is correct
                    height: 100,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Add An Adventure!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  color: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        _buildTextField(_titleController, 'Title'),
                        SizedBox(height: 10),
                        _buildTextField(_descriptionController, 'Description', maxLines: 3),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: _buildTextField(_streetController, 'Street'),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: _buildTextField(_cityController, 'City'),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: _buildTextField(_stateController, 'State'),
                              ),
                            ),
                            Expanded(
                              child: _buildTextField(_countryController, 'Country'),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Star rating bar
                        RatingBar.builder(
                          initialRating: _rating,
                          minRating: 1,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 30.0,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        _imageData == null
                            ? Text('No image selected.')
                            : Image.memory(
                          _imageData!,
                          width: 468, // Adjust width if needed
                          fit: BoxFit.cover, // Adjust fit if needed
                        ),
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('Upload Image'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitEntry,
                    child: Text('Add Post'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildTextField(TextEditingController controller, String labelText,
      {int maxLines = 1,
        TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: const Color.fromARGB(255, 1, 6, 16)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
    );
  }
}
