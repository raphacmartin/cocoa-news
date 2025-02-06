import SwiftUI

struct SelectableGroup<T: DescriptiveItem>: View {
    // MARK: - Private properties
    private var data: [T]
    
    // MARK: - State
    @Binding private var selected: [T]
    
    // MARK: - Initializer
    init(data: [T], selected: Binding<[T]>) {
        self.data = data
        self._selected = selected
    }
    
    var body: some View {
        VStack (spacing: StyleGuide.SelectableItem.spacing) {
            ForEach(data) { item in
                SelectableItem(item: item, selectedValues: $selected)
            }
        }
    }
}

struct SelectableItem<T: DescriptiveItem>: View {
    // MARK: - Private properties
    private var item: T
    @Binding private var selectedValues: [T]
    
    // MARK: - Computed var
    private var isSelected: Bool {
        selectedValues.contains(item)
    }
    
    // MARK: - Initializer
    init(item: T, selectedValues: Binding<[T]>) {
        self.item = item
        self._selectedValues = selectedValues
    }
    
    var body: some View {
        Button(item.description) {
            if isSelected {
                guard let index = selectedValues.firstIndex(of: item) else { return }
                
                selectedValues.remove(at: index)
            } else {
                selectedValues.append(item)
            }
        }
        .foregroundColor(isSelected ? .white : .accent)
        .padding(StyleGuide.SelectableItem.padding)
        .frame(height: StyleGuide.SelectableItem.height)
        .background(
            RoundedRectangle(cornerRadius: StyleGuide.SelectableItem.radius)
                .stroke(Color.gray, lineWidth: 2)
                .fill(isSelected ? .accent : .clear)
        )
    }
}

protocol DescriptiveItem: Equatable, Identifiable {
    var description: String { get }
}

#Preview {
    @Previewable @State var selected: [ArticleCategory] = []
    
    VStack {
        SelectableGroup(data: ArticleCategory.allCases, selected: $selected)
        
        Text("Selected values: \(selected.map(\.description).joined(separator: ", "))")
    }
}
