protocol Command {
    var description: String { get }
    func execute() async throws
}
