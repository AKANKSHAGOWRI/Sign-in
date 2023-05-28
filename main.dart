import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(RegistrationApp());
}

class RegistrationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  DateTime _selectedDate;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm()  async {
    if (_formKey.currentState.validate()) {
      // Perform form submission
      // Send data to the backend, save to the database, and send an email
      // Perform form submission
      final url = 'http://localhost:8080/submit';
      final response = await http.post(
        url,
        body: {
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'dob': _selectedDate != null ? _selectedDate.toString() : '',
          'email': _emailController.text,
          'phoneNumber': _phoneNumberController.text,
        },
      );

      if (response.statusCode == 200) {
        // Form submitted successfully
        // Redirect to the page showing the submitted forms and CVs
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SubmittedFormsPage()),
        );
      } else {
        // Handle submission error
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'An error occurred while submitting the form. Please try again.'),
              actions: [
                FlatButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      }

      // Clear form fields
      _formKey.currentState.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                  ),
                  child: Text(_selectedDate != null
                      ? _selectedDate.toString()
                      : 'Select a date'),
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add email validation logic
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  // Add phone number validation logic
                  return null;
                },
              ),
              RaisedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
