package com.stockswipe.stockswipe

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Fix Android 15 / Play Store warnings:
        // Tell the window not to fit system windows so content draws behind
        // the status bar and navigation bar (edge-to-edge).
        // This is the backward-compatible equivalent of enableEdgeToEdge() and
        // replaces the now-deprecated setStatusBarColor / setNavigationBarColor
        // APIs used by Flutter's legacy platform plugin.
        WindowCompat.setDecorFitsSystemWindows(window, false)
        super.onCreate(savedInstanceState)
    }
}

