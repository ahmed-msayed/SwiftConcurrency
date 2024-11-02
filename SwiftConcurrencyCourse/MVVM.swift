//
//  MVVM.swift
//  SwiftConcurrencyCourse
//
//  Created by Ahmed Sayed on 02/11/2024.
//

import SwiftUI

class MVVMViewModel: ObservableObject {
    @Published var title: String = ""
    
    init() {
        print("ViewModel Init")
    }
}

struct MVVM: View {
    @StateObject private var viewModel = MVVMViewModel()
    let isActive: Bool
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("View Init")
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? Color.red : Color.blue)
            .onAppear {
                
            }
    }
}

struct MVVMHomeView: View {
    @State private var istActive: Bool = false
    
    var body: some View {
        MVVM(isActive: istActive)
            .onTapGesture {
                istActive.toggle()
            }
    }
}

#Preview {
    MVVM(isActive: true)
}
