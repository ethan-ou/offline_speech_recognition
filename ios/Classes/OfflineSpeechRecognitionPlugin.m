#import "OfflineSpeechRecognitionPlugin.h"
#if __has_include(<offline_speech_recognition/offline_speech_recognition-Swift.h>)
#import <offline_speech_recognition/offline_speech_recognition-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "offline_speech_recognition-Swift.h"
#endif

@implementation OfflineSpeechRecognitionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOfflineSpeechRecognitionPlugin registerWithRegistrar:registrar];
}
@end
