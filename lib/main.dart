import 'package:clipboard/clipboard.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_cloud_translation/google_cloud_translation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translator_app_with_d4/language_model.dart';
import "package:flutter_tts/flutter_tts.dart";

String apiKey = "AIzaSyCIyR35pgtP3spCguV6MprjB1W-RSWJWTA";
Color backgroundColor = Color(0xff141F47);
Color inputCardColor = Color(0xff1C2D6B);
Color outputColor = Color(0xff556BBE);
Color whiteColor = Color(0xffFFFFFF);
Color greyButtonColor = Color(0xffA1A9C8);
Color greyTextColor = Color(0xffBCC7EF);
Color buttonColor = Color(0xff152F8D);
Color cardColor = Color(0xff1A254F);

void main() {
  runApp(
    DevicePreview(
      enabled: false,
      builder: (_) => TranslatorApp(),
    ),
  );
}

class TranslatorApp extends StatelessWidget {
  const TranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LanguageModel inputLanguage = languages[0];
  LanguageModel outputLanguage = languages[1];
  TextEditingController inputController = TextEditingController();
  FocusNode inputFocus = FocusNode();
  String output = "";
  Translation translator = Translation(apiKey: apiKey);

  void perevod() async {
    TranslationModel tr = await translator.translate(
      text: inputController.text,
      to: outputLanguage.code,
    );
    output = tr.translatedText;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              // Languages
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: DropdownButton<LanguageModel>(
                            dropdownColor: backgroundColor,
                            borderRadius: BorderRadius.circular(15),
                            underline: SizedBox.shrink(),
                            padding: EdgeInsets.zero,
                            icon: SizedBox.shrink(),
                            value: inputLanguage,
                            onChanged: (value) {
                              if (value == null) return;
                              inputLanguage = value;
                              setState(() {});
                            },
                            style: GoogleFonts.barlow(
                              color: whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            items: languages
                                .map(
                                  (lan) => DropdownMenuItem<LanguageModel>(
                                    value: lan,
                                    child: Text(lan.name),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        SizedBox(width: 70),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: DropdownButton<LanguageModel>(
                              dropdownColor: backgroundColor,
                              borderRadius: BorderRadius.circular(15),
                              underline: SizedBox.shrink(),
                              padding: EdgeInsets.zero,
                              icon: SizedBox.shrink(),
                              value: outputLanguage,
                              onChanged: (value) {
                                if (value == null) return;
                                outputLanguage = value;
                                setState(() {});
                              },
                              style: GoogleFonts.barlow(
                                color: whiteColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              items: languages
                                  .map(
                                    (lan) => DropdownMenuItem<LanguageModel>(
                                      value: lan,
                                      child: Text(lan.name),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          spreadRadius: 3,
                          offset: Offset(0, 10),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: CupertinoButton(
                      color: buttonColor,
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(100),
                      onPressed: () {
                        String input = inputController.text;
                        inputController.text = output;
                        output = input;
                        LanguageModel lan = inputLanguage;
                        inputLanguage = outputLanguage;
                        outputLanguage = lan;
                        setState(() {});
                      },
                      child: Image.asset(
                        "assets/reverse.png",
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ),
                ],
              ),

              // Input Part
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: inputCardColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        inputLanguage.name,
                        style: GoogleFonts.barlow(
                          color: greyTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: inputController,
                          focusNode: inputFocus,
                          onSubmitted: (val) {
                            perevod();
                          },
                          onTapOutside: (val) {
                            inputFocus.unfocus();
                            perevod();
                          },
                          maxLines: null,
                          textInputAction: TextInputAction.done,
                          style: GoogleFonts.barlow(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          cursorColor: Colors.white,
                          maxLength: 500,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counter: SizedBox.shrink(),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Spacer(),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              FlutterTts tts = FlutterTts();
                              tts.stop();
                              tts.setLanguage(inputLanguage.locale);
                              tts.speak(inputController.text);
                            },
                            child: Image.asset(
                              "assets/speaker.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Output Part
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: outputColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        outputLanguage.name,
                        style: GoogleFonts.barlow(
                          color: greyTextColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          output,
                          style: GoogleFonts.barlow(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      /// Display 3 buttons
                      Row(
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              FlutterClipboard.copy(output);
                            },
                            child: Image.asset(
                              "assets/copy.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Share.share("🌍 Translation 🌍\n\n"
                                  "🔹 From: ${inputLanguage.name}\n"
                                  "📝 ${inputController.text}\n\n"
                                  "🔹 To: ${outputLanguage.name}\n"
                                  "🗣️ $output\n\n"
                                  "📲 Shared via D4 Translator App");
                            },
                            child: Image.asset(
                              "assets/share.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          Spacer(),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              FlutterTts tts = FlutterTts();
                              tts.stop();
                              tts.setLanguage(outputLanguage.locale);
                              tts.speak(output);
                            },
                            child: Image.asset(
                              "assets/speaker.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Button
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  fixedSize: Size.fromHeight(55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {},
                child: Center(
                  child: Text(
                    "Translate",
                    style: GoogleFonts.barlow(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: whiteColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
