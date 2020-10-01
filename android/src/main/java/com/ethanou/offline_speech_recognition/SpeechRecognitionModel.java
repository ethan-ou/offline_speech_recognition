package com.ethanou.offline_speech_recognition;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.util.Log;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import org.kaldi.KaldiRecognizer;
import org.kaldi.Model;
import org.kaldi.RecognitionListener;
import org.kaldi.SpeechService;
import org.kaldi.Vosk;

import java.io.IOException;
import java.util.concurrent.Callable;

import io.flutter.plugin.common.EventChannel;


public class SpeechRecognitionModel implements RecognitionListener {
    private Model model;
    private SpeechService speechService;
    private TaskRunner taskRunner;
    private Activity activity;
    private EventChannel.EventSink resultEvent;
    private EventChannel.EventSink partialEvent;

    public SpeechRecognitionModel(final Activity activity) {
        this.activity = activity;
    }

    private class ErrorHandler implements TaskRunner.ErrorHandler {
        @Override
        public void onError(Object error) {
            onError(error);
        }
    }

    public void load(String path) {
        Permissions.check(activity);

        if (taskRunner == null) {
            taskRunner = new TaskRunner();
        }

        // Recognizer initialization is a time-consuming and it involves IO,
        // so we execute it in a Runnable
        try {
            taskRunner.executeAsync(new SetupTask(path), new TaskRunner.Callback<Model>() {
                @Override
                public void onComplete(Model result) {
                    model = result;
                }
            }, new ErrorHandler());

            KaldiRecognizer rec = new KaldiRecognizer(model, 16000.0f);
            speechService = new SpeechService(rec, 16000.0f);
            speechService.addListener(this);
        } catch(Exception e) {
            onError(e);
        }

    }

    private static class SetupTask implements Callable<Model> {
        private final String path;

        public SetupTask(String path) {
            this.path = path;
        }

        @Override
        public Model call() {
            Vosk.SetLogLevel(0);
            return new Model(path);
        }
    }

    public void start(EventChannel resultEventChannel, EventChannel partialEventChannel) {
        initEventChannels(resultEventChannel, partialEventChannel);

        speechService.startListening();

    }

    public void stop() {
        destroyEventChannels();

        if (speechService != null) {
            speechService.stop();
            speechService.shutdown();
        }
    }

    public void destroy() {
        if (speechService != null) {
            speechService.cancel();
            speechService.shutdown();
        }
        speechService = null;
    }

    @Override
    public void onResult(String hypothesis) {
        if (resultEvent != null) {
            resultEvent.success(hypothesis);
        }
    }

    @Override
    public void onPartialResult(String hypothesis) {
        if (partialEvent != null) {
            partialEvent.success(hypothesis);
        }
    }

    @Override
    public void onError(Exception e) {

    }

    @Override
    public void onTimeout() {
        speechService.cancel();
        speechService = null;
    }

    private void initEventChannels(EventChannel resultEventChannel, EventChannel partialEventChannel) {
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

    private void destroyEventChannels() {
        resultEvent.endOfStream();
        partialEvent.endOfStream();
        resultEvent = null;
        partialEvent = null;
    }
}
