//
//  SettingView.swift
//  MovieBox
//
//  Created by Jinyoung Yoo on 9/30/24.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.openURL) var openURL
    @State private var appVersion: String = ""
    private let toAddress = "jin12243@gmail.com"
    private let subject = "[무비박스 문의/의견]"
    private let bodyText = ""

    var body: some View {

        NavigationStack {
            
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                let screenHeight = geometry.size.height

                VStack {
                    HStack {
                        Text("설정")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    .padding()
                    
                    VStack(spacing: 30) {
                        HStack {
                            Image(systemName: "info.circle")
                                .font(.subheadline)
                                .padding(.trailing, 12)
                            Text("버전 정보")
                                .font(.subheadline)
                            Spacer()
                            Text(appVersion)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        
                        NavigationLink {
                            PrivacyPolicyView()
                        } label: {
                            HStack {
                                Image(systemName: "doc.plaintext")
                                    .font(.subheadline)
                                    .padding(.trailing, 12)
                                Text("개인정보 처리방침")
                                    .font(.subheadline)
                                Spacer()
                            }
                        }
                        .foregroundStyle(.white)
                        
                        HStack {
                            Image(systemName: "paperplane.fill")
                                .font(.subheadline)
                                .padding(.trailing, 10)
                            Text("문의/의견")
                                .font(.subheadline)

                            Spacer()
                        }
                        .onTapGesture {
                            let urlString = "mailto:\(toAddress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(bodyText.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
                            guard let url = URL(string: urlString) else { return }
                            openURL(url) { accepted in
                                if !accepted {
                                    print("ERROR: 현재 기기는 이메일을 지원하지 않습니다.")
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.trailing, 15)
                    
                    Spacer()
                }
                .frame(width: screenWidth, height: screenHeight)
                .background(Color.background)
                .onAppear {
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        appVersion = version
                    }
                }
            }
            
        }

    }
}

struct PrivacyPolicyView: View {
    
    var content = Literal.privacyPolicy
    
    var body: some View {
        
        GeometryReader { gm in
            
            VStack {
                
                ScrollView {
                    Text(content)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
                        .padding()                    
                }
                
            }
            .frame(width: gm.size.width, height: gm.size.height)
            .background(Color.background)
            .toolbar(.hidden, for: .tabBar)
            .navigationTitle("개인정보 처리방침")
        }
        
    }
}

#Preview {
    SettingView()
}
