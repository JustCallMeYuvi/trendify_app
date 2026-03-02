import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  bool _inventoryTracking = true;
  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL'];
  final Set<String> _selectedSizes = {'XS', 'S', 'M'};

  final Color _primaryColor = const Color(0xFFF43F5E);
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  bool _isSaving = false;
  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedImages = [];

  Future<void> _showImageSourceOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    }
  }

  String _selectedCategory = "Women's Wear";
  Future<void> _saveProduct() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields & select images")),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // 🔥 Convert to Base64
      List<String> base64Images = await _convertImagesToBase64();

      await FirebaseFirestore.instance.collection("products").add({
        "name": _nameController.text.trim(),
        "description": _descriptionController.text.trim(),
        "price": double.parse(_priceController.text.trim()),
        "category": _selectedCategory,
        "sizes": _selectedSizes.toList(),
        "stock":
            _inventoryTracking ? int.parse(_stockController.text.trim()) : 0,
        "inventoryTracking": _inventoryTracking,
        "imageUrls": base64Images, // 🔥 Now storing Base64
        "createdAt": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product Added Successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => _isSaving = false);
  }

  Future<List<String>> _convertImagesToBase64() async {
    List<String> base64Images = [];

    for (XFile image in _selectedImages) {
      List<int> bytes = await image.readAsBytes();
      base64Images.add(base64Encode(bytes));
    }

    return base64Images;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () {},
        ),
        title: const Text(
          'Add New Product',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade100, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Product Images'),
            const SizedBox(height: 16),
            _buildImagePicker(),
            const SizedBox(height: 32),

            _buildSectionHeader('General Information'),
            const SizedBox(height: 16),
            _buildTextField(
                controller: _nameController,
                label: 'Product Name',
                hint: 'e.g. Silk Evening Gown'),
            const SizedBox(height: 20),
            _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe the fabric, fit, and style details...',
                maxLines: 4),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                    child: _buildTextField(
                        controller: _priceController,
                        label: 'Price',
                        hint: '\$ 0.00',
                        prefix: '\$ ')),
                const SizedBox(width: 16),
                _buildDropdownField(label: 'Category', value: "Women's Wear"),
              ],
            ),
            const SizedBox(height: 32),

            _buildSectionHeader('Available Sizes'),
            const SizedBox(height: 16),
            _buildSizeSelector(),
            const SizedBox(height: 32),

            _buildInventoryToggle(),
            if (_inventoryTracking) ...[
              const SizedBox(height: 16),
              _buildTextField(
                  controller: _stockController,
                  label: 'Quantity in Stock',
                  hint: '100',
                  keyboardType: TextInputType.number),
            ],
            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // Widget _buildImagePicker() {
  //   return SizedBox(
  //     height: 180,
  //     child: ListView(
  //       scrollDirection: Axis.horizontal,
  //       children: [
  //         // Add Photo Button
  //         Container(
  //           width: 130,
  //           decoration: BoxDecoration(
  //             color: const Color(0xFFFFF1F2),
  //             borderRadius: BorderRadius.circular(24),
  //             border: Border.all(
  //                 color: const Color(0xFFFECDD3),
  //                 width: 2,
  //                 style: BorderStyle.solid),
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.all(12),
  //                 decoration: BoxDecoration(
  //                     color: _primaryColor, shape: BoxShape.circle),
  //                 child: const Icon(Icons.camera_alt,
  //                     color: Colors.white, size: 24),
  //               ),
  //               const SizedBox(height: 8),
  //               Text('Add Photo',
  //                   style: TextStyle(
  //                       color: _primaryColor,
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 12)),
  //             ],
  //           ),
  //         ),
  //         const SizedBox(width: 12),
  //         // Mock Image 1
  //         _buildImagePreview(
  //             'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400'),
  //         const SizedBox(width: 12),
  //         // Mock Image 2
  //         _buildImagePreview(
  //             'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400'),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildImagePicker() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Add Photo Button
          GestureDetector(
            // onTap: _pickImages,
            onTap: _showImageSourceOptions,
            child: Container(
              width: 130,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F2),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFFECDD3),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add Photo',
                    style: TextStyle(
                      color: _primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Selected Images Preview
          ..._selectedImages.map((image) {
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.file(
                      File(image.path),
                      width: 130,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImages.remove(image);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child:
                            Icon(Icons.close, size: 16, color: _primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String url) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.network(url, width: 130, height: 180, fit: BoxFit.cover),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: Icon(Icons.close, size: 16, color: _primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
      {required String label,
      required String hint,
      required TextEditingController controller,
      int maxLines = 1,
      String? prefix,
      TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller, // ✅ ADD THIS LINE

          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: _primaryColor)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(fontSize: 16)),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSizeSelector() {
    return Wrap(
      spacing: 12,
      children: _sizes.map((size) {
        bool isSelected = _selectedSizes.contains(size);
        return GestureDetector(
          onTap: () => setState(() => isSelected
              ? _selectedSizes.remove(size)
              : _selectedSizes.add(size)),
          child: Container(
            width: 55,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? _primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: isSelected ? _primaryColor : Colors.grey.shade100,
                  width: 2),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                          color: _primaryColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4))
                    ]
                  : null,
            ),
            child: Text(
              size,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInventoryToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Inventory Tracking',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Switch(
          value: _inventoryTracking,
          activeColor: Colors.white,
          activeTrackColor: _primaryColor,
          onChanged: (val) => setState(() => _inventoryTracking = val),
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          minimumSize: const Size(double.infinity, 56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 8,
          shadowColor: _primaryColor.withOpacity(0.3),
        ),
        child: _isSaving
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Save Product',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
