package com.ethanou.offline_speech_recognition;

import android.app.Activity;
import android.util.EventLog;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.io.IOException;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {
    private static final String PLUGIN_CHANNEL_NAME = "offline_speech_recognition";
    private static final String RESULT_MESSAGE_CHANNEL_NAME = "offline_speech_recognition/result_message";
    private static final String PARTIAL_MESSAGE_CHANNEL_NAME = "offline_speech_recognition/partial_message";

    private final Activity activity;
    private final BinaryMessenger messenger;
    private final MethodChannel methodChannel;
    private final EventChannel resultEventChannel;
    private final EventChannel partialEventChannel;
    private EventChannel.EventSink resultEvent;
    private EventChannel.EventSink partialEvent;
    private @Nullable SpeechRecognitionModel speech;

    MethodCallHandlerImpl(Activity activity, BinaryMessenger messenger) {
        this.activity = activity;
        this.messenger = messenger;

        resultEventChannel = new EventChannel(messenger, RESULT_MESSAGE_CHANNEL_NAME);
        partialEventChannel = new EventChannel(messenger, PARTIAL_MESSAGE_CHANNEL_NAME);
        methodChannel = new MethodChannel(messenger, PLUGIN_CHANNEL_NAME);

        methodChannel.setMethodCallHandler(this);
        initEventChannels();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            // Load initialises the model and checks for permissions. The model needs to be downloaded at this point
            // to be initialised.
            case "recognition.load":
                if (speech != null) {
                    speech.destroy();
                }
                speech = new SpeechRecognitionModel(activity, resultEvent, partialEvent);
                String path = call.argument("path");

                // Handling of exceptions should happen here.
                try {
                    speech.load(path);
                } catch (Exception e) {
                    result.error("Runtime Exception", e.getMessage(), e);
                    break;
                }

                result.success(null);
                break;

            // Start allows the model to be started.
            case "recognition.start":
                try {
                    speech.start();
                } catch (IOException e) {
                    result.error("IO Exception", e.getMessage(), e);
                    break;
                }

                result.success(null);
                break;
            
            // Stop is for stopping the speech recognition model. Unlike destroy, it allows the model to be started again.
            case "recognition.stop":
                speech.stop();
                result.success(null);
                break;

            // Destroy is for completely removing the speech recognition model.
            case "recognition.destroy":
                speech.destroy();
                result.success(null);
                break;

            default:
                result.notImplemented();
                break;
        }
    }

    public void stopListening() {
        methodChannel.setMethodCallHandler(null);
        resultEventChannel.setStreamHandler(null);
        partialEventChannel.setStreamHandler(null);
    }

    private void initEventChannels() {
        resultEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                resultEvent = events;
            }

            @Override
            public void onCancel(Object arguments) {
                resultEvent = null;
            }
        });

        partialEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                partialEvent = events;
            }

            @Override
            public void onCancel(Object arguments) {
                partialEvent = null;
            }
        });
    }
}
