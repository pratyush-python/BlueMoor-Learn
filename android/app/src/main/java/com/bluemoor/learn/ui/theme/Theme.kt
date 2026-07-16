package com.bluemoor.learn.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

val Background = Color(0xFF0A0E1A)
val Surface = Color(0xFF121826)
val SurfaceElevated = Color(0xFF1A2233)
val HistoryGold = Color(0xFFC9A26B)
val CosmosCyan = Color(0xFF5CE1E6)
val TextPrimary = Color.White
val TextSecondary = Color(0xFFA0AEC0)
val TextTertiary = Color(0xFF64748B)
val Success = Color(0xFF34D399)
val Warning = Color(0xFFFBBF24)

private val DarkColors = darkColorScheme(
    primary = CosmosCyan,
    secondary = HistoryGold,
    background = Background,
    surface = Surface,
    onPrimary = Background,
    onSecondary = Background,
    onBackground = TextPrimary,
    onSurface = TextPrimary,
)

@Composable
fun BlueMoorTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = DarkColors,
        content = content,
    )
}
