//
//  ContentView.swift
//  networthapp
//
//  Created by Gavin You on 2023-12-07.
//

import SwiftUI

struct ContentView: View {
    let majors = ["Select", "Computer Science", "Nursing", "Education", "Mechanical Engineering", "Finance", "Graphic Design", "Business Administration", "Law", "Biology", "Public Administration", "Hospitality Management", "Marketing", "Film and Media Studies", "Criminal Justice", "Library Science", "Aerospace Engineering", "Social Work", "Psychology", "Mechanical Trades", "Culinary Arts", "Environmental Science", "Agricultural Science", "Journalism", "Law Enforcement", "Civil Engineering", "Pharmacy", "Dentistry", "Accounting", "Biotechnology", "Translation and Interpretation", "Performing Arts", "Sports Science", "Meteorology", "Plumbing", "Physics", "Economics", "Fine Arts", "Dance", "Geology", "History", "Astronomy", "Architecture", "Speech Therapy", "Interior Design", "Veterinary Medicine", "Renewable Energy", "Philosophy", "Mathematics", "Robotics", "Cryptocurrency Studies", "Virtual Reality Design", "Blockchain Technology", "Genetics", "Quantum Physics", "Wildlife Biology", "Solar Energy Engineering", "Artificial Intelligence", "Augmented Reality Design", "Space Exploration", "Cybersecurity", "Neuroscience", "Medical Illustration", "Green Building Design", "Search Engine Optimization", "Drone Technology", "Marine Biology", "Wind Energy Engineering", "Oceanography", "Environmental Sustainability", "Chemistry"]
    let fields = ["Select", "Information Technology", "Healthcare", "Education", "Engineering", "Finance", "Design", "Business Management", "Law", "Science", "Public Service", "Hospitality", "Marketing", "Entertainment", "Public Safety", "Library and Information Science", "Aviation", "Social Work", "Psychology", "Mechanical Trades", "Culinary Arts", "Environmental Science", "Agriculture", "Media and Communications", "Computer Science", "Law Enforcement", "Construction", "Pharmacy", "Dentistry", "Accounting", "Biotechnology", "Translation and Interpretation", "Performing Arts", "Sports and Athletics", "Meteorology", "Plumbing", "Physics", "Economics", "Visual Arts", "Dance", "Geology", "History", "Astronomy", "Architecture", "Speech Therapy", "Interior Design", "Veterinary Medicine", "Renewable Energy", "Philosophy", "Mathematics", "Robotics", "Cryptocurrency", "Virtual Reality", "Blockchain", "Genetics", "Quantum Physics", "Wildlife Biology", "Solar Energy", "Artificial Intelligence", "Augmented Reality", "Space Exploration", "Cybersecurity", "Neuroscience", "Medical Illustration", "Green Building", "Search Engine Optimization", "Drone Technology", "Marine Biology", "Wind Energy", "Oceanography", "Environmental Sustainability", "Chemistry"]
    @State var fieldFilter: String = "Select"
    @State var majorFilter: String = "Select"
    @State var accounts = [Account]()
    @State var employers = [Employer]()
    @State var showAdd = false
    @State var showAddEmployer = false
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Welcome to Intern Net!").font(.system(size: 50))
                NavigationLink(destination: NavigationView {
                    List {
                            Picker("Filter by Major:", selection: $majorFilter) {
                                ForEach(majors, id: \.self) {
                                    Text($0)
                                }
                        }
                        if majorFilter == "Select" {
                            ForEach(accounts) {item in
                                HStack {
                                    NavigationLink(destination: AccountDetailView(account: item)) {
                                        HStack {
                                            Image(systemName: "graduationcap.circle.fill").foregroundColor(.turquoise)
                                            Text(item.name)
                                            Spacer()
                                            Text(item.major)
                                        }
                                    }
                                }
                            }
                        } else {
                            ForEach(accounts) {item in
                                if item.major == majorFilter {
                                    HStack {
                                        NavigationLink(destination: AccountDetailView(account: item)) {
                                            HStack {
                                                Image(systemName: "graduationcap.circle.fill").foregroundColor(.turquoise)
                                                Text(item.name)
                                                Spacer()
                                                Text(item.major)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onAppear(perform: loadAccount)
                    .navigationBarTitle("Students")
                    .navigationBarItems(trailing: Button(action: {showAddEmployer.toggle()}, label: {
                        ZStack {
                            RoundedRectangle(cornerSize: CGSize(width: 20, height: 30))
                                .foregroundColor(Color.turquoise)
                            HStack {
                                Text("Register as Employer")
                                Image(systemName: "plus.circle")
                            }
                            .padding(20)
                            .foregroundColor(.white)
                        }
                    }))
                    .sheet(isPresented: $showAddEmployer, content: {
                        AddEmployerView(function: self.loadAccount)
                    })
                }, label: {
                    ZStack {
                        
                        Text("I am an Employer").font(.system(size: 25)).foregroundColor(Color.turquoise)
                    }
                })
                .listStyle(.plain)
                
                NavigationLink(destination: NavigationView {
                    Picker("Filter by Field:", selection: $fieldFilter) {
                        ForEach(fields, id: \.self) {
                            Text($0)
                        }
                    }
                    List {
                        if fieldFilter == "Select" {
                            ForEach(employers) {item in
                                HStack {
                                    NavigationLink(destination: EmployerDetailView(employer: item)) {
                                        HStack {
                                            Image(systemName: "building.2").foregroundColor(.turquoise)
                                            Text(item.company_name)
                                            Spacer()
                                            Text("\(item.field)")
                                        }
                                    }
                                }
                            }
                        } else {
                            ForEach(employers) {item in
                                if item.field == fieldFilter {
                                    HStack {
                                        NavigationLink(destination: EmployerDetailView(employer: item)) {
                                            HStack {
                                                Image(systemName: "building.2").foregroundColor(.turquoise)
                                                Text(item.company_name)
                                                Spacer()
                                                Text("\(item.field)")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onAppear(perform: loadEmployer)
                    .navigationBarTitle("Employers")
                    .navigationBarItems(trailing: Button(action: {showAdd.toggle()}, label: {
                        ZStack {
                            RoundedRectangle(cornerSize: CGSize(width: 15, height: 25))
                                .foregroundColor(Color.turquoise)
                            HStack {
                                Text("Apply for an Internship")
                                Image(systemName: "plus.circle").foregroundColor(Color.white)
                            }
                            .padding(20)
                            .foregroundColor(.white)
                        }
                    }))
                    .sheet(isPresented: $showAdd, content: {
                        AddStudentView(function: self.loadEmployer)
                    })
                }, label: {
                    ZStack {
                        Text("I am a Student").font(.system(size: 25)).foregroundColor(Color.turquoise)
                    }
                })
                .listStyle(.plain)
            }
        }
    }
    
    func loadAccount() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/account/") else {
            print("api is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic Z2F2aW46UGlndXBpZ3VwaWd1", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Account].self, from: data) {
                    DispatchQueue.main.async {
                        self.accounts = response
                    }
                    return
                }
            }
        }.resume()
        
    }
    
    func loadEmployer() {
        guard let url = URL(string: "http://127.0.0.1:8000/api/employer/") else {
            print("api is down")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic Z2F2aW46UGlndXBpZ3VwaWd1", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Employer].self, from: data) {
                    DispatchQueue.main.async {
                        self.employers = response
                    }
                    return
                }
            }
        }.resume()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
