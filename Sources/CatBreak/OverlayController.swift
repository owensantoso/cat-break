import AppKit
import SwiftUI

@MainActor
final class OverlayController {
    private var window: CatOverlayPanel?
    private var observers: [NSObjectProtocol] = []
    private var reassertTimer: Timer?

    func show(model: CatBreakModel) {
        if let window {
            bringOverlayForward(window)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let screenFrame = NSScreen.main?.frame ?? NSScreen.screens.first?.frame ?? .zero
        let window = CatOverlayPanel(
            contentRect: screenFrame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        window.level = Self.overlayLevel
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
        startReassertingOverlay()
        bringOverlayForward(window)
        NSApp.activate(ignoringOtherApps: true)
        Diagnostics.overlayShown(frame: screenFrame)
    }

    func hide() {
        stopReassertingOverlay()
        removeObservers()
        window?.orderOut(nil)
        window?.close()
        window = nil
        Diagnostics.overlayHidden()
    }

    private func bringOverlayForward(_ window: CatOverlayPanel, logEvent: Bool = true) {
        window.level = Self.overlayLevel
        window.orderFrontRegardless()
        window.makeKeyAndOrderFront(nil)
        if logEvent {
            Diagnostics.overlayBroughtForward()
        }
    }

    private static var overlayLevel: NSWindow.Level {
        NSWindow.Level(rawValue: Int(CGShieldingWindowLevel()))
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
                self?.scheduleDelayedReasserts()
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
                self?.bringOverlayForward(window, logEvent: false)
            }
        }

        observers = [resignObserver, screenObserver]
    }

    private func startReassertingOverlay() {
        stopReassertingOverlay()

        let timer = Timer(timeInterval: 0.25, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let window = self?.window else {
                    return
                }

                self?.bringOverlayForward(window)
            }
        }
        timer.tolerance = 0.05
        RunLoop.main.add(timer, forMode: .common)
        reassertTimer = timer
    }

    private func stopReassertingOverlay() {
        reassertTimer?.invalidate()
        reassertTimer = nil
    }

    private func scheduleDelayedReasserts() {
        for delay in [0.05, 0.15, 0.35] {
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(delay))
                guard let window else {
                    return
                }

                bringOverlayForward(window)
            }
        }
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
