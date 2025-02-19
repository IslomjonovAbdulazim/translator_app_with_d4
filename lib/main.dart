import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_cloud_translation/google_cloud_translation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translator_app_with_d4/language_model.dart';

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

              // Output Part

              // Button
            ],
          ),
        ),
      ),
    );
  }
}
