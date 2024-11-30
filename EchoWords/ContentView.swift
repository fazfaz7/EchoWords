//
//  ContentView.swift
//  EchoWords
//
//  Created by Adrian Emmanuel Faz Mercado on 27/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var showNewPhrase: Bool = false
    @State var newPhraseText: String = ""
    @State var newType: Int = 1
    @State var phrases: [String] = ["Mi raccomando", "Lascia perdere?", "In bocca al lupo", "Merluzzo", "Suino/Maiale?", "Stupidino"]
    @Environment(\.modelContext) var modelContext
    @Query(
        filter: #Predicate { $0.isCompleted == false },
        sort: \LearnElement.dateAdded,
        order: .reverse,
        animation: .default
    ) var testPhrases: [LearnElement]
    var body: some View {
        
        NavigationStack {
            
        VStack {
            
            HStack() {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Hey Adrian")
                            .font(.largeTitle)
                        Text("Italian Learner")
                            .foregroundStyle(.green1)
                            .font(.title3)
                    }
                    Spacer()
                    
                }.frame(width: Global.screenWidth*0.60, height: Global.screenHeight*0.08)
 

                Button {
                    
                } label: {
                    Circle()
                        .fill(Color.green1)
                        .frame(width: Global.screenWidth*0.22)
                        .overlay {
                            Image("memoji")
                                .resizable()
                                .scaledToFit()
                                .frame(width: Global.screenWidth*0.26)
                                .offset(x: 2)
                        }
                        .frame(width: Global.screenWidth*0.25)
                }
                
               

            }
            
            HStack(spacing: 15) {
                
                Button {
                    newType = 1
                    showNewPhrase = true
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: "book.fill")
                            .font(.title2)
                        Text("New phrase")
                            
                    }.foregroundStyle(.white)
                        .frame(width: Global.screenWidth*0.42, height: Global.screenHeight*0.08)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green2).shadow(radius:1))
                }
                
                
                Button {
                    newType = 2
                    showNewPhrase = true
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            .font(.title2)
                        Text("How to say?")
                            
                    }.foregroundStyle(.white)
                        .frame(width: Global.screenWidth*0.42, height: Global.screenHeight*0.08)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.green2).shadow(radius:1))
                }

            }.padding(.vertical)
            
            HStack {
                VStack {
                    Text("My Pendings")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                Spacer()
            }.frame(width: Global.screenWidth*0.85)
            
            
           
            if testPhrases.isEmpty {
                VStack(alignment: .center, spacing: 10) {
                    Spacer()
                    Image(systemName: "tray")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                        
                    Text("No pendings!")
                        .fontWeight(.semibold)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Text("Consider adding new phrases to your collection. Go out or something! ")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }.padding()
                
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(testPhrases, id: \.self) { phrase in
                            
                            WordElementView(phrase: phrase, isCollection: false)
                            
                        }
                        
                }
    
            }
            }

          
            


            
            
            
Spacer()
        }
        .sheet(isPresented: $showNewPhrase) {
            NewPhraseView(newPhraseText: $newPhraseText, showNewPhrase: $showNewPhrase, phrases: $phrases, newType: $newType)
            
                .presentationDetents([.fraction(0.4)])
                    }
    }
    }
}

#Preview {
    ContentView()
}




struct WordElementView: View {
    var phrase: LearnElement
    var isCollection: Bool = false
    @Environment(\.modelContext) var modelContext
    var body: some View {
        HStack {
            Text(phrase.userEntry)
                .foregroundStyle(.black)
            
            Spacer()
            
            if !isCollection {
                NavigationLink {
                                  DetailView(phrase: phrase)
                              } label: {
                                  Image(systemName: "checkmark.circle.fill")
                                      .font(.title2)
                                      .foregroundStyle(.green2)
                              }
                             
                              
                Button {
                    withAnimation {
                                        modelContext.delete(phrase)
                                        do {
                                            try modelContext.save() // Ensure the changes are saved
                                        } catch {
                                            print("Error deleting element: \(error)")
                                        }
                                    }
                } label: {
                    Image(systemName: "trash.fill")
                        .font(.title3)
                        .foregroundStyle(.red)
                        .opacity(0.6)
                        .padding(.horizontal,4)
                }
            }
            
        }
        .padding()
        .frame(width: Global.screenWidth*0.85, height: Global.screenHeight*0.08)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)).shadow(radius:1))
    }
}


struct NewPhraseView: View {
    @Binding var newPhraseText: String
    @Binding var showNewPhrase: Bool
    @Binding var phrases: [String]
    @Binding var newType: Int
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack(spacing: 25) {
            HStack {
                VStack(alignment: .leading)  {
                    
                    Text(newType == 1 ? "Add New Phrase" : "How to say?")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(newType == 1 ? "Heard a phrase you don't understand? Have a word you're unsure about? Save it here for later!" : "You want to know how to say a specific word or phrase in your new language? Save it here for later!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                
                Spacer()
            }
            

            
            TextEditor(text: $newPhraseText)
                .frame(height: 60) // Adjust the height as needed
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 1))

            Button {
                
                let newElement = LearnElement(learnType: newType == 1 ? .newPhrase : .howToSay, userEntry: newPhraseText, explanation: "")
                
                withAnimation {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.4
                    ) {
                        modelContext.insert(newElement)
                    }
                    
                }
                
                newPhraseText = ""
                showNewPhrase = false
            } label: {
                HStack {
                    Text("Add")
                        .font(.headline)
                        .fontWeight(.semibold)
                        
                    Image(systemName: "plus.circle")
                        .font(.title3)
                }
                .foregroundStyle(.white)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).fill(newPhraseText == "" ? Color.gray : Color.accentColor))
                
            }.disabled(newPhraseText.isEmpty)
                
        }.padding()
    }
}
