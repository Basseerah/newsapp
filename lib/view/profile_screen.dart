import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'vintage_components.dart';

// Shared config for user preferences
class ReaderPreferences {
  static final ValueNotifier<double> fontSizeScale = ValueNotifier<double>(1.0);
  static final ValueNotifier<Color> selectedPaperTone = ValueNotifier<Color>(VintageColors.background);
  static final ValueNotifier<String> toneName = ValueNotifier<String>("Parchment");
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _morningAlerts = true;
  bool _weeklyDigests = false;

  final Map<String, Color> _tones = {
    "Parchment": VintageColors.background,
    "Museum Cream": VintageColors.cardBg,
    "Archive Grey": VintageColors.backgroundDark,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VintageColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Section Title
              Center(
                child: Text(
                  "READER PROFILE",
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    color: VintageColors.text,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Library Card / Press Pass
              PaperContainer(
                doubleBorder: true,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header of card
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "THE VINTAGE DISPATCH",
                                style: GoogleFonts.oldStandardTt(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: VintageColors.text,
                                ),
                              ),
                              Text(
                                "READER'S ASSOCIATION",
                                style: GoogleFonts.libreBaskerville(
                                  fontSize: 8,
                                  color: VintageColors.accent,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Press stamp
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(color: VintageColors.accent.withOpacity(0.6), width: 1.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "APPROVED",
                            style: GoogleFonts.libreBaskerville(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: VintageColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: VintageColors.border, thickness: 1, height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sketch-like sepia photo frame
                        Container(
                          width: 80,
                          height: 90,
                          decoration: BoxDecoration(
                            color: VintageColors.backgroundDark,
                            border: Border.all(color: VintageColors.border, width: 1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: VintageColors.text.withOpacity(0.3),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Reader details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _cardField("MEMBER", "John Doe, Esq."),
                              const SizedBox(height: 6),
                              _cardField("REGISTRATION", "No. 1926-880B"),
                              const SizedBox(height: 6),
                              _cardField("STATUS", "Lifetime Dispatch Patron"),
                              const SizedBox(height: 6),
                              _cardField("ISSUED AT", "London Archives Office"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Settings Header
              const SectionHeader(title: "Dispatch Settings"),

              // Settings Option: Font Sizing (Accessibility)
              PaperContainer(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                margin: const EdgeInsets.only(bottom: 12),
                child: ValueListenableBuilder<double>(
                  valueListenable: ReaderPreferences.fontSizeScale,
                  builder: (context, scale, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Typography Font Scale",
                              style: GoogleFonts.libreBaskerville(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: VintageColors.text,
                              ),
                            ),
                            Text(
                              "${(scale * 100).toInt()}%",
                              style: GoogleFonts.ebGaramond(
                                fontSize: 14,
                                color: VintageColors.accent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Adjust scale for comfortable reading width & height",
                          style: GoogleFonts.ebGaramond(fontSize: 12, color: VintageColors.muted),
                        ),
                        Slider(
                          value: scale,
                          min: 0.8,
                          max: 1.6,
                          divisions: 4,
                          activeColor: VintageColors.accent,
                          inactiveColor: VintageColors.border,
                          onChanged: (val) {
                            ReaderPreferences.fontSizeScale.value = val;
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Settings Option: Color Theme (Parchment, Cream, Grey)
              PaperContainer(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                margin: const EdgeInsets.only(bottom: 12),
                child: ValueListenableBuilder<Color>(
                  valueListenable: ReaderPreferences.selectedPaperTone,
                  builder: (context, currentTone, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Parchment Paper Tone",
                          style: GoogleFonts.libreBaskerville(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: VintageColors.text,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: _tones.entries.map((entry) {
                            final isSelected = entry.value == currentTone;
                            return GestureDetector(
                              onTap: () {
                                ReaderPreferences.selectedPaperTone.value = entry.value;
                                ReaderPreferences.toneName.value = entry.key;
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: entry.value,
                                  border: Border.all(
                                    color: isSelected ? VintageColors.accent : VintageColors.border,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  entry.key,
                                  style: GoogleFonts.ebGaramond(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: VintageColors.text,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Settings Option: Dispatch Notifications
              PaperContainer(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    SwitchListTile(
                      value: _morningAlerts,
                      activeColor: VintageColors.accent,
                      title: Text(
                        "Morning Dispatch Alerts",
                        style: GoogleFonts.libreBaskerville(fontSize: 12, color: VintageColors.text),
                      ),
                      subtitle: Text(
                        "Receive daily notifications at sunrise",
                        style: GoogleFonts.ebGaramond(fontSize: 11, color: VintageColors.muted),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _morningAlerts = val;
                        });
                      },
                    ),
                    const Divider(color: VintageColors.border, height: 1),
                    SwitchListTile(
                      value: _weeklyDigests,
                      activeColor: VintageColors.accent,
                      title: Text(
                        "Special Editorial Digests",
                        style: GoogleFonts.libreBaskerville(fontSize: 12, color: VintageColors.text),
                      ),
                      subtitle: Text(
                        "Preserve critical weekly digests locally",
                        style: GoogleFonts.ebGaramond(fontSize: 11, color: VintageColors.muted),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _weeklyDigests = val;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Settings Option: About Archives
              PaperContainer(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ABOUT THE VINTAGE DISPATCH",
                      style: GoogleFonts.libreBaskerville(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: VintageColors.text,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Serving London, York, and the British empire since May 1926. Dedicated to preservation, editorial rigor, and high-readability printed aesthetics. Digitized for the discerning contemporary scholar.",
                      style: GoogleFonts.ebGaramond(
                        fontSize: 13,
                        height: 1.25,
                        color: VintageColors.text.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "App Version: 1926.1.0 (Digital Edition)",
                      style: GoogleFonts.ebGaramond(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: VintageColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.libreBaskerville(
            fontSize: 7,
            color: VintageColors.accent,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.ebGaramond(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: VintageColors.text,
          ),
        ),
      ],
    );
  }
}
