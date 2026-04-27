import AppKit
import SwiftUI

@MainActor
final class OverlayController {
    private var window: CatOverlayPanel?
    private var observers: [NSObjectProtocol] = []

    func show(model: CatBreakModel) {
        if let window {
            bringOverlayForward(window)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let screenFrame = NSScreen.main?.frame ?? NSScreen.screens.first?.frame ?? .zero
        let window = CatOverlayPanel(
            contentRect: screenFrame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.level = .screenSaver
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false
        window.hidesOnDeactivate = false
        window.isFloatingPanel = false
        window.worksWhenModal = true
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: CatOverlayView(model: model))

        self.window = window
        installObservers()
        bringOverlayForward(window)
        NSApp.activate(ignoringOtherApps: true)
        Diagnostics.overlayShown(frame: screenFrame)
    }

    func hide() {
        removeObservers()
        window?.orderOut(nil)
        window?.close()
        window = nil
        Diagnostics.overlayHidden()
    }

    private func bringOverlayForward(_ window: CatOverlayPanel) {
        window.orderFrontRegardless()
        window.makeKeyAndOrderFront(nil)
        Diagnostics.overlayBroughtForward()
    }

    private func installObservers() {
        removeObservers()

        let notificationCenter = NotificationCenter.default
        let resignObserver = notificationCenter.addObserver(
            forName: NSApplication.didResignActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                guard let window = self?.window else {
                    return
                }

                self?.bringOverlayForward(window)
            }
        }

        let screenObserver = notificationCenter.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                guard let window = self?.window else {
                    return
                }

                window.setFrame(NSScreen.main?.frame ?? window.frame, display: true)
                self?.bringOverlayForward(window)
            }
        }

        observers = [resignObserver, screenObserver]
    }

    private func removeObservers() {
        observers.forEach(NotificationCenter.default.removeObserver)
        observers.removeAll()
    }
}

private final class CatOverlayPanel: NSPanel {
    override var canBecomeKey: Bool {
        true
    }

    override var canBecomeMain: Bool {
        true
    }
}
