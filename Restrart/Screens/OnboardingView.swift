//
//  OnboardingView.swift
//  Restrart
//
//  Created by venkat reddy on 10/11/21.
//

import SwiftUI

struct OnboardingView: View {
    
    @AppStorage("onboarding") var isOnboardingViewActive: Bool = true
    
    @State private var buttonWidth: Double = UIScreen.main.bounds.width - 80
    @State private var buttonOffset: CGFloat = 0
    @State private var isAnimating: Bool = false
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    
    var body: some View {
        ZStack {
            
            Color("ColorBlue")
                .ignoresSafeArea(.all, edges: .all)
            
            VStack(spacing: 20) {
                //MARK: - Header
                
                Spacer()
                
                VStack(spacing: 0) {
                    Text("Share.")
                        .font(.system(size: 60))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                    
                    Text("""
                        It's not how much we give but
                        how much love we put into giving
                    """)
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                        
                }
                .opacity(isAnimating ? 1 : 0 )
                .offset(y: isAnimating ? 0 : -40)
                .animation(.easeOut(duration: 1), value: isAnimating)
                
                //MARK: - Center
                ZStack {
                    CircleGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
                    
                    Image("character-1")
                        .resizable()
                        .scaledToFit()
                } //: Center
                
                Spacer()
                
                //MARK: - Footer
                
                ZStack {
                    //PARTS OF THE CUSTOM BUTTON
                    
                    //1. BACKGROUND (STATIC)
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                    
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .padding(8)
                    
                    //2. CALL-TO-ACTOIN (STATIC)
                    Text("Get Started")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 20)
                    
                    //3. CAPSULE (DYNAMIC WIDTH)
                    
                    HStack {
                        Capsule()
                            .fill(Color("ColorRed"))
                            .frame(width: buttonOffset + 80)
                        
                        Spacer()
                    }
                    
                    //4. CIRCLE (DRAGGABLE)
                    
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color("ColorRed"))
                            Circle()
                                .fill(.black.opacity(0.15))
                                .padding(8)
                            
                            Image(systemName: "chevron.right.2")
                                .font(.system(size: 24, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80, alignment: .center)
                        .offset(x: buttonOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if gesture.translation.width > 0 && buttonOffset <= buttonWidth - 80 {
                                        buttonOffset = gesture.translation.width
                                    }
                                }
                                .onEnded { _ in
                                    if buttonOffset > buttonWidth / 2 {
                                        hapticFeedback.notificationOccurred(.success)
                                        playSound(sound: "chimeup", type: "mp3")
                                        buttonOffset = buttonWidth - 80
                                        isOnboardingViewActive = false
                                    } else {
                                        hapticFeedback.notificationOccurred(.warning)
                                        buttonOffset = 0
                                    }
                                }
                        )//:GESTURE
                        
                        Spacer()
                    }//:HSTACK
                        
                }
                .frame(width: buttonWidth,height: 80, alignment: .center)
                .padding()
                
                
            } //: VStack
            
        }  //: ZStack
        .onAppear(perform: {
            isAnimating = true
        })
        .preferredColorScheme(.dark)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
