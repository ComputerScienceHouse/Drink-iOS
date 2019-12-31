//
//  WelcomeView.swift
//  Drink
//
//  Created by Lonnie Gerol on 12/30/19.
//  Copyright © 2019 Lonnie Gerol. All rights reserved.
//

import SwiftUI
import AppAuth


struct WelcomeView: View {
    init() {
        UITableView.appearance().separatorColor = .clear
    }
    private var authState: OIDAuthState?
    
    @State private var isPresented: Bool = false

    var body: some View {
        
        ZStack{
            Color.primary
                .edgesIgnoringSafeArea(.all).colorInvert()
            VStack{
                VStack(alignment: .center, spacing: 0){
                    Text("Welcome to")
                        .font(.system(size: 40.0, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)
                        
                    
                    LinearGradient(gradient: Gradient(colors: [.init(red: 0.96, green: 0.13, blue: 0.48), .init(red: 0.51, green: 0.15, blue: 0.27)]), startPoint: .top, endPoint: .bottom)
                        .mask(Text("Drink")
                            .font(.system(size: 40.0, weight: .semibold, design: .rounded))
                            .frame(width: nil, height: nil, alignment: .top))
                        .frame(width: 100
                            , height: 50, alignment: .top)
                        .padding(-10)
                    
                    Text("Drop drinks from your Apple Devices")
                        .padding(.top, 10)
                        .padding(.leading, 25)
                        .padding(.trailing, 25)
                        .foregroundColor(.primary)
                        .font(.system(size: 25.0, weight: .regular, design: .rounded))
                        .multilineTextAlignment(.center)
                    
                }
                List{
                    FeatureView(feature: Feature(glyph: "checkmark.shield.fill", name: "View Drinks", description: "View what drinks are currently in stock and drop what you want."))
                    FeatureView(feature: Feature(glyph: "mic.fill", name: "Dication", description: "Ask Siri to drop a drink."))
                    
                }
                .padding(.leading, 30)
                .padding(.trailing, 30)
                
                Button(action:
                    {
                    
                }){
                    ZStack{
                        LinearGradient(gradient: Gradient(colors: [.init(red: 0.96, green: 0.13, blue: 0.48), .init(red: 0.51, green: 0.15, blue: 0.27)]), startPoint: .top, endPoint: .bottom)
                            .frame(width: 250, height: 50, alignment: .center)
                            .cornerRadius(10.0)
                        
                        Text("Sign in with CSH")
                            .foregroundColor(.white)
                    }
                }
            }.padding(.top, 25)
                .padding(.bottom, 10)
            
            
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            WelcomeView()
                .colorScheme(.light)
            WelcomeView()
                .colorScheme(.dark)
            WelcomeView()
                .previewDevice(.init(rawValue: "iPhone SE"))
            WelcomeView()
            .previewDevice(.init(rawValue: "iPhone XS"))
        }
        
    }
}

func buttonPressed(){


    
}

struct Feature{
    var glyph: String!
    var name: String!
    var description: String!
    
}

struct FeatureView: View {
    var feature: Feature!
    var body: some View {
    
        HStack(spacing: 5){
        LinearGradient(gradient: Gradient(colors: [.init(red: 0.96, green: 0.13, blue: 0.48), .init(red: 0.51, green: 0.15, blue: 0.27)]), startPoint: .top, endPoint: .bottom)
            .mask(
                Image(systemName: feature.glyph)
                    .scaledToFit()
                    .font(.system(size: 60, weight: .regular, design: .rounded))
        )
            .frame(width: 75, height: 75, alignment: .center)
            .padding(-20)
        
        
        VStack(alignment: .leading){
            Text(feature.name)
                .font(.system(size: 20, weight: .medium, design: .rounded))
            
            Text(feature.description)
                
                
                .font(.system(size: 17, weight: .regular, design: .rounded))
        }
        .padding(.leading, 20)
        
        }
    
}
}


