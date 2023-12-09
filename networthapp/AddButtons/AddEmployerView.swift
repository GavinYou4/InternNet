//
//  AddEmployerView.swift
//  networthapp
//
//  Created by Gavin You on 2023-12-09.
//

import SwiftUI

struct AddEmployerView: View {
    let fields = ["Select", "Information Technology", "Healthcare", "Education", "Engineering", "Finance", "Design", "Business Management", "Law", "Science", "Public Service", "Hospitality", "Marketing", "Entertainment", "Public Safety", "Library and Information Science", "Aviation", "Social Work", "Psychology", "Mechanical Trades", "Culinary Arts", "Environmental Science", "Agriculture", "Media and Communications", "Computer Science", "Law Enforcement", "Construction", "Pharmacy", "Dentistry", "Accounting", "Biotechnology", "Translation and Interpretation", "Performing Arts", "Sports and Athletics", "Meteorology", "Plumbing", "Physics", "Economics", "Visual Arts", "Dance", "Geology", "History", "Astronomy", "Architecture", "Speech Therapy", "Interior Design", "Veterinary Medicine", "Renewable Energy", "Philosophy", "Mathematics", "Robotics", "Cryptocurrency", "Virtual Reality", "Blockchain", "Genetics", "Quantum Physics", "Wildlife Biology", "Solar Energy", "Artificial Intelligence", "Augmented Reality", "Space Exploration", "Cybersecurity", "Neuroscience", "Medical Illustration", "Green Building", "Search Engine Optimization", "Drone Technology", "Marine Biology", "Wind Energy", "Oceanography", "Environmental Sustainability", "Chemistry"]

    @Environment(\.presentationMode) var presentationMode
    var function: () -> Void
    @State var company_name: String = ""
    @State var company_recruit_email: String = ""
    @State var field: String = ""
    @State var location: String = ""
    
    var categories = ["Asset", "Liabilities"]
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Your Company Name", text: $company_name)
                    TextField("Your Email", text: $company_recruit_email)
                    //                  Make this picker
                    Picker("Field of Position", selection: $field) {
                        ForEach(fields, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Where are you Located?", text: $location)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Register Employer")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button(action: {postCompany()}, label: {
                Text("Save")
            }))
        }
    }
    func postCompany() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/employer/") else {
            print("api is down")
            return
        }
        
        let companyData = Employer(id: 0, company_name: self.company_name, company_recruit_email: self.company_recruit_email, field: self.field, location: self.location)
        
        guard let encoded = try? JSONEncoder().encode(companyData) else {
            print("failed to encode")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic Z2F2aW46UGlndXBpZ3VwaWd1", forHTTPHeaderField: "Authorization")
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(Employer.self, from: data) {
                    DispatchQueue.main.async {
                        //self.accounts = response
                        self.function()
                        presentationMode.wrappedValue.dismiss()
                    }
                    return
                }
            }
        }.resume()
        
    }
}

//struct AddEmployerView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddEmployerView()
//    }
//}
