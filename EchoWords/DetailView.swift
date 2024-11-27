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
    @Environment(\.dismiss) var dismiss
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
