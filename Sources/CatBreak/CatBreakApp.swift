import SwiftUI

@main
struct CatBreakApp: App {
    @State private var model = CatBreakModel()
    @State private var overlayController = OverlayController()

    var body: some Scene {
        WindowGroup("Cat Break") {
            ControllerWindowView(model: model)
                .onAppear {
                    model.onBreakStarted = {
                        overlayController.show(model: model)
                    }
                    model.onBreakEnded = {
                        overlayController.hide()
                    }
                }
        }
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Cat Now") {
                    model.catNow()
                }
                .keyboardShortcut("c", modifiers: [.command, .shift])
            }
        }
    }
}
