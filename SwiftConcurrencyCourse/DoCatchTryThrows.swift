//
//  DoCatchTryThrows.swift
//  SwiftConcurrencyCourse
//
//  Created by Ahmed Sayed on 06/09/2024.
//

import SwiftUI

//do-catch
//try
//throws

class DoCatchTryThrowsDataManager {
    let isActive: Bool = false
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("New Text", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("New Text")
        } else {
            return .failure(URLError(.appTransportSecurityRequiresSecureConnection))
        }
    }
    
    func getTitle3() throws -> String {
        if isActive {
            return "New Text"
        } else {
            throw URLError(.badServerResponse)
        }
    }
}

class DoCatchTryThrowsViewModel: ObservableObject {
    @Published var text: String = "starting text."
    let manager = DoCatchTryThrowsDataManager()
    
    func fetchTitle() {
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
    }
    
    func fetchTitle2() {
        let result = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
    }
    
    func fetchTitle3() {
        do {
            let newTitle = try manager.getTitle3()
            self.text = newTitle
        } catch {
            let errorDescription = error.localizedDescription
            self.text = errorDescription
        }
    }
}

struct DoCatchTryThrows: View {
    @StateObject private var viewModel = DoCatchTryThrowsViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle2()
            }
    }
}

#Preview {
    DoCatchTryThrows()
}
