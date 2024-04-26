import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var txtSpeech = "Click on MIC to start recording";
  SpeechToText speechToText = SpeechToText();
  var isListening = false;

  void checkMic() async {
    bool micAvailable = await speechToText.initialize();
    if (micAvailable) {
      print("Microphone is available");
    } else {
      print("Microphone is not available");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(txtSpeech),
              GestureDetector(
                onTap: () async {
                  if (!isListening) {
                    bool micAvailable = await speechToText.initialize();
                    if (micAvailable) {
                      setState(() {
                        isListening = true;
                      });
                      speechToText.listen(
                        listenFor: const Duration(seconds: 5),
                        onResult: (result) {
                          setState(() {
                            txtSpeech = result.recognizedWords;
                            isListening = false;
                          });
                        },
                      );
                    }
                  } else {
                    setState(() {
                      isListening = false;
                      speechToText.stop();
                    });
                  }
                },
                child: CircleAvatar(
                  child: isListening
                      ? const Icon(Icons.record_voice_over)
                      : const Icon(Icons.mic),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
