//
//  API.swift
//  WindowOverlay
//
//  Created by David Walter on 25.03.23.
//

import SwiftUI
import UIKit
import Combine
import WindowSceneReader

public extension View {
    @ViewBuilder func windowOverlay<Content>(
        isPresented: Binding<Bool>,
        on windowScene: UIWindowScene,
        isInteractive: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content: View {
        modifier(
            WindowOverlayViewModifier(isPresented: isPresented,
                                      windowScene: windowScene,
                                      isInteractive: isInteractive,
                                      overlayContent: content)
        )
    }
    
    @ViewBuilder func windowOverlay<Content>(
        isPresented: Binding<Bool>,
        isInteractive: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View where Content: View {
        background(WindowSceneReader { windowScene in
            windowOverlay(isPresented: isPresented, on: windowScene, isInteractive: isInteractive, content: content)
        })
    }
}

private struct WindowOverlayViewModifier<OverlayContent>: ViewModifier where OverlayContent: View {
    @Environment(\.windowOverlayModalTransitionStyle) var modalTransitionStyle
    @Environment(\.windowOverlayBackgroundColor) var backgroundColor
    @Environment(\.windowOverlayLevel) var windowLevel
    
    var isPresented: Binding<Bool>
    var windowScene: UIWindowScene
    var isInteractive: Bool
    var overlayContent: () -> OverlayContent
    
    func body(content: Content) -> some View {
        if #available(iOS 14, *) {
            content
                .onChange(of: isPresented.wrappedValue) { value in
                    if value {
                        OverlayWindow.present(
                            on: windowScene,
                            isInteractive: isInteractive,
                            backgroundColor: backgroundColor,
                            modalTransitionStyle: modalTransitionStyle,
                            windowLevel: windowLevel,
                            view: overlayContent
                        )
                    } else {
                        OverlayWindow.dismiss(on: windowScene)
                    }
                }
                .onAppear {
                    guard isPresented.wrappedValue else { return }
                    OverlayWindow.present(
                        on: windowScene,
                        isInteractive: isInteractive,
                        backgroundColor: backgroundColor,
                        modalTransitionStyle: modalTransitionStyle,
                        windowLevel: windowLevel,
                        view: overlayContent
                    )
                }
                .onDisappear {
                    OverlayWindow.dismiss(on: windowScene)
                }
        } else {
            content
                .onReceive(Just(isPresented.wrappedValue)) { value in
                    if value {
                        OverlayWindow.present(
                            on: windowScene,
                            isInteractive: isInteractive,
                            backgroundColor: backgroundColor,
                            modalTransitionStyle: modalTransitionStyle,
                            windowLevel: windowLevel,
                            view: overlayContent
                        )
                    } else {
                        // Cannot use this to hide the alert on iOS 13 because `onReceive`
                        // will get called for all alerts if there are multiple on a single view
                        // causing all alerts to be hidden immediately after appearing
                    }
                }
                .onDisappear {
                    OverlayWindow.dismiss(on: windowScene)
                }
        }
    }
}

struct Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Text("Hello World")
                
                Button {
                    
                } label: {
                    Text("Button")
                }

            }
            .navigationBarTitle("Preview")
            .windowOverlay(isPresented: .constant(true)) {
                ZStack {
                    Color.black.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                    
                    Button {
                        
                    } label: {
                        Text("Test")
                    }
                }
            }
        }
        
        Wrapper()
    }
    
    struct Wrapper: View {
        @State private var showWindow = false
        
        var body: some View {
            NavigationView {
                List {
                    Text("Hello World")
                    
                    Button {
                        showWindow.toggle()
                    } label: {
                        Text("Button")
                    }
                }
                .navigationBarTitle("Preview")
                .windowOverlay(isPresented: $showWindow, isInteractive: false) {
                    Toast(showWindow: $showWindow)
                }
            }
        }
        
        struct Toast: View {
            @Binding var showWindow: Bool
            @State var showToast = false
            
            var body: some View {
                ZStack(alignment: .top) {
                    Color.clear.edgesIgnoringSafeArea(.all)
                    
                    if showToast {
                        Text("Test")
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                            .background(Color.white)
                            .cornerRadius(.infinity)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.default, value: showToast)
                .onAppear {
                    showToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                        showToast = false
                        showWindow = false
                    }
                }
            }
        }
    }
}
