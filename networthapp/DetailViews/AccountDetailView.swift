//
//  AccountDetailView.swift
//  networthapp
//
//  Created by Gavin You on 2023-12-09.
//

import SwiftUI

struct AccountDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var account: Account
    
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.fill").font(.system(size: 50)).foregroundColor(.turquoise)
            Text(account.name).font(.system(size: 40))
            List {
                HStack {
                    Text("Email")
                    Spacer()
                    Text(account.email)
                }
                Section {
                    Text("Major: \(account.major)")
                    Text("University: \(account.university)")
                    Text("Soft Skills: \(account.softskills)")
                    Text("Experience: \(account.experience)")
                }
                
                Section {
                    Button(action: {self.deleteAccount()}, label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete")
                        }
                    })
                }
            }
        }
        .foregroundColor(.black)
    }
    func deleteAccount() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/account/\(self.account.id)/") else {
            print("api is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic Z2F2aW46UGlndXBpZ3VwaWd1", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
                DispatchQueue.main.async {
                    print("\(data)")
                    self.presentationMode.wrappedValue.dismiss()
                }
                return
            }
            
        }.resume()
        
    }
}

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView(account: Account(id: 1, name: "Bob", email: "bob@gmail.com", major: "BME", university: "Waterloo", softskills: "Eating, Swimming", experience: "Won hackathon 2023"))
    }
}
