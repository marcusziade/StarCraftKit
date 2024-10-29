import Foundation

final class LoadingAnimator {
    private let frames = ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"]
    private var animationFrame = 0
    private let command: String
    private let onUpdate: (String) -> Void
    private var isRunning = true

    init(command: String, onUpdate: @escaping (String) -> Void) {
        self.command = command
        self.onUpdate = onUpdate
    }

    func start() {
        let loadingQueue = DispatchQueue(label: "loading.animation")
        loadingQueue.async { [weak self] in
            guard let self = self else { return }
            while self.isRunning {
                let newMessage = "Executing \(self.command) \(self.frames[self.animationFrame])"
                self.onUpdate(newMessage)
                Thread.sleep(forTimeInterval: 0.1)
                self.animationFrame = (self.animationFrame + 1) % self.frames.count
            }
        }
    }

    func stop() {
        isRunning = false
    }
}
