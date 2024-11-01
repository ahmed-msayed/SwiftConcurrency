//
//  CheckedContinuationBootcamp.swift
//  SwiftConcurrencyCourse
//
//  Created by Ahmed Sayed on 31/10/2024.
//

import SwiftUI

// To convert Non Async Code To Async Code

class CheckedContinuationBootcampNetworkManager {
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
    
    func getData2(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }
    
    //old with completion handler
    func getHeartImageFromDB(completionHandler: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    //new with async
    func getHeartImageFromDB() async -> UIImage {
        return await withCheckedContinuation { continuation in
            getHeartImageFromDB { image in
                continuation.resume(returning: image)
            }
        }
    }
}

class CheckedContinuationBootcampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let networkManager = CheckedContinuationBootcampNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/400") else { return }
        
        do {
            let data = try await networkManager.getData2(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run (body: {
                    self.image = image
                })
            }
        } catch {
            print(error)
        }
    }
    
    func getHeartImage() async {
        /*
        networkManager.getHeartImageFromDB { image in
                self.image = image
        }*/
        self.image = await networkManager.getHeartImageFromDB()
    }
}

struct CheckedContinuationBootcamp: View {
    @StateObject var viewModel = CheckedContinuationBootcampViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.getHeartImage()
        }
    }
}

#Preview {
    CheckedContinuationBootcamp()
}
