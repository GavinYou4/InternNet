//
//  EmployerDetailView.swift
//  networthapp
//
//  Created by Gavin You on 2023-12-09.
//

import SwiftUI

struct EmployerDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var employer: Employer
    
    var body: some View {
        VStack {
            Image(systemName: "building.2").font(.system(size: 50)).foregroundColor(.turquoise)
            Text(employer.company_name).font(.system(size: 40)).foregroundColor(.turquoise)
            List {
                HStack {
                    Text("Email")
                    Spacer()
                    Text("employer.company_recruit_email")
                }
                Section {
                    Text("Name : \(employer.company_name)")
                    Text("Email Us! : \(employer.company_recruit_email)")
                    Text("Field : \(employer.field)")
                    Text("Location : \(employer.location)")
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
    }
    func deleteAccount() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/employer/\(self.employer.id)/") else {
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

//struct EmployerDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        EmployerDetailView()
//    }
//}
