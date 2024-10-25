//
//  AsyncAwaitBootcamp.swift
//  SwiftConcurrencyCourse
//
//  Created by Ahmed Sayed on 24/10/2024.
//

import SwiftUI

class AsyncAwaitBootcampViewModel: ObservableObject {
    @Published var dataArray: [String] = ["a", "b", "c"]
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.dataArray.append("Title 1: \(Thread.current)")     //on main thread
        }
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
            let title2 = "Title 2: \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title2)       //on background thread
                
                let title3 = "Title 3: \(Thread.current)"
                self.dataArray.append(title3)       //on main thread
            }
        }
    }

    func addAuthor1() async {
        let author1 = "Author 1: \(Thread.current)"
        self.dataArray.append(author1)
        
        try? await Task.sleep(for: .seconds(2))
        
        
        await MainActor.run {
            let author2 = "Author 2: \(Thread.current)"
            self.dataArray.append(author2)
            
            let author3 = "Author 3: \(Thread.current)"
            self.dataArray.append(author3)
        }
        
        await addSomething()
    }
    
    func addSomething() async {
        try? await Task.sleep(for: .seconds(2))
        
        let author2 = "Author 2: \(Thread.current)"
        self.dataArray.append(author2)
        
        await MainActor.run {
            let author3 = "Author 3: \(Thread.current)"
            self.dataArray.append(author3)
        }
    }
}

struct AsyncAwaitBootcamp: View {
    @StateObject private var viewModel = AsyncAwaitBootcampViewModel()

    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \.self) { data in
                Text(data)
            }
            //id:\.self returns the hash value of each string
        }
        .onAppear {
//                        viewModel.addTitle1()
//                        viewModel.addTitle2()
            Task {
                await viewModel.addAuthor1()
                // await pauses whats next until its line finishes
                let finalText = "Final Text \(Thread.current)"
                viewModel.dataArray.append(finalText)
            }
        }
    }
}

#Preview {
    AsyncAwaitBootcamp()
}
