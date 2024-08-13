//
//  FeaturedNewsItem.swift
//  CocoaNews
//
//  Created by Raphael Martin on 02/08/24.
//

import RxCombine
import Combine
import SwiftUI

struct FeaturedNewsItem: View {
    // MARK: State
    @State private var image = UIImage()
    @State private var imageLoadingState: ImageLoadingState = .loading
    @State private var degressRotating = 0.0
    @State private var cancellables = [AnyCancellable]()
    
    // MARK: Properties
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageView
                .frame(width: StyleGuide.FeaturedNews.cardWidth, height: StyleGuide.FeaturedNews.imageHeight)
                .clipped()
            
            Text(article.title)
                .font(.custom("ArialRoundedMTBold", size: 18))
                .lineLimit(2)
            Text(article.description ?? "")
                .font(.custom("ArialMT", size: 12))
                .lineLimit(2)
        }
        .frame(
            width: StyleGuide.FeaturedNews.cardWidth,
            height: StyleGuide.FeaturedNews.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: StyleGuide.FeaturedNews.cardCornerRadius))
        .background(
            RoundedRectangle(cornerRadius: StyleGuide.FeaturedNews.cardCornerRadius)
                .fill(.white.shadow(
                    .drop(
                        color: .gray.opacity(StyleGuide.FeaturedNews.cardShadowOpacity), 
                        radius: StyleGuide.FeaturedNews.cardShadowRadius
                    )
                ))
                .frame(
                    width: StyleGuide.FeaturedNews.cardWidth,
                    height: StyleGuide.FeaturedNews.cardHeight
                )
        )
        .onReceive(
            downloadImage()
                .receive(on: DispatchQueue.main)
                .catch({ error in
                    print("[FeaturedNewsItem] Error downloading the image for \(article.title). \(error.localizedDescription)")
                    self.imageLoadingState = .noImage
                    
                    return Empty<UIImage, Never>().eraseToAnyPublisher()
                })
                .eraseToAnyPublisher(),
            perform: { image in
                self.image = image
                self.imageLoadingState = .loaded
            }
        )
    }
}

// MARK: - Helpers
extension FeaturedNewsItem {
    @ViewBuilder
    private var imageView: some View {
        switch imageLoadingState {
        case .loading:
            Image(systemName: "circle.dashed")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
                .rotationEffect(.degrees(degressRotating))
                .onAppear {
                    withAnimation(.linear(duration: StyleGuide.loadingAnimationDuration).repeatForever(autoreverses: false)) {
                        degressRotating = 360.0
                    }
                }
            
        case .loaded:
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
        case .noImage:
            Image(systemName: "newspaper")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.accentColor)
        }
    }
    
    private func downloadImage() -> AnyPublisher<UIImage, any Error> {
        guard let urlToImage = article.urlToImage, let url = URL(string: urlToImage) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return ImageDownloader.shared.downloadImage(from: url).publisher
    }
}

private enum ImageLoadingState {
    case loading
    case loaded
    case noImage
}

#Preview {
    let source = ArticleSource(id: "999", name: "ABC News")
    let article = Article(
        source: source,
        author: nil,
        title: "My Incredible Article Title",
        description: "That's the description of the article. Some text a little bit longer them the title",
        url: "",
        urlToImage: "https://as2.ftcdn.net/v2/jpg/04/79/39/21/1000_F_479392111_fngeDxUkGVX1iLKRIgaUEKWWyxxhjW9e.jpg",
        publishedAt: "2024-01-01",
        content: nil
    )
    
    return FeaturedNewsItem(article: article)
}
