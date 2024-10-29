import Foundation

final class TUIStateManager {
    var loadingMessage: String = ""
    var isLoading: Bool = false
    private var loadingAnimator: LoadingAnimator?
    
    func startLoading(command: String, onUpdate: @escaping () -> Void) {
        isLoading = true
        loadingMessage = "Executing \(command)..."
        
        loadingAnimator = LoadingAnimator(command: command) { [weak self] newMessage in
            self?.loadingMessage = newMessage
            onUpdate()
        }
        loadingAnimator?.start()
    }
    
    func stopLoading() {
        isLoading = false
        loadingAnimator?.stop()
        loadingAnimator = nil
    }
}
