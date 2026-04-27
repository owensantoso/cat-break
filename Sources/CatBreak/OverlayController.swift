import AppKit
import SwiftUI

@MainActor
final class OverlayController {
    private var window: NSWindow?

    func show(model: CatBreakModel) {
        if let window {
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let screenFrame = NSScreen.main?.frame ?? NSScreen.screens.first?.frame ?? .zero
        let window = NSPanel(
            contentRect: screenFrame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.level = .screenSaver
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary]
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false
        window.contentView = NSHostingView(rootView: CatOverlayView(model: model))

        self.window = window
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        Diagnostics.overlayShown(frame: screenFrame)
    }

    func hide() {
        window?.orderOut(nil)
        window?.close()
        window = nil
        Diagnostics.overlayHidden()
    }
}
