//
//  AddStudentView.swift
//  networthapp
//
//  Created by Gavin You on 2023-12-09.
//

import SwiftUI

struct AddStudentView : View {
    @Environment(\.presentationMode) var presentationMode
    var function: () -> Void
    let majors = ["Select", "Computer Science", "Nursing", "Education", "Mechanical Engineering", "Finance", "Graphic Design", "Business Administration", "Law", "Biology", "Public Administration", "Hospitality Management", "Marketing", "Film and Media Studies", "Criminal Justice", "Library Science", "Aerospace Engineering", "Social Work", "Psychology", "Mechanical Trades", "Culinary Arts", "Environmental Science", "Agricultural Science", "Journalism", "Law Enforcement", "Civil Engineering", "Pharmacy", "Dentistry", "Accounting", "Biotechnology", "Translation and Interpretation", "Performing Arts", "Sports Science", "Meteorology", "Plumbing", "Physics", "Economics", "Fine Arts", "Dance", "Geology", "History", "Astronomy", "Architecture", "Speech Therapy", "Interior Design", "Veterinary Medicine", "Renewable Energy", "Philosophy", "Mathematics", "Robotics", "Cryptocurrency Studies", "Virtual Reality Design", "Blockchain Technology", "Genetics", "Quantum Physics", "Wildlife Biology", "Solar Energy Engineering", "Artificial Intelligence", "Augmented Reality Design", "Space Exploration", "Cybersecurity", "Neuroscience", "Medical Illustration", "Green Building Design", "Search Engine Optimization", "Drone Technology", "Marine Biology", "Wind Energy Engineering", "Oceanography", "Environmental Sustainability", "Chemistry"]

    @State var name: String = ""
    @State var email: String = ""
    @State var major: String = ""
    @State var university: String = ""
    @State var softskills: String = ""
    @State var experience: String = ""
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                    Picker("Major", selection: $major) {
                        ForEach(majors, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("University", text: $university)
                    TextField("Soft Skills", text: $softskills)
                    TextField("Experience", text: $experience)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Apply for Internship")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button(action: {postApplication()}, label: {
                Text("Save")
            }))
        }
    }
    func postApplication() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/account/") else {
            print("api is down")
            return
        }
        
        let accountData = Account(id: 0, name: self.name, email: self.email, major: self.major, university: self.university, softskills: self.softskills, experience: self.experience)
        
        guard let encoded = try? JSONEncoder().encode(accountData) else {
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
                if let response = try? JSONDecoder().decode(Account.self, from: data) {
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
