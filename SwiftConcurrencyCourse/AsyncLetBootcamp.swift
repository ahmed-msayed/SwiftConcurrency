//
//  AsyncLetBootcamp.swift
//  SwiftConcurrencyCourse
//
//  Created by Ahmed Sayed on 25/10/2024.
//

import SwiftUI

struct AsyncLetBootcamp: View {
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible()),GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/400")!
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async Let Bootcamp 🥸")
            .onAppear {
                Task {
                    do {
                        async let fetchImage1 = fetchImage()
                        async let fetchImage2 = fetchImage()
                        async let fetchImage3 = fetchImage()
                        async let fetchImage4 = fetchImage()
                        
                        let (image1, image2, image3, image4) = try await (fetchImage1, fetchImage2, fetchImage3, fetchImage4)
                        self.images.append(contentsOf: [image1, image2, image3, image4])
                        // all loads at once
                        
//                        let image1 = try await fetchImage()
//                        self.images.append(image1)
//                        let image2 = try await fetchImage()
//                        self.images.append(image2)
//                        let image3 = try await fetchImage()
//                        self.images.append(image3)
//                        let image4 = try await fetchImage()
//                        self.images.append(image4)
                        //loads one by one
                        
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    func fetchImage() async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }    }
}

#Preview {
    AsyncLetBootcamp()
}
