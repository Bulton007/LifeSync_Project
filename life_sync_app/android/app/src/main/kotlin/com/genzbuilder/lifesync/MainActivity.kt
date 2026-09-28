package com.genzbuilder.lifesync

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioTrack
import kotlin.math.PI
import kotlin.math.exp
import kotlin.math.sin
import kotlin.random.Random

class MainActivity : FlutterFragmentActivity() {
    private var focusAudio: AudioTrack? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "lifesync/focus_audio")
            .setMethodCallHandler { call, result ->
                if (call.method != "play") {
                    result.notImplemented()
                } else {
                    try {
                        playFocusAudio(call.arguments as? String ?: "Focus Bell")
                        result.success(null)
                    } catch (error: Exception) {
                        result.error("AUDIO_UNAVAILABLE", "Unable to play focus audio", null)
                    }
                }
            }
    }

    private fun playFocusAudio(sound: String) {
        focusAudio?.release()
        focusAudio = null
        val sampleRate = 16000
        val samples = ShortArray(sampleRate * 2) { index ->
            val seconds = index.toDouble() / sampleRate
            val value = when (sound) {
                "Clock Ticking" -> {
                    val phase = seconds % 0.5
                    sin(2 * PI * 1800 * phase) * exp(-phase * 150)
                }
                "Gentle Rain" -> Random.nextDouble(-0.25, 0.25)
                "Meditation Gong" -> sin(2 * PI * 220 * seconds) * exp(-seconds * 1.8)
                "Completion Fanfare" -> {
                    val frequency = when {
                        seconds < 0.5 -> 523.25
                        seconds < 1.0 -> 659.25
                        else -> 783.99
                    }
                    sin(2 * PI * frequency * seconds) * 0.5
                }
                else -> sin(2 * PI * 880 * seconds) * exp(-seconds * 3)
            }
            (value * 10000).toInt().toShort()
        }
        val track = AudioTrack.Builder()
            .setAudioAttributes(AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_MEDIA)
                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC).build())
            .setAudioFormat(AudioFormat.Builder()
                .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                .setSampleRate(sampleRate)
                .setChannelMask(AudioFormat.CHANNEL_OUT_MONO).build())
            .setTransferMode(AudioTrack.MODE_STATIC)
            .setBufferSizeInBytes(samples.size * 2).build()
        focusAudio = track
        track.write(samples, 0, samples.size)
        track.play()
    }

    override fun onDestroy() {
        focusAudio?.release()
        focusAudio = null
        super.onDestroy()
    }
}
