//
//  TaskBootcamp.swift
//  SwiftConcurrencyCourse
//
//  Created by Ahmed Sayed on 25/10/2024.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil

    func fetchImage() async {
        try? await Task.sleep(for: .seconds(5))
        do {
            guard let url = URL(string: "https://picsum.photos/400") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image = UIImage(data: data)
                print("Image Returned!")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/400") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            await MainActor.run {
                self.image2 = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("Click Me!") {
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcamp: View {
    @StateObject private var viewModel = TaskBootcampViewModel()
//    @State private var fetchImageTask: Task<Void, Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {     //better and cancels automatically when page disappears
            await viewModel.fetchImage()
            //for long tasks e.g loops, use "try task.checkCancellation()" inside the loop, it returns an error if task is cancelled, and add "throws" to the function
        }
        
        /*
        .onDisappear() {
            fetchImageTask?.cancel()    //cancel task when click back before image appear
        }
        .onAppear {
            
            fetchImageTask = Task {
                await viewModel.fetchImage()
            }
         */
            
            /*
            Task {
                print(Thread.current)
                print(Thread.isMainThread ? "Main Thread" : "Background Thread")
                print(Task.currentPriority)
                await viewModel.fetchImage()
            }
            Task {
                print(Thread.current)
                print(Thread.isMainThread ? "Main Thread" : "Background Thread")
                print(Task.currentPriority)
                await viewModel.fetchImage2()
            }
           */
            
            /*
            Task(priority: .high) {
                await Task.yield() //Suspends current task for a while and allows others to execute
                print("High : \(Task.currentPriority) : \(Thread.current)")
            }
            Task(priority: .userInitiated) {
                print("UserInitiated : \(Task.currentPriority) : \(Thread.current)")
            }
            Task(priority: .medium) {
                print("Medium : \(Task.currentPriority) : \(Thread.current)")
            }
            Task(priority: .low) {
                print("Low : \(Task.currentPriority) : \(Thread.current)")
            }
            Task(priority: .utility) {
                print("Utility : \(Task.currentPriority) : \(Thread.current)")
            }
            Task(priority: .background) {
                print("Background : \(Task.currentPriority) : \(Thread.current)")
            }
            
            Task(priority: .low) {
                print("Low : \(Task.currentPriority) : \(Thread.current)")
                
                Task.detached { //child task, detached to be separated from parent's "low" priority
                    print("Low : \(Task.currentPriority) : \(Thread.current)")
                }
            }
            
        } */
    }
}

#Preview {
    TaskBootcamp()
}
