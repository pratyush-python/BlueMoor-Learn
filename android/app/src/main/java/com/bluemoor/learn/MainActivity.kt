package com.bluemoor.learn

import android.os.Bundle
import android.view.WindowManager
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Surface
import androidx.compose.runtime.SideEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import com.bluemoor.learn.data.ContentRepository
import com.bluemoor.learn.data.Lesson
import com.bluemoor.learn.data.ProgressStore
import com.bluemoor.learn.ui.screens.LessonDetailScreen
import com.bluemoor.learn.ui.screens.MainShell
import com.bluemoor.learn.ui.screens.OnboardingScreen
import com.bluemoor.learn.ui.screens.QuizScreen
import com.bluemoor.learn.ui.theme.Background
import com.bluemoor.learn.ui.theme.BlueMoorTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        val store = ProgressStore(applicationContext)

        setContent {
            BlueMoorTheme {
                Surface(modifier = Modifier.fillMaxSize(), color = Background) {
                    val progress by store.progressFlow.collectAsState()
                    var selectedLesson by remember { mutableStateOf<Lesson?>(null) }
                    var showQuiz by remember { mutableStateOf(false) }

                    // Screenshots OK on lessons/home; blocked only while a quiz is open.
                    SideEffect {
                        if (showQuiz) {
                            window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        } else {
                            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        }
                    }

                    when {
                        !progress.hasOnboarded -> {
                            OnboardingScreen(store) { /* flow updates via encrypted store */ }
                        }
                        showQuiz && selectedLesson != null -> {
                            QuizScreen(
                                lesson = selectedLesson!!,
                                progress = progress,
                                store = store,
                                onBack = { showQuiz = false },
                            )
                        }
                        selectedLesson != null -> {
                            LessonDetailScreen(
                                lesson = selectedLesson!!,
                                progress = progress,
                                store = store,
                                onBack = {
                                    selectedLesson = null
                                    showQuiz = false
                                },
                                onOpenQuiz = { showQuiz = true },
                            )
                        }
                        else -> {
                            MainShell(
                                progress = progress,
                                store = store,
                                onOpenLesson = { lesson ->
                                    selectedLesson = ContentRepository.lesson(lesson.id) ?: lesson
                                },
                            )
                        }
                    }
                }
            }
        }
    }
}
