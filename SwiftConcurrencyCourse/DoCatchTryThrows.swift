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
    let isActive: Bool = true
    
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
//        if isActive {
//            return "New Text"
//        } else {
            throw URLError(.badServerResponse)
//        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "Final Text"
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
            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
            //if any "try" fails, won't continue and throws
        } catch let error { //we can remove "let error"
            self.text = error.localizedDescription
        }
    }
    
    func fetchTitle4() {
        let newTitle = try? manager.getTitle3()
        //optional try, returns nil on error & don't throw
        if let newTitle = newTitle {
            self.text = newTitle
        }
    }
    
    func fetchTitle5() {
        do {
            let newTitle = try? manager.getTitle3()
            if let newTitle = newTitle {
                self.text = newTitle
            }
            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
            //if first "try" fails, will continue because it returns nil & didn't throw
        } catch let error { //we can remove "let error"
            self.text = error.localizedDescription
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
                    viewModel.fetchTitle5()
                }
        }
    }
    
    #Preview {
        DoCatchTryThrows()
    }
