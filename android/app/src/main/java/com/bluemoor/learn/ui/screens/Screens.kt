package com.bluemoor.learn.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.AutoAwesome
import androidx.compose.material.icons.filled.BarChart
import androidx.compose.material.icons.filled.CheckCircle
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.MenuBook
import androidx.compose.material.icons.filled.Public
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FilterChipDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationBarItemDefaults
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.bluemoor.learn.data.ContentRepository
import com.bluemoor.learn.data.Lesson
import com.bluemoor.learn.data.LessonCategory
import com.bluemoor.learn.data.LessonDepth
import com.bluemoor.learn.data.ProgressStore
import com.bluemoor.learn.data.UserProgress
import com.bluemoor.learn.ui.theme.Background
import com.bluemoor.learn.ui.theme.CosmosCyan
import com.bluemoor.learn.ui.theme.HistoryGold
import com.bluemoor.learn.ui.theme.Success
import com.bluemoor.learn.ui.theme.Surface
import com.bluemoor.learn.ui.theme.SurfaceElevated
import com.bluemoor.learn.ui.theme.TextSecondary
import com.bluemoor.learn.ui.theme.TextTertiary
import com.bluemoor.learn.ui.theme.Warning
import kotlinx.coroutines.launch

enum class AppTab(val label: String, val icon: ImageVector) {
    TODAY("Today", Icons.Default.Home),
    HISTORY("History", Icons.Default.MenuBook),
    COSMOS("Cosmos", Icons.Default.AutoAwesome),
    PROGRESS("Progress", Icons.Default.BarChart),
}

@Composable
fun OnboardingScreen(store: ProgressStore, onDone: () -> Unit) {
    var selected by remember { mutableStateOf(LessonDepth.STANDARD) }
    val scope = rememberCoroutineScope()
    Column(
        Modifier
            .fillMaxSize()
            .background(Background)
            .padding(28.dp),
        verticalArrangement = Arrangement.Center,
    ) {
        Text("Blue Moor - Learn", color = CosmosCyan, fontSize = 28.sp, fontWeight = FontWeight.Bold)
        Spacer(modifier = Modifier.height(8.dp))
        Text(
            "History. Cosmos. Mastery.\nPick a default lesson depth to begin.",
            color = TextSecondary,
            fontSize = 16.sp,
        )
        Spacer(modifier = Modifier.height(24.dp))
        LessonDepth.entries.forEach { depth ->
            FilterChip(
                selected = selected == depth,
                onClick = { selected = depth },
                label = { Text("${depth.label} · ${depth.minutes} min · ${depth.xp} XP") },
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 4.dp),
                colors = FilterChipDefaults.filterChipColors(
                    selectedContainerColor = SurfaceElevated,
                    selectedLabelColor = CosmosCyan,
                    containerColor = Surface,
                    labelColor = TextSecondary,
                ),
            )
        }
        Spacer(modifier = Modifier.height(28.dp))
        Button(
            onClick = {
                scope.launch {
                    store.completeOnboarding(selected)
                    onDone()
                }
            },
            modifier = Modifier.fillMaxWidth(),
            colors = ButtonDefaults.buttonColors(containerColor = CosmosCyan, contentColor = Background),
        ) {
            Text("Start learning", fontWeight = FontWeight.SemiBold)
        }
        Spacer(modifier = Modifier.height(12.dp))
        Text(
            "Educational content only. Blue Moor is not SEBI-registered.",
            color = TextTertiary,
            fontSize = 12.sp,
        )
    }
}

@Composable
fun MainShell(
    progress: UserProgress,
    store: ProgressStore,
    onOpenLesson: (Lesson) -> Unit,
) {
    var tab by remember { mutableStateOf(AppTab.TODAY) }
    Scaffold(
        containerColor = Background,
        bottomBar = {
            NavigationBar(containerColor = Surface) {
                AppTab.entries.forEach { t ->
                    NavigationBarItem(
                        selected = tab == t,
                        onClick = { tab = t },
                        icon = { Icon(t.icon, contentDescription = t.label) },
                        label = { Text(t.label) },
                        colors = NavigationBarItemDefaults.colors(
                            selectedIconColor = CosmosCyan,
                            selectedTextColor = CosmosCyan,
                            indicatorColor = SurfaceElevated,
                            unselectedIconColor = TextTertiary,
                            unselectedTextColor = TextTertiary,
                        ),
                    )
                }
            }
        },
    ) { padding ->
        Box(modifier = Modifier.padding(padding)) {
            when (tab) {
                AppTab.TODAY -> TodayScreen(progress, onOpenLesson)
                AppTab.HISTORY -> LibraryScreen(LessonCategory.HISTORY, progress, onOpenLesson)
                AppTab.COSMOS -> LibraryScreen(LessonCategory.COSMOS, progress, onOpenLesson)
                AppTab.PROGRESS -> ProgressScreen(progress)
            }
        }
    }
}

@Composable
fun TodayScreen(progress: UserProgress, onOpenLesson: (Lesson) -> Unit) {
    val lessonCount = ContentRepository.allLessons.size
    val recommended = remember(progress, lessonCount) {
        if (lessonCount == 0) null else ContentRepository.recommended(progress)
    }
    val fact = remember { ContentRepository.todaysFact() }
    Column(
        Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(20.dp),
    ) {
        Text("Blue Moor - Learn", color = CosmosCyan, fontSize = 14.sp, fontWeight = FontWeight.Medium)
        Text(greeting(), color = Color.White, fontSize = 32.sp, fontWeight = FontWeight.SemiBold)
        Text(
            if (lessonCount > 0) {
                "$lessonCount lessons from shared catalog · history & cosmos."
            } else {
                "No lessons loaded. Check assets/lessons.json."
            },
            color = TextSecondary,
            fontSize = 15.sp,
        )
        Spacer(modifier = Modifier.height(20.dp))
        Card(
            colors = CardDefaults.cardColors(containerColor = Surface),
            shape = RoundedCornerShape(16.dp),
            modifier = Modifier.fillMaxWidth(),
        ) {
            Row(
                Modifier.padding(20.dp),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(20.dp),
            ) {
                Box(contentAlignment = Alignment.Center, modifier = Modifier.size(96.dp)) {
                    Box(
                        Modifier
                            .size(96.dp)
                            .clip(CircleShape)
                            .background(SurfaceElevated),
                    )
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Text("${progress.currentStreak}", color = Color.White, fontSize = 32.sp, fontWeight = FontWeight.Bold)
                        Text("day streak", color = TextSecondary, fontSize = 11.sp)
                    }
                }
                Column(modifier = Modifier.weight(1f)) {
                    Text("Level ${progress.level}", color = Color.White, fontSize = 20.sp, fontWeight = FontWeight.SemiBold)
                    Text("${progress.totalXp} XP", color = CosmosCyan, fontSize = 14.sp)
                    Spacer(modifier = Modifier.height(8.dp))
                    LinearProgressIndicator(
                        progress = { progress.progressToNextLevel() },
                        modifier = Modifier
                            .fillMaxWidth()
                            .height(8.dp)
                            .clip(RoundedCornerShape(8.dp)),
                        color = CosmosCyan,
                        trackColor = SurfaceElevated,
                    )
                    Text(
                        "${progress.xpToNextLevel()} XP to Level ${progress.level + 1}",
                        color = TextTertiary,
                        fontSize = 12.sp,
                        modifier = Modifier.padding(top = 6.dp),
                    )
                }
            }
        }
        if (fact != null) {
            Spacer(modifier = Modifier.height(16.dp))
            Card(
                colors = CardDefaults.cardColors(containerColor = Surface),
                shape = RoundedCornerShape(16.dp),
                modifier = Modifier.fillMaxWidth(),
            ) {
                Column(Modifier.padding(18.dp)) {
                    Text("TODAY IN CURIOSITY", color = HistoryGold, fontSize = 11.sp, fontWeight = FontWeight.Bold)
                    Text(fact.title, color = Color.White, fontSize = 16.sp, fontWeight = FontWeight.SemiBold, modifier = Modifier.padding(top = 6.dp))
                    Text(fact.text, color = TextSecondary, fontSize = 14.sp, modifier = Modifier.padding(top = 6.dp))
                }
            }
        }
        Spacer(modifier = Modifier.height(24.dp))
        Text("Recommended for you", color = Color.White, fontSize = 20.sp, fontWeight = FontWeight.SemiBold)
        Spacer(modifier = Modifier.height(12.dp))
        if (recommended != null) {
            LessonCard(recommended, showCategory = true) { onOpenLesson(recommended) }
        } else {
            Text("Catalog empty.", color = TextTertiary)
        }
    }
}

@Composable
fun LibraryScreen(
    category: LessonCategory,
    progress: UserProgress,
    onOpenLesson: (Lesson) -> Unit,
) {
    val lessons = ContentRepository.lessons(category)
    val accent = if (category == LessonCategory.HISTORY) HistoryGold else CosmosCyan
    LazyColumn(
        contentPadding = PaddingValues(20.dp),
        verticalArrangement = Arrangement.spacedBy(14.dp),
        modifier = Modifier
            .fillMaxSize()
            .background(Background),
    ) {
        item {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(Icons.Default.Public, null, tint = accent)
                Spacer(modifier = Modifier.size(8.dp))
                Text(category.label, color = Color.White, fontSize = 28.sp, fontWeight = FontWeight.SemiBold)
            }
            Text("${lessons.size} lessons", color = TextSecondary, fontSize = 14.sp)
            Spacer(modifier = Modifier.height(8.dp))
        }
        items(lessons, key = { it.id }) { lesson ->
            val done = progress.completedDepths[lesson.id].orEmpty().size
            LessonCard(lesson, subtitleExtra = if (done > 0) "$done depth(s) done" else null) {
                onOpenLesson(lesson)
            }
        }
    }
}

@Composable
fun ProgressScreen(progress: UserProgress) {
    Column(
        Modifier
            .fillMaxSize()
            .background(Background)
            .padding(20.dp),
    ) {
        Text("Progress", color = Color.White, fontSize = 28.sp, fontWeight = FontWeight.SemiBold)
        Spacer(modifier = Modifier.height(16.dp))
        StatCard("Total XP", "${progress.totalXp}", Warning)
        Spacer(modifier = Modifier.height(10.dp))
        StatCard("Level", "${progress.level}", CosmosCyan)
        Spacer(modifier = Modifier.height(10.dp))
        StatCard("Current streak", "${progress.currentStreak} days", HistoryGold)
        Spacer(modifier = Modifier.height(10.dp))
        StatCard("Longest streak", "${progress.longestStreak} days", HistoryGold)
        Spacer(modifier = Modifier.height(20.dp))
        Text(
            "Preferred depth: ${progress.preferredDepth.label}",
            color = TextSecondary,
        )
    }
}

@Composable
private fun StatCard(title: String, value: String, color: Color) {
    Card(
        colors = CardDefaults.cardColors(containerColor = Surface),
        shape = RoundedCornerShape(16.dp),
        modifier = Modifier.fillMaxWidth(),
    ) {
        Column(modifier = Modifier.padding(18.dp)) {
            Text(title, color = TextSecondary, fontSize = 13.sp)
            Text(value, color = color, fontSize = 26.sp, fontWeight = FontWeight.Bold)
        }
    }
}

@Composable
fun LessonCard(
    lesson: Lesson,
    showCategory: Boolean = false,
    subtitleExtra: String? = null,
    onClick: () -> Unit,
) {
    val accent = if (lesson.category == LessonCategory.HISTORY) HistoryGold else CosmosCyan
    Card(
        onClick = onClick,
        colors = CardDefaults.cardColors(containerColor = Surface),
        shape = RoundedCornerShape(16.dp),
        modifier = Modifier.fillMaxWidth(),
    ) {
        Column {
            Box(
                Modifier
                    .fillMaxWidth()
                    .height(88.dp)
                    .background(
                        Brush.horizontalGradient(listOf(accent.copy(alpha = 0.35f), Background)),
                    ),
                contentAlignment = Alignment.BottomStart,
            ) {
                if (showCategory) {
                    Text(
                        lesson.category.label.uppercase(),
                        color = accent,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.padding(16.dp),
                    )
                }
            }
            Column(modifier = Modifier.padding(16.dp)) {
                Text(lesson.title, color = Color.White, fontSize = 18.sp, fontWeight = FontWeight.SemiBold)
                Text(lesson.eraOrTopic, color = TextSecondary, fontSize = 13.sp)
                val tags = listOfNotNull(lesson.era, lesson.region).joinToString(" · ")
                if (tags.isNotBlank()) {
                    Text(tags, color = TextTertiary, fontSize = 11.sp, modifier = Modifier.padding(top = 4.dp))
                }
                Text(
                    lesson.subtitle,
                    color = TextTertiary,
                    fontSize = 13.sp,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis,
                    modifier = Modifier.padding(top = 4.dp),
                )
                if (subtitleExtra != null) {
                    Text(subtitleExtra, color = CosmosCyan, fontSize = 12.sp, modifier = Modifier.padding(top = 6.dp))
                }
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun LessonDetailScreen(
    lesson: Lesson,
    progress: UserProgress,
    store: ProgressStore,
    onBack: () -> Unit,
    onOpenQuiz: () -> Unit,
) {
    var depth by remember { mutableStateOf(progress.preferredDepth) }
    val scope = rememberCoroutineScope()
    var lastXp by remember { mutableStateOf<Int?>(null) }
    val completed = progress.completedDepths[lesson.id].orEmpty()

    Scaffold(
        containerColor = Background,
        topBar = {
            TopAppBar(
                title = { Text(lesson.title, maxLines = 1, overflow = TextOverflow.Ellipsis) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back")
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = Background,
                    titleContentColor = Color.White,
                    navigationIconContentColor = Color.White,
                ),
            )
        },
    ) { padding ->
        Column(
            Modifier
                .padding(padding)
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
                .padding(20.dp),
        ) {
            Text(lesson.eraOrTopic, color = TextSecondary)
            Text(lesson.subtitle, color = TextTertiary, modifier = Modifier.padding(top = 4.dp))
            Spacer(modifier = Modifier.height(16.dp))
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                LessonDepth.entries.forEach { d ->
                    FilterChip(
                        selected = depth == d,
                        onClick = { depth = d },
                        label = { Text(d.label) },
                        colors = FilterChipDefaults.filterChipColors(
                            selectedContainerColor = SurfaceElevated,
                            selectedLabelColor = CosmosCyan,
                            containerColor = Surface,
                            labelColor = TextSecondary,
                        ),
                    )
                }
            }
            Spacer(modifier = Modifier.height(16.dp))
            Text(lesson.contentFor(depth), color = Color.White, fontSize = 15.sp, lineHeight = 22.sp)
            Spacer(modifier = Modifier.height(20.dp))
            Text("Timeline", color = CosmosCyan, fontWeight = FontWeight.SemiBold, fontSize = 18.sp)
            lesson.timeline.forEach { e ->
                Text("${e.year} — ${e.title}", color = HistoryGold, fontWeight = FontWeight.Medium, modifier = Modifier.padding(top = 10.dp))
                Text(e.description, color = TextSecondary, fontSize = 13.sp)
            }
            Spacer(modifier = Modifier.height(16.dp))
            Text("Key figures", color = CosmosCyan, fontWeight = FontWeight.SemiBold, fontSize = 18.sp)
            lesson.keyFigures.forEach { f ->
                Text(f.name, color = Color.White, fontWeight = FontWeight.SemiBold, modifier = Modifier.padding(top = 10.dp))
                Text("${f.role} · ${f.shortBio}", color = TextSecondary, fontSize = 13.sp)
            }
            Spacer(modifier = Modifier.height(24.dp))
            Button(
                onClick = {
                    scope.launch {
                        lastXp = store.completeDepth(lesson.id, depth, progress)
                    }
                },
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(containerColor = CosmosCyan, contentColor = Background),
            ) {
                val already = completed.contains(depth.name)
                Text(if (already) "Mark ${depth.label} again (+${depth.xp} XP)" else "Complete ${depth.label} (+${depth.xp} XP)")
            }
            if (lastXp != null) {
                Text("+$lastXp XP earned", color = Success, modifier = Modifier.padding(top = 8.dp))
            }
            Spacer(modifier = Modifier.height(10.dp))
            Button(
                onClick = onOpenQuiz,
                modifier = Modifier.fillMaxWidth(),
                colors = ButtonDefaults.buttonColors(containerColor = SurfaceElevated, contentColor = CosmosCyan),
            ) {
                Text("Take quiz")
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun QuizScreen(
    lesson: Lesson,
    progress: UserProgress,
    store: ProgressStore,
    onBack: () -> Unit,
) {
    var index by remember { mutableIntStateOf(0) }
    var selected by remember { mutableStateOf<Int?>(null) }
    var correctCount by remember { mutableIntStateOf(0) }
    var finished by remember { mutableStateOf(false) }
    val scope = rememberCoroutineScope()
    val q = lesson.quiz.getOrNull(index)

    Scaffold(
        containerColor = Background,
        topBar = {
            TopAppBar(
                title = { Text("Quiz · ${lesson.title}", maxLines = 1, overflow = TextOverflow.Ellipsis) },
                navigationIcon = {
                    IconButton(onClick = onBack) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, null)
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = Background,
                    titleContentColor = Color.White,
                    navigationIconContentColor = Color.White,
                ),
            )
        },
    ) { padding ->
        Column(
            Modifier
                .padding(padding)
                .fillMaxSize()
                .padding(20.dp),
        ) {
            if (finished || q == null) {
                val score = if (lesson.quiz.isEmpty()) 0f else correctCount.toFloat() / lesson.quiz.size
                Text("Quiz complete", color = Color.White, fontSize = 24.sp, fontWeight = FontWeight.Bold)
                Text(
                    "Score: ${(score * 100).toInt()}% ($correctCount / ${lesson.quiz.size})",
                    color = if (score >= 0.8f) Warning else Success,
                    fontSize = 18.sp,
                    modifier = Modifier.padding(top = 12.dp),
                )
                Spacer(modifier = Modifier.height(20.dp))
                Button(
                    onClick = {
                        scope.launch {
                            store.recordQuiz(lesson.id, score, progress)
                            onBack()
                        }
                    },
                    colors = ButtonDefaults.buttonColors(containerColor = CosmosCyan, contentColor = Background),
                ) {
                    Text("Done")
                }
            } else {
                Text("Question ${index + 1} of ${lesson.quiz.size}", color = TextSecondary)
                Text(q.question, color = Color.White, fontSize = 20.sp, fontWeight = FontWeight.SemiBold, modifier = Modifier.padding(vertical = 16.dp))
                q.options.forEachIndexed { i, option ->
                    val bg = when {
                        selected == null -> Surface
                        i == q.correctAnswerIndex -> Success.copy(alpha = 0.25f)
                        selected == i -> SurfaceElevated
                        else -> Surface
                    }
                    Card(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 6.dp)
                            .clickable(enabled = selected == null) {
                                selected = i
                                if (i == q.correctAnswerIndex) correctCount += 1
                            },
                        colors = CardDefaults.cardColors(containerColor = bg),
                        shape = RoundedCornerShape(12.dp),
                    ) {
                        Row(
                            Modifier.padding(16.dp),
                            verticalAlignment = Alignment.CenterVertically,
                        ) {
                            Text(option, color = Color.White, modifier = Modifier.weight(1f))
                            if (selected != null && i == q.correctAnswerIndex) {
                                Icon(Icons.Default.CheckCircle, null, tint = Success)
                            }
                        }
                    }
                }
                if (selected != null) {
                    Text(q.explanation, color = TextSecondary, modifier = Modifier.padding(top = 12.dp))
                    Spacer(modifier = Modifier.height(16.dp))
                    Button(
                        onClick = {
                            if (index >= lesson.quiz.lastIndex) {
                                finished = true
                            } else {
                                index += 1
                                selected = null
                            }
                        },
                        colors = ButtonDefaults.buttonColors(containerColor = CosmosCyan, contentColor = Background),
                    ) {
                        Text(if (index >= lesson.quiz.lastIndex) "See results" else "Next")
                    }
                }
            }
        }
    }
}

private fun greeting(): String {
    val hour = java.util.Calendar.getInstance().get(java.util.Calendar.HOUR_OF_DAY)
    return when (hour) {
        in 5..11 -> "Good morning."
        in 12..16 -> "Good afternoon."
        else -> "Good evening."
    }
}
