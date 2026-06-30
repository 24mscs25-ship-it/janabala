import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";
import "package:image_picker/image_picker.dart";
import "package:provider/provider.dart";

import "../l10n/app_localizations.dart";
import "../models/constituency.dart";
import "../models/enums.dart";
import "../services/issue_repository.dart";

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtl = TextEditingController();
  final _descCtl = TextEditingController();

  IssueCategory _category = IssueCategory.roads;
  Urgency _urgency = Urgency.low;
  String? _constituencyId;
  double? _lat;
  double? _lng;
  String? _photoPath;
  bool _busy = false;

  List<Constituency> _constituencies = [];

  @override
  void initState() {
    super.initState();
    _loadConstituencies();
  }

  @override
  void dispose() {
    _titleCtl.dispose();
    _descCtl.dispose();
    super.dispose();
  }

  Future<void> _loadConstituencies() async {
    final repo = context.read<IssueRepository>();
    final items = await repo.getConstituencies();
    if (!mounted) return;
    setState(() => _constituencies = items);
  }

  Future<void> _getLocation() async {
    final l10n = AppLocalizations.of(context);
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
      });
      _snack(l10n.locationAttached);
    } catch (e) {
      _snack(e.toString());
    }
  }

  Future<void> _pickPhoto() async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.camera);
      if (file != null) setState(() => _photoPath = file.path);
    } catch (e) {
      _snack(e.toString());
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final repo = context.read<IssueRepository>();
    final l10n = AppLocalizations.of(context);
    try {
      await repo.createIssue(
        category: _category,
        title: _titleCtl.text.trim(),
        description: _descCtl.text.trim().isEmpty ? null : _descCtl.text.trim(),
        constituencyId: _constituencyId,
        latitude: _lat,
        longitude: _lng,
        // NOTE: photo is captured locally; uploading binary to object storage
        // is out of scope (contract takes photo_urls only). See README.
        photoUrls: null,
        urgency: _urgency,
      );
      if (!mounted) return;
      _snack(l10n.savedOffline);
      _resetForm();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _resetForm() {
    _titleCtl.clear();
    _descCtl.clear();
    setState(() {
      _category = IssueCategory.roads;
      _urgency = Urgency.low;
      _constituencyId = null;
      _lat = null;
      _lng = null;
      _photoPath = null;
    });
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.reportIssue,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            DropdownButtonFormField<IssueCategory>(
              initialValue: _category,
              decoration: InputDecoration(
                labelText: l10n.category,
                border: const OutlineInputBorder(),
              ),
              items: IssueCategory.values
                  .map((c) =>
                      DropdownMenuItem(value: c, child: Text(c.wire)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleCtl,
              decoration: InputDecoration(
                labelText: l10n.title,
                border: const OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.requiredField : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtl,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.description,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Urgency>(
              initialValue: _urgency,
              decoration: InputDecoration(
                labelText: l10n.urgency,
                border: const OutlineInputBorder(),
              ),
              items: Urgency.values
                  .map((u) =>
                      DropdownMenuItem(value: u, child: Text(u.wire)))
                  .toList(),
              onChanged: (v) => setState(() => _urgency = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              initialValue: _constituencyId,
              decoration: InputDecoration(
                labelText: l10n.filterConstituency,
                border: const OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: null, child: Text(l10n.all)),
                ..._constituencies.map(
                  (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                ),
              ],
              onChanged: (v) => setState(() => _constituencyId = v),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _getLocation,
                    icon: const Icon(Icons.my_location),
                    label: Text(_lat == null
                        ? l10n.useLocation
                        : l10n.locationAttached),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickPhoto,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(_photoPath == null
                        ? l10n.addPhoto
                        : "1 ${l10n.addPhoto}"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _busy ? null : _submit,
              child: Text(l10n.submit),
            ),
          ],
        ),
      ),
    );
  }
}
