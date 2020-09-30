package com.ethanou.offline_speech_recognition;

import android.os.Handler;
import android.os.Looper;

import java.util.concurrent.Callable;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

public class TaskRunner {
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final Executor executor = Executors.newSingleThreadExecutor();

    public interface Callback<R> {
        void onComplete(R result);
    }

    public interface ErrorHandler<Exception> {
        void onError(Exception error);
    }

    public <R> void executeAsync(Callable<R> callable, Callback<R> callback, ErrorHandler<Exception> error) {
        try {
            executor.execute(new RunnableTask<R>(handler, callable, callback, error));
        } catch (Exception e) {
            error.onError(e);
        }
    }

    public static class RunnableTask<R> implements Runnable {
        private final Handler handler;
        private final Callable<R> callable;
        private final Callback<R> callback;
        private final ErrorHandler<Exception> error;

        public RunnableTask(Handler handler, Callable<R> callable, Callback<R> callback, ErrorHandler<Exception> error) {
            this.handler = handler;
            this.callable = callable;
            this.callback = callback;
            this.error = error;
        }

        @Override
        public void run() {
            try {
                final R result = callable.call();
                handler.post(new RunnableTaskForHandler<>(result, callback));
            } catch (Exception e) {
                error.onError(e);
            }
        }
    }

    public static class RunnableTaskForHandler<R> implements Runnable {
        private Callback<R> callback;
        private R result;

        public RunnableTaskForHandler(R result, Callback<R> callback) {
            this.result = result;
            this.callback = callback;
        }

        @Override
        public void run() {
            callback.onComplete(result);
        }
    }
};