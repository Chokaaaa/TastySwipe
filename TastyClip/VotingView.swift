//
//  VotingView.swift
//  TastyClip
//
//  Created by Nursultan Yelemessov on 23/01/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct VotingView: View {
    
    let votingId : String
    @State var voting : VotingModel?
    @State var name : String = ""
    @State var showNamePopUp = false
    @State var voteToEdit: VoteModel?
    @State var showEditVoteView = false
    @State var votes: [VoteModel] = []
    @State var isLike = false
    @State var showAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    @State var voteHistory : [VoteHistoryModel] = []
    
    var body: some View {
        ZStack {
            VStack {
                VStack(spacing: 10) {
                    HStack {
                        Text("Vote")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    .padding(.leading, 15)
                    
                    Text("Click on thumbs up or on thumbs down based on your desire to visit proposed location.")
                        .padding([.leading,.trailing], 15)
                }
                
                //MARK: - Card
                ZStack {
                    VStack(spacing: 0) {
                        
                        //MARK: - Image
                        ZStack(alignment: .top) {
                            if let image = voting?.image {
                                
                                AsyncImage(url: URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=\(image)&key=AIzaSyAXwxcsli6DB69TDjE-I4ayPNyTTfMy5H4")) { phase in
                                    switch phase {
                                    case .empty:
                                        Image("loading")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .cornerRadius(20)
                                            .frame(width: 300,height: 280)
                                            .clipped()
                                            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20))
                                        
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .cornerRadius(20)
                                            .frame(width: 300,height: 280)
                                            .clipped()
                                            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20))
                                        
                                    case .failure:
                                        Image("loading")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .cornerRadius(20)
                                            .frame(width: 300,height: 280)
                                            .clipped()
                                            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 20, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20))
                                        
                                    @unknown default:
                                        EmptyView()
                                            .frame(width: 300,height: 280)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: 275, maxHeight: 200)
                        .shadow(radius: 1.5)
                        //MARK: - Text(title,category,location)
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(voting?.title ?? "")
                                    .lineLimit(1)
                                    .font(.system(size: 20, design: .rounded))
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 15)
                                    
                                
                                Spacer()
                                
                                    
                            }
                            .padding(.top,55)
                            
                            
                            Text(voting?.location ?? "")
                                .font(.system(size: 14, design: .rounded))
                                .fontWeight(.regular)
                                .padding(.horizontal, 15)

                            
                            //MARK: - Action Buttons
                            HStack(spacing: 85) {
                                
                                //MARK: - Dislike
                                Button {
                                    
                                    guard !voteHistory.contains ( where: { $0.voteId == votingId }) else { return }
                                    isLike = false
                                    showNamePopUp = true
                                    
                                } label: {
                                    Image(systemName: "hand.thumbsdown")
                                        .modifier(CirlceButtonModifier(width: 55, height: 55, cornerRadius: 33))
                                        .foregroundStyle(voteHistory.contains(where: { $0.voteId == votingId }) && !isLike ? Color.red : Color.black)
                                }

                                
                                
                                //MARK: - Like
                                Button {
                                    guard !voteHistory.contains ( where: { $0.voteId == votingId }) else { return }
                                    isLike = true
                                    showNamePopUp = true
                                    
                                } label: {
                                    Image(systemName: "hand.thumbsup")
                                        .modifier(CirlceButtonModifier(width: 55, height: 55, cornerRadius: 33))
                                        .foregroundStyle(voteHistory.contains(where: { $0.voteId == votingId }) && isLike ? Color.green : Color.black)
                                }
                            }
                            .padding(.leading, 25)
                            .padding()

                            
                        }
                        
                        .frame(maxWidth: 275, maxHeight: 200)
                        
                        
                    }
                    .cornerRadius(20)
                    .background(
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(20)
                            .shadow(color: .gray.opacity(0.6), radius: 4.5,x: 0,y: 0)
                    )
                    
        //            .padding(.bottom,-380)
                }
                
                HStack {
                    Text("Users")
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Text("Total votes \(votes.count)")
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                }
                .padding(.top, 20)
                .padding([.leading, .trailing], 25)
                
                List {
                    ForEach(votes) { vote in
                        
                        HStack {
                            
                            Text(vote.name)
                                .foregroundStyle(.black)
                         Spacer()
                            Text(vote.vote ? "Yes" : "No")
                                .bold()
                                .foregroundStyle(vote.vote ? .green : .red)
                        }
                        .padding([.leading,.trailing], 10)
                        .onTapGesture {
                            guard voteHistory.contains ( where: { $0.id == vote.id }) else { return }
                                isLike = vote.vote
                                name = vote.name
                                voteToEdit = vote
                                showEditVoteView = true
                            
                        }
                    }
                }
                .listStyle(.plain)
                .listRowSeparator(.hidden, edges: .all)
            }
            .alert(alertTitle, isPresented: $showAlert, actions: {
                Button {
                    
                } label: {
                    Text("Okay")
                }

            }, message: {
                Text(alertMessage)
            })
            .padding(.top, 15)
            if showNamePopUp {
                Color.black.opacity(0.5).ignoresSafeArea()
                    .onTapGesture {
                        showNamePopUp = false
                    }
                VStack {
                    TextField("Enter name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    Button {
                        save(name: name)
                    } label: {
                        Text("Save")
                    }
                    .padding(.top, 15)
                    
                }
                .frame(height: 250)
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
                .padding(.horizontal)
            }
            if showEditVoteView {
                Color.black.opacity(0.5).ignoresSafeArea()
                    .onTapGesture {
                        showEditVoteView = false
                    }
                VStack {
                    TextField("Enter name", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    
                    HStack(spacing: 85) {
                        
                        //MARK: - Dislike
                        Button {
                            
                            isLike = false
                            
                        } label: {
                            Image(systemName: "hand.thumbsdown")
                                .modifier(CirlceButtonModifier(width: 55, height: 55, cornerRadius: 33))
                                .foregroundStyle(!isLike ? Color.red : Color.black)
                        }
                        
                        //MARK: - Like
                        Button {
                            
                            isLike = true
                            
                        } label: {
                            Image(systemName: "hand.thumbsup")
                                .modifier(CirlceButtonModifier(width: 55, height: 55, cornerRadius: 33))
                                .foregroundStyle(isLike ? Color.green : Color.black)
                        }
                    }
                    .padding(.leading, 25)
                    .padding()
                    
                    
                    Button {
                        editVote()
                    } label: {
                        Text("Save")
                    }
                    .padding(.top, 15)
                    
                }
                .frame(height: 250)
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
                .padding(.horizontal)
            }
        }
        .onAppear {
            if let savedVote = VoteHistoryManager.checkIfAlreadyVoted() {
                print("Found saved vote \(savedVote)")
                voteHistory.append(savedVote)
            }
            if let historicalVote = voteHistory.first(where: { $0.voteId == votingId }) {
                isLike = historicalVote.isLike
            }
            
            Firestore.firestore().collection("voting").document(votingId).getDocument { snapShot, error in
                print("Firestore did return \(votingId)")
                if let error = error {
                    print("Error getting voting \(error.localizedDescription)")
                    return
                }
                print("No error")
                guard let snapshot = snapShot else {
                    print("No Snapshot")
                    return
                }
                self.voting = VotingModel(snapshot: snapshot)
                
            }
            
            Firestore.firestore().collection("voting").document(votingId).collection("votes").addSnapshotListener { snapshot, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let snapshot = snapshot else { return }
                
                self.votes = snapshot.documents.compactMap { VoteModel(snapshot: $0) }
                
            }
            
        }
        
        
        
    }
    
    func editVote() {
        guard let voteId = voteToEdit?.id else { return }
        Firestore.firestore().collection("voting").document(votingId).collection("votes").document(voteId).updateData(["name": name, "vote": isLike])
        showEditVoteView = false
    }
    
    func save(name: String) {
        print("Saved votes \(voteHistory)")
        guard !voteHistory.contains ( where: { $0.voteId == votingId }) else {
            alertTitle = "Can't Vote"
            alertMessage = "Its seems you already voted"
            showAlert = true
            return
        }
        
        let reference = Firestore.firestore().collection("voting").document(votingId).collection("votes").document()
        let documentId = reference.documentID
        
        reference.setData(["name": name, "vote": isLike])
        
        
        let historicalVote = VoteHistoryModel(id: documentId ,voteId: votingId, isLike: isLike)
        VoteHistoryManager.saveVote(vote: historicalVote)
        
        voteHistory.append(historicalVote)
        
        showNamePopUp = false
        
    }
    
    
}

#Preview {
    VotingView(votingId: "ZztuGpEGjHsWDWU3qDQg")
}
