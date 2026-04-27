import SwiftUI

struct CatOverlayView: View {
    @Bindable var model: CatBreakModel

    private let catText = PlaceholderCatAsset.text

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black.opacity(0.88),
                    Color(red: 0.05, green: 0.08, blue: 0.07).opacity(0.92)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 26) {
                Text(catText)
                    .font(.system(size: 46, weight: .bold, design: .monospaced))
                    .foregroundStyle(.orange)
                    .multilineTextAlignment(.center)
                    .shadow(color: .black, radius: 12)

                VStack(spacing: 8) {
                    Text("Cat says: break time")
                        .font(.system(size: 44, weight: .heavy, design: .rounded))

                    Text(model.breakRemainingText)
                        .font(.system(size: 76, weight: .black, design: .rounded))
                        .monospacedDigit()

                    Text(model.snoozeStatusText)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }

                Button {
                    model.snoozeBreak()
                } label: {
                    Text(model.canSnooze ? "Snooze \(model.settings.snoozeDuration.formatted(.number.precision(.fractionLength(0))))s" : "Snooze used")
                        .frame(minWidth: 180)
                }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .disabled(!model.canSnooze)
            }
            .padding(48)
            .foregroundStyle(.white)
        }
    }
}
