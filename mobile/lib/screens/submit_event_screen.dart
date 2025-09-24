import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ...existing code...
import '../providers/auth_provider.dart';
import '../services/storage_service.dart';

// ignore_for_file: use_build_context_synchronously

class SubmitEventScreen extends ConsumerStatefulWidget {
  const SubmitEventScreen({super.key});

  @override
  ConsumerState<SubmitEventScreen> createState() => _SubmitEventScreenState();
}

class _SubmitEventScreenState extends ConsumerState<SubmitEventScreen> {
  int _step = 0;
  final _formKey = GlobalKey<FormState>();

  // temporary form state
  String title = '';
  String description = '';
  DateTime? startsAt;
  String location = '';
  String category = '';
  String posterUrl = '';
  double uploadProgress = 0.0;
  bool uploadFailed = false;
  // controller for in-flight upload so we can cancel
  UploadController? _uploadController;
  // picked image before upload
  XFile? _pickedFile;
  Uint8List? _pickedBytes;
  // Prevent multiple simultaneous picker requests
  bool _isPicking = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Submit Event')),
      body: user == null
          ? const Center(child: Text('Please sign in to submit an event'))
          : Form(
              key: _formKey,
              child: Stepper(
                currentStep: _step,
                onStepContinue: _nextStep,
                onStepCancel: _prevStep,
                steps: [
                  Step(title: const Text('Basic'), content: Column(children: [
                    TextFormField(decoration: const InputDecoration(labelText: 'Title'), onSaved: (v) => title = v ?? ''),
                    TextFormField(decoration: const InputDecoration(labelText: 'Description'), onSaved: (v) => description = v ?? ''),
                  ])),
                  Step(title: const Text('When'), content: Column(children: [
                    ListTile(title: Text(startsAt == null ? 'Pick date/time' : startsAt!.toString()), onTap: _pickDateTime),
                  ])),
                  Step(title: const Text('Where'), content: Column(children: [
                    TextFormField(decoration: const InputDecoration(labelText: 'Location'), onSaved: (v) => location = v ?? ''),
                  ])),
                  Step(title: const Text('Category'), content: Column(children: [
                    TextFormField(decoration: const InputDecoration(labelText: 'Category'), onSaved: (v) => category = v ?? ''),
                  ])),
                  Step(title: const Text('Poster'), content: Column(children: [
                    if (_pickedBytes == null) ...[
                      ElevatedButton(onPressed: _pickImage, child: const Text('Choose poster')),
                    ] else ...[
                      // preview + actions
                      Image.memory(_pickedBytes!, width: 200, height: 120, fit: BoxFit.cover),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        ElevatedButton(onPressed: _confirmUpload, child: const Text('Confirm upload')),
                        ElevatedButton(onPressed: () { setState(() { _pickedFile = null; _pickedBytes = null; }); }, child: const Text('Change')),
                        ElevatedButton(onPressed: () { setState(() { _pickedFile = null; _pickedBytes = null; posterUrl = ''; uploadFailed = false; uploadProgress = 0.0; }); }, child: const Text('Remove')),
                      ]),
                    ],
                    const SizedBox(height: 8),
                    if (uploadProgress > 0 && uploadProgress < 1.0) ...[
                      LinearProgressIndicator(value: uploadProgress),
                      const SizedBox(height: 8),
                      Text('Uploading ${(uploadProgress * 100).toStringAsFixed(0)}%'),
                      const SizedBox(height: 8),
                      ElevatedButton(onPressed: () {
                        // cancel in-flight upload
                        try { _uploadController?.cancel(); } catch (_) {}
                        setState(() { posterUrl = ''; uploadFailed = true; uploadProgress = 0.0; _uploadController = null; });
                      }, child: const Text('Cancel upload'))
                    ] else if (uploadFailed) ...[
                      const Text('Upload failed'),
                      const SizedBox(height: 8),
                      ElevatedButton(onPressed: () { setState(() { posterUrl = ''; uploadFailed = false; uploadProgress = 0.0; }); }, child: const Text('Retry'))
                    ] else if (posterUrl.isNotEmpty) ...[
                      Text('Uploaded: $posterUrl')
                    ]
                  ])),
                  Step(title: const Text('Review'), content: Column(children: [
                    Text('Title: $title'),
                    Text('When: ${startsAt?.toString() ?? 'n/a'}'),
                    Text('Where: $location'),
                    Text('Category: $category'),
                    Text('Poster: $posterUrl'),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: _submitDraft, child: const Text('Submit (saves as pending)'))
                  ])),
                ],
              ),
            ),
    );
  }

  void _nextStep() {
    if (_step < 5) setState(() => _step++);
  }

  void _prevStep() {
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _pickDateTime() async {
    final d = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(const Duration(days: 365)), lastDate: DateTime.now().add(const Duration(days: 3650)));
    if (d == null) return;
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t == null) return;
    setState(() => startsAt = DateTime(d.year, d.month, d.day, t.hour, t.minute));
  }

  // legacy pick/upload flow removed - new flow uses _pickImage and _confirmUpload

  Future<void> _pickImage() async {
    if (_isPicking) return; // ignore reentrant calls
    _isPicking = true;
    try {
      final picker = ImagePicker();
      XFile? picked;
      try {
        picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1600, maxHeight: 1600, imageQuality: 85);
      } on PlatformException catch (e) {
        // Handle common platform errors (e.g., multiple_request)
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image picker error: ${e.code}')));
        return;
      }
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      setState(() { _pickedFile = picked; _pickedBytes = bytes; uploadFailed = false; uploadProgress = 0.0; });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
    } finally {
      _isPicking = false;
    }
  }

  Future<void> _confirmUpload() async {
    if (_pickedBytes == null || _pickedFile == null) return;
    final storage = ref.read(storageServiceProvider);
    final filename = 'poster_${DateTime.now().millisecondsSinceEpoch}_${_pickedFile!.name}';
    setState(() { posterUrl = 'uploading'; uploadFailed = false; uploadProgress = 0.001; });
    try {
      final controller = storage.uploadPoster(filename, _pickedBytes!, onProgress: (p) {
        if (!mounted) return;
        setState(() => uploadProgress = p);
      });
      _uploadController = controller;
      final url = await controller.future;
      if (!mounted) return;
      setState(() { posterUrl = url; uploadProgress = 1.0; uploadFailed = false; _uploadController = null; _pickedFile = null; _pickedBytes = null; });
    } catch (e) {
      setState(() { posterUrl = ''; uploadFailed = true; uploadProgress = 0.0; _uploadController = null; });
    }
  }

  Future<void> _submitDraft() async {
    final user = ref.read(currentUserProvider);
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please sign in to submit an event')));
      }
      return;
    }

    _formKey.currentState?.save();
    final fs = ref.read(firestoreServiceProvider);
    final Map<String, dynamic> payload = {
      'title': title,
      'description': description,
      // write startsAt as a Firestore Timestamp if present
      if (startsAt != null) 'startsAt': Timestamp.fromDate(startsAt!),
      'location': location,
      'categoryName': category,
      'posterUrl': posterUrl,
      // Do not set server-managed fields like status/createdAt here.
      // The rules require `createdBy` to equal the auth uid on create.
      'createdBy': user.uid,
    };

    try {
      await fs.createEvent(payload);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event submitted — pending moderation')));
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit event: $e')));
    }
  }
}
