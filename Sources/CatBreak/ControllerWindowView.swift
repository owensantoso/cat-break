import CatBreakCore
import SwiftUI

struct ControllerWindowView: View {
    @Bindable var model: CatBreakModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            header
            statusCard
            settingsForm
            actions
        }
        .padding(24)
        .frame(width: 440)
        .onAppear {
            model.startTicking()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Cat Break")
                .font(.system(size: 34, weight: .black, design: .rounded))

            Text("A tiny native macOS prototype for playful break interruptions.")
                .foregroundStyle(.secondary)
        }
    }

    private var statusCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.phaseTitle)
                .font(.headline)

            Text(model.displayedCountdownText)
                .font(.system(size: 54, weight: .bold, design: .rounded))
                .monospacedDigit()

            Text("Idle: \(DurationFormatting.minutesAndSeconds(model.lastIdleDuration))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 18))
    }

    private var settingsForm: some View {
        Form {
            Picker("Timer mode", selection: $model.settings.timingMode) {
                ForEach(TimingMode.allCases) { mode in
                    Text(mode.displayName).tag(mode)
                }
            }

            secondsStepper("Work interval", value: $model.settings.workInterval, range: 5...7_200, step: 5)
            secondsStepper("Break duration", value: $model.settings.breakDuration, range: 5...1_800, step: 5)
            secondsStepper("Idle pause", value: $model.settings.idlePauseThreshold, range: 1...600, step: 1)
            secondsStepper("Snooze duration", value: $model.settings.snoozeDuration, range: 5...900, step: 5)
            Stepper("Snooze limit: \(model.settings.snoozeLimit)", value: $model.settings.snoozeLimit, in: 0...5)
        }
        .formStyle(.grouped)
        .frame(height: 220)
    }

    private var actions: some View {
        HStack {
            Button("Cat Now") {
                model.catNow()
            }
            .buttonStyle(.borderedProminent)

            Button("Short Test Settings") {
                model.useShortTestSettings()
            }

            Spacer()

            Button("Reset") {
                model.resetTimer()
            }
        }
    }

    private func secondsStepper(
        _ title: String,
        value: Binding<TimeInterval>,
        range: ClosedRange<TimeInterval>,
        step: TimeInterval
    ) -> some View {
        Stepper(value: value, in: range, step: step) {
            Text("\(title): \(DurationFormatting.minutesAndSeconds(value.wrappedValue))")
        }
    }
}
