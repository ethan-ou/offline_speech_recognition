package com.ethanou.offline_speech_recognition;

import android.app.Activity;
import android.util.EventLog;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {
    private static final String PLUGIN_CHANNEL_NAME = "offline_speech_recognition";
    private static final String RESULT_MESSAGE_CHANNEL_NAME = "offline_speech_recognition/result_message";
    private static final String PARTIAL_MESSAGE_CHANNEL_NAME = "offline_speech_recognition/result_partial";

    private final Activity activity;
    private final BinaryMessenger messenger;
    private final MethodChannel methodChannel;
    private final EventChannel resultEventChannel;
    private final EventChannel partialEventChannel;
    private @Nullable SpeechRecognitionModel speech;

    MethodCallHandlerImpl(Activity activity, BinaryMessenger messenger) {
        this.activity = activity;
        this.messenger = messenger;

        resultEventChannel = new EventChannel(messenger, RESULT_MESSAGE_CHANNEL_NAME);
        partialEventChannel = new EventChannel(messenger, PARTIAL_MESSAGE_CHANNEL_NAME);
        methodChannel = new MethodChannel(messenger, PLUGIN_CHANNEL_NAME);

        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "recognition.init":
                if (speech != null) {
                    speech.destroy();
                }
                speech = new SpeechRecognitionModel(activity);
                result.success(null);
                break;

            case "recognition.load":
                String path = call.argument("path");
                speech.load(path);
                result.success(null);
                break;

            case "recognition.start":
                speech.start(resultEventChannel, partialEventChannel);
                result.success(null);
                break;

            case "recognition.stop":
                speech.stop();
                result.success(null);
                break;

            case "recognition.destroy":
                speech.destroy();
                result.success(null);
                break;

            default:
                result.notImplemented();
                break;
        }
    }

    void stopListening() {
        methodChannel.setMethodCallHandler(null);
    }

    // We move catching CameraAccessException out of onMethodCall because it causes a crash
    // on plugin registration for sdks incompatible with Camera2 (< 21). We want this plugin to
    // to be able to compile with <21 sdks for apps that want the camera and support earlier version.
//    @SuppressWarnings("ConstantConditions")
//    private void handleException(Exception exception, Result result) {
//        if (exception instanceof CameraAccessException) {
//            result.error("CameraAccess", exception.getMessage(), null);
//            return;
//        }
//
//        // CameraAccessException can not be cast to a RuntimeException.
//        throw (RuntimeException) exception;
//    }

}
