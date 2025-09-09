import 'package:flutter/material.dart';


import 'package:enterpro/services/database_helper.dart';

class AvatarCustomizationScreen extends StatefulWidget {
  const AvatarCustomizationScreen({Key? key}) : super(key: key);

  @override
  State<AvatarCustomizationScreen> createState() => _AvatarCustomizationScreenState();
}

class _AvatarCustomizationScreenState extends State<AvatarCustomizationScreen> {
  String _selectedHead = 'head_1.png'; // Default head
  String _selectedBody = 'body_1.png'; // Default body
  String _selectedAccessory = 'accessory_1.png'; // Default accessory

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    final avatar = await DatabaseHelper().getAvatar(1); // Assuming a single user avatar with ID 1
    if (avatar != null) {
      setState(() {
        _selectedHead = avatar.head;
        _selectedBody = avatar.body;
        _selectedAccessory = avatar.accessory;
      });
    }
  }

  Future<void> _saveAvatar() async {
    final avatar = Avatar(
      id: 1,
      head: _selectedHead,
      body: _selectedBody,
      accessory: _selectedAccessory,
    );
    await DatabaseHelper().updateAvatar(avatar);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Avatar guardado exitosamente!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalizar Avatar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display current avatar
            Expanded(
              child: Center(
                child: Stack(
                  children: [
                    Image.asset('assets/avatars/$_selectedBody'),
                    Image.asset('assets/avatars/$_selectedHead'),
                    Image.asset('assets/avatars/$_selectedAccessory'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Head selection
            Text('Cabeza', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildAvatarPartOption('head_1.png', 'head'),
                  _buildAvatarPartOption('head_2.png', 'head'),
                  // Add more head options
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Body selection
            Text('Cuerpo', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildAvatarPartOption('body_1.png', 'body'),
                  _buildAvatarPartOption('body_2.png', 'body'),
                  // Add more body options
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Accessory selection
            Text('Accesorio', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildAvatarPartOption('accessory_1.png', 'accessory'),
                  _buildAvatarPartOption('accessory_2.png', 'accessory'),
                  // Add more accessory options
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAvatar,
              child: const Text('Guardar Avatar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPartOption(String assetPath, String partType) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (partType == 'head') {
            _selectedHead = assetPath;
          } else if (partType == 'body') {
            _selectedBody = assetPath;
          } else if (partType == 'accessory') {
            _selectedAccessory = assetPath;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isSelected(assetPath, partType) ? Colors.blueAccent : Colors.transparent,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Image.asset('assets/avatars/$assetPath', width: 80, height: 80),
      ),
    );
  }

  bool _isSelected(String assetPath, String partType) {
    if (partType == 'head') {
      return _selectedHead == assetPath;
    } else if (partType == 'body') {
      return _selectedBody == assetPath;
    } else if (partType == 'accessory') {
      return _selectedAccessory == assetPath;
    }
    return false;
  }
}