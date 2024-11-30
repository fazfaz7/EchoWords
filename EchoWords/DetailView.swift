//
//  DetailView.swift
//  EchoWords
//
//  Created by Adrian Emmanuel Faz Mercado on 01/11/24.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var phrase: LearnElement
    @Environment(\.modelContext) var modelContext
    @State private var selectedName: String? = nil
    @Environment(\.dismiss) var dismiss
    var people: [FriendHelper] = [FriendHelper(name: "Gaia", imagePicture: "Gaia"), FriendHelper(name: "Elena", imagePicture: "Elena"), FriendHelper(name: "Vincenzo", imagePicture: "Vincenzo")]
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading) {
                    
                    Text(phrase.learnType == .newPhrase ? "New phrase" : "How to say...?")
                        .foregroundStyle(.green2)
                        .fontWeight(.medium)
                    Text(phrase.userEntry)
                        .font(.title)
                        .fontWeight(.semibold)
                        .italic()
                    

                
                }
                Spacer()
            }
           
           
            VStack(alignment: .leading, spacing: 25){
                Text("Adrian, write the explanation of the phrase here and finish your pending! Clear your doubt :)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                TextEditor(text: $phrase.explanation)
                    .frame(height: 100) // Adjust the height as needed
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 1))

                
                

               
                Text("Who helped you solve your doubt?")
                    .foregroundStyle(.green2)
                    .fontWeight(.medium)
                    
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        
                        ForEach(people, id: \.id) { person in
                            VStack {
                                Image(person.name)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle()
                                        )
                                    .frame(width: 80, height: 80)
                               
                                
                                Text(person.name)
                                    .lineLimit(1)
                                    .frame(width: 100, height: 20)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                            .frame(width: 110)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.green1.opacity(person.name == selectedName ? 1 : 0.4))
                            )
                            .onTapGesture {
                                withAnimation {         selectedName = person.name
                                }           }
                            
                            
                        }
                        
                        VStack {
                            Image(systemName: "plus.circle")
                                .foregroundStyle(.white)
                                .font(.largeTitle)
                            
                            Text("Add Person")
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .padding(4)
                                
                           
                            
   
                        }
                        .padding()
                        .frame(width: 110, height: 140)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.green1.opacity(1))
                        )
                      
 
                        
               

                    }
                }

                
                HStack {
                                    Spacer() // Add a spacer before and after
                                    Button {
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                            phrase.isCompleted = true // Mark as checked out
                                                            try? modelContext.save()
                                        }
                                       
                                                        dismiss()
                                    } label: {
                                        HStack {
                                            Text("Check pending")
                                            Image(systemName: "checkmark.circle.fill")
                                        }
                                        .padding(10)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.accentColor))
                                        .foregroundStyle(.white)
                                    }
                                    Spacer() // Spacer after to center the button
                                }
               
            }


            Spacer()
            
        }.padding()
    }
}

#Preview {
    DetailView(phrase: LearnElement(learnType: .newPhrase, userEntry: "Tuttavia", explanation: ""))
}

