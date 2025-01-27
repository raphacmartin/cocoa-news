import SwiftUI

struct SelectableGroup: View {
    // MARK: - Private properties
    private var data: [String]
    
    // MARK: - State
    @Binding private var selected: [String]
    
    // MARK: - Initializer
    init(data: [String], selected: Binding<[String]>) {
        self.data = data
        self._selected = selected
    }
    
    var body: some View {
        VStack (spacing: StyleGuide.SelectableItem.spacing) {
            ForEach(data, id: \.self) { item in
                SelectableItem(text: item, selectedValues: $selected)
            }
        }
    }
}

struct SelectableItem: View {
    // MARK: - Private properties
    private var text: String
    @Binding private var selectedValues: [String]
    
    // MARK: - Computed var
    private var isSelected: Bool {
        selectedValues.contains(text)
    }
    
    // MARK: - Initializer
    init(text: String, selectedValues: Binding<[String]>) {
        self.text = text
        self._selectedValues = selectedValues
    }
    
    var body: some View {
        Button(text) {
            if isSelected {
                guard let index = selectedValues.firstIndex(of: text) else { return }
                
                selectedValues.remove(at: index)
            } else {
                selectedValues.append(text)
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

#Preview {
    @Previewable @State var selected: [String] = []
    
    VStack {
        SelectableGroup(data: [
            "🧳 Business",
            "💻 Technology",
            "🧪 Science"
        ], selected: $selected)
        
        Text("Selected values: \(selected.joined(separator: ", "))")
    }
}
