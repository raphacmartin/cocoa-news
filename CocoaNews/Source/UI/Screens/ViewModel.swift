protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func connect(input: Input) -> Output
}
