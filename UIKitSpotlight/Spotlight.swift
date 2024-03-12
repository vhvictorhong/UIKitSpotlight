//
//  Spotlight.swift
//  Spotlight
//
//  Created by Victor Hong on 2023-07-18.
//

import SwiftUI

extension View {

    func addSpotlight(enabled: Bool, title: String = "") -> some View {
        self
            .overlay {
                if enabled {
                    GeometryReader { proxy in
                        let rect = proxy.frame(in: .global)
                        SpotlightView(rect: rect, title: title) {
                            self
                        }
                    }
                }
            }
    }
    
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func rootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .init() }
        
        guard let root = screen.windows.first?.rootViewController else { return .init() }
        
        return root
    }
}

enum SpotlightShape {
    case circle
    case rectangle
    case rounded
}

struct SpotlightView<Content: View>: View {
    
    @State var tag: Int = 1009
    
    var content: Content
    var rect: CGRect
    var title: String
    
    init(rect: CGRect, title: String, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.rect = rect
        self.title = title
    }
    
    var body: some View {
        
        Rectangle()
            .fill(.white.opacity(0.02))
            .onAppear {
                addOverlayView()
            }
            .onDisappear {
                removeOverlay()
            }
    }
    
    func removeOverlay() {
        
        rootController().view.subviews.forEach { view in
            if view.tag == self.tag {
                view.removeFromSuperview()
            }
        }
    }
    
    func addOverlayView() {
        
        let hostingView = UIHostingController(rootView: overlaySwiftUIView())
        hostingView.view.frame = screenBounds()
        hostingView.view.backgroundColor = .clear
        
        if self.tag == 1009 {
            self.tag = generateRandom()
        }
        hostingView.view.tag = self.tag
        
        rootController().view.subviews.forEach { view in
            if view.tag == self.tag { return }
        }
        
        rootController().view.addSubview(hostingView.view)
    }
    
    @ViewBuilder
    func overlaySwiftUIView() -> some View {
        ZStack {
            Rectangle()
                .fill(Color("Spotlight").opacity(0.8))
                .mask({
                    let radius = (rect.height / rect.width) > 0.7 ? rect.width : 6
                    Rectangle()
                        .overlay {
                            content
                                .frame(width: rect.width, height: rect.height)
                                .padding(10)
                                .background(.white, in: RoundedRectangle(cornerRadius: radius))
                                .position()
                                .offset(x: rect.midX, y: rect.midY)
                                .blendMode(.destinationOut)
                        }
                })
            if !title.isEmpty {
                Text(title)
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .position()
                    .offset(x: screenBounds().midX, y: screenBounds().maxY > (screenBounds().height - 150) ? (rect.minY - 150) : (rect.maxY + 150))
                    .padding()
                    .lineLimit(2)
            }
        }
            .frame(width: screenBounds().width, height: screenBounds().height)
            .ignoresSafeArea()
    }
    
    func generateRandom() -> Int {
        let random = Int(UUID().uuid.0)
        
        let subViews = rootController().view.subviews
        
        for index in subViews.indices {
            if subViews[index].tag == random {
                return generateRandom()
            }
        }
        
        return random
    }
}
