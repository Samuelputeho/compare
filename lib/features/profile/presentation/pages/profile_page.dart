import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:compareitr/core/common/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:compareitr/features/auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AuthFailure) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is AuthSuccess) {
          final user = state.user;

          return Column(
            children: [
              // User Profile Section
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40, // Profile picture size
                      backgroundImage: NetworkImage(
                        user.proPic.isNotEmpty
                            ? user.proPic
                            : 'https://example.com/default_profile.jpg', // Replace with default image or user's profile image
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name, // Use dynamic name from the user
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user.email, // Use dynamic email from the user
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Edit Profile Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the edit profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileUpdateForm(user: user),
                      ),
                    );
                  },
                  child: const Text('Edit Profile'),
                ),
              ),
              // List of Buttons (Tabs)
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('Change Password'),
                      onTap: () {
                        // Navigate to Change Password Section
                      },
                    ),
                    ListTile(
                      title: const Text('Theme'),
                      onTap: () {
                        // Navigate to Theme Section
                      },
                    ),
                    ListTile(
                      title: const Text('About Us'),
                      onTap: () {
                        // Navigate to About Us Section
                      },
                    ),
                    ListTile(
                      title: const Text('Logout'),
                      onTap: () {
                        // Trigger logout event
                        context.read<AuthBloc>().add(AuthLogout());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logged out')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text('No user data available.'));
        }
      }),
    );
  }
}

// Profile Update Form
class ProfileUpdateForm extends StatefulWidget {
  final UserEntity user;

  const ProfileUpdateForm({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileUpdateFormState createState() => _ProfileUpdateFormState();
}

class _ProfileUpdateFormState extends State<ProfileUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _streetController;
  late TextEditingController _locationController;
  late TextEditingController _phoneNumberController;
  late File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _streetController = TextEditingController(text: widget.user.street);
    _locationController = TextEditingController(text: widget.user.location);
    _phoneNumberController =
        TextEditingController(text: widget.user.phoneNumber.toString());
    _imageFile = null; // Start with no image
  }

  @override
  void dispose() {
    _nameController.dispose();
    _streetController.dispose();
    _locationController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedUser = UserEntity(
        id: widget.user.id,
        name: _nameController.text,
        email: widget.user.email, // Retain the current email
        street: _streetController.text,
        location: _locationController.text,
        phoneNumber: int.parse(_phoneNumberController.text),
        proPic: _imageFile?.path ??
            widget.user.proPic, // Keep current profile picture if not updated
      );
      setState(() {});
      // Trigger the profile update
      context.read<AuthBloc>().add(AuthUpdateProfile(
            userId: updatedUser.id,
            name: updatedUser.name,
            street: updatedUser.street,
            location: updatedUser.location,
            phoneNumber: updatedUser.phoneNumber,
            imagePath: _imageFile!,
            email: updatedUser.email,
          ));

      // Pop the form from the navigation stack
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : NetworkImage(widget.user.proPic.isNotEmpty
                              ? widget.user.proPic
                              : 'https://example.com/default_profile.jpg')
                          as ImageProvider,
                  child: _imageFile == null
                      ? const Icon(Icons.camera_alt, size: 30)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(labelText: 'Street'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Street is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Location is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
