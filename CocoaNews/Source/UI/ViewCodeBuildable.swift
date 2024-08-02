protocol ViewCodeBuildable {
    func setupHierarchy()
    func setupConstraints()
}

extension ViewCodeBuildable {
    func buildView() {
        setupHierarchy()
        setupConstraints()
    }
}
