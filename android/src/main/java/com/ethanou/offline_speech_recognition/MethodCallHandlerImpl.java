package com.ethanou.offline_speech_recognition;

import android.app.Activity;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {
    private static final String PLUGIN_CHANNEL_NAME = "offline_speech_recognition";
    private static final String MESSAGE_CHANNEL_NAME = "offline_speech_recognition/message";

    private final Activity activity;
    private final BinaryMessenger messenger;
    private final MethodChannel methodChannel;
    private final EventChannel eventChannel;
    private @Nullable SpeechRecognitionModel speech;

    MethodCallHandlerImpl(Activity activity, BinaryMessenger messenger) {

        this.activity = activity;
        this.messenger = messenger;

        eventChannel = new EventChannel(messenger, MESSAGE_CHANNEL_NAME);
        methodChannel = new MethodChannel(messenger, PLUGIN_CHANNEL_NAME);
//        TODO: REIMPLEMENT INSIDE SPEECH RECOGNITION MODEL
//        eventChannel.setStreamHandler((EventChannel.StreamHandler) this);
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
                result.success(true);
                break;

            case "recognition.load":
                String path = call.argument("path");
                speech.load(path);
                result.success(true);
                break;

            case "recognition.start":
                speech.start();
                result.success(true);
                break;

            case "recognition.stop":
                speech.stop();
                result.success(true);
                break;

            case "recognition.destroy":
                speech.destroy();
                result.success(true);
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
