package com.ethanou.offline_speech_recognition;

import android.app.Activity;
import android.content.Context;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** OfflineSpeechRecognitionPlugin */
public class OfflineSpeechRecognitionPlugin implements FlutterPlugin, ActivityAware {
  private @Nullable FlutterPluginBinding flutterBinding;
  private @Nullable MethodCallHandlerImpl methodCallHandler;

  @SuppressWarnings("deprecation")
  public static void registerWith(Registrar registrar) {
    OfflineSpeechRecognitionPlugin plugin = new OfflineSpeechRecognitionPlugin();
    plugin.startListening(registrar.activity(), registrar.messenger());
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    this.flutterBinding = binding;
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    this.flutterBinding = null;
  }

  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    assert flutterBinding != null;
    startListening(binding.getActivity(), flutterBinding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromActivity() {
    if (methodCallHandler == null) {
      // Could be on too low of an SDK to have started listening originally.
      return;
    }

    methodCallHandler.stopListening();
    methodCallHandler = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  private void startListening(Activity activity, BinaryMessenger messenger) {
    methodCallHandler = new MethodCallHandlerImpl(activity, messenger);
  }


}
