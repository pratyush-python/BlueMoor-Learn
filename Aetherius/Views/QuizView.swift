import SwiftUI

struct QuizView: View {
    let lesson: Lesson
    var onComplete: (Double) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int?
    @State private var showExplanation = false
    @State private var score: Double = 0
    @State private var answeredCorrectly: [Bool] = []
    
    private var currentQuestion: QuizQuestion {
        lesson.quiz[currentQuestionIndex]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Quiz: \(lesson.title)")
                    .font(.title3.weight(.semibold))
                Spacer()
                Text("\(currentQuestionIndex + 1) / \(lesson.quiz.count)")
                    .foregroundStyle(AetheriusTheme.textSecondary)
            }
            .padding(24)
            .background(.ultraThinMaterial)
            
            if currentQuestionIndex < lesson.quiz.count {
                questionContent
            } else {
                resultsView
            }
        }
        .frame(width: 620, height: 520)
        .background(AetheriusTheme.background)
    }
    
    private var questionContent: some View {
        VStack(alignment: .leading, spacing: 28) {
            Text(currentQuestion.question)
                .font(.title2.weight(.medium))
                .foregroundStyle(.white)
                .padding(.top, 12)
            
            VStack(spacing: 12) {
                ForEach(Array(currentQuestion.options.enumerated()), id: \.offset) { index, option in
                    Button {
                        selectAnswer(index)
                    } label: {
                        HStack {
                            Text(option)
                                .foregroundStyle(.white)
                            Spacer()
                            
                            if showExplanation {
                                if index == currentQuestion.correctAnswerIndex {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(AetheriusTheme.success)
                                } else if index == selectedAnswer {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.red)
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(backgroundForOption(at: index))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    .disabled(showExplanation)
                }
            }
            
            if showExplanation {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Explanation")
                        .font(.headline)
                        .foregroundStyle(AetheriusTheme.cosmosCyan)
                    Text(currentQuestion.explanation)
                        .foregroundStyle(AetheriusTheme.textSecondary)
                }
                .padding(20)
                .background(AetheriusTheme.surfaceElevated)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button {
                    nextQuestion()
                } label: {
                    Text(currentQuestionIndex == lesson.quiz.count - 1 ? "See Results" : "Next Question")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(lesson.category.accentColor)
                .controlSize(.large)
                .padding(.top, 12)
            } else {
                Button {
                    checkAnswer()
                } label: {
                    Text("Check Answer")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(lesson.category.accentColor)
                .disabled(selectedAnswer == nil)
                .controlSize(.large)
            }
            
            Spacer()
        }
        .padding(32)
    }
    
    private func backgroundForOption(at index: Int) -> Color {
        if !showExplanation {
            return selectedAnswer == index ? AetheriusTheme.surfaceElevated : AetheriusTheme.surface
        }
        
        if index == currentQuestion.correctAnswerIndex {
            return AetheriusTheme.success.opacity(0.2)
        } else if index == selectedAnswer {
            return Color.red.opacity(0.2)
        } else {
            return AetheriusTheme.surface
        }
    }
    
    private func selectAnswer(_ index: Int) {
        withAnimation(.easeInOut(duration: 0.15)) {
            selectedAnswer = index
        }
    }
    
    private func checkAnswer() {
        guard let selected = selectedAnswer else { return }
        
        let isCorrect = selected == currentQuestion.correctAnswerIndex
        answeredCorrectly.append(isCorrect)
        
        withAnimation {
            showExplanation = true
        }
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < lesson.quiz.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
            showExplanation = false
        } else {
            // Finished
            let correctCount = answeredCorrectly.filter { $0 }.count
            score = Double(correctCount) / Double(lesson.quiz.count)
            onComplete(score)
            
            // Show results
            withAnimation {
                currentQuestionIndex = lesson.quiz.count // trigger results
            }
        }
    }
    
    private var resultsView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: score >= 0.8 ? "star.fill" : "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(score >= 0.8 ? AetheriusTheme.warning : AetheriusTheme.success)
            
            Text("Quiz Complete")
                .font(.largeTitle.weight(.semibold))
            
            Text("\(Int(score * 100))% correct")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(lesson.category.accentColor)
            
            Text(performanceMessage)
                .font(.title3)
                .foregroundStyle(AetheriusTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button {
                dismiss()
            } label: {
                Text("Return to Lesson")
                    .font(.headline)
                    .frame(maxWidth: 280)
            }
            .buttonStyle(.borderedProminent)
            .tint(lesson.category.accentColor)
            .controlSize(.large)
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
    }
    
    private var performanceMessage: String {
        switch score {
        case 1.0: return "Perfect! You've mastered this material."
        case 0.8...: return "Excellent work. Strong understanding."
        case 0.6..<0.8: return "Good job. A bit more study and you'll have it."
        default: return "Solid attempt. Review the explanations and try again soon."
        }
    }
}
