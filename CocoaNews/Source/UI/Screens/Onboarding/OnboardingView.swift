import SwiftUI

struct OnboardingView: View {
    // MARK: - State
    @State var selectedCategories: [String] = []
    
    // MARK: - Computed vars
    var buttonText: String {
        selectedCategories.count > 0 ? "Save and Continue" : "Select at least one category"
    }
    
    var body: some View {
        VStack {
            HStack {
                Image("logo")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.white)
                    .frame(
                        width: StyleGuide.Onboarding.logoSize,
                        height: StyleGuide.Onboarding.logoSize)
                Text("CocoaNews")
                    .font(.custom("ArialRoundedMTBold", size: 38))
                    .foregroundStyle(.white)
            }
            .padding(.top, 30)
            .padding(.bottom, 15)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [.accent, .secondary],
                    startPoint: UnitPoint(x: 0, y: 0),
                    endPoint: UnitPoint(x: 1, y: 1.75))
            )
            .padding(.bottom, 15)
            
            Text("Select your favorite categories")
                .font(.custom("ArialRoundedMTBold", size: 24))
                .foregroundColor(.secondary)
            
            SelectableGroup(
                data: ArticleCategory.allCases.map(\.description),
                selected: $selectedCategories)
            .frame(maxHeight: .infinity)
            
            Button(buttonText) {
                print("click")
            }
            .disabled(selectedCategories.count == 0)
        }
        .ignoresSafeArea()
        .padding(.bottom, 20)
    }
}

#Preview {
    OnboardingView()
}

// MARK: - Hosting Controller
final class OnboardingHostingController: UIHostingController<OnboardingView> {
    init() {
        super.init(rootView: OnboardingView())
    }
    
    @MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("🔥")
    }
}

extension ArticleCategory {
    var description: String {
        switch self {
        case .business:
            "🧳 Business"
        case .entertainment:
            "🍿 Entertainment"
        case .general:
            "⚙️ General"
        case .health:
            "🏥 Health"
        case .science:
            "🧪 Science"
        case .sports:
            "⚽️ Sports"
        case .technology:
            "💻 Technology"
        }
    }
}
