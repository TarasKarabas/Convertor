//
//  ContentView.swift
//  Convertor
//
//  Created by Taras Kyparenko on 30/3/2023.
//

import SwiftUI

struct ContentView: View {

    @State private var units = ["C°", "F°", "K°"]
    
    @StateObject var unit: AutoPickerVM = .init()
    @State private var unitValueFrom: Double = 0.0
    @State private var unitValueTo: Double = 0.0
    
    @FocusState private var unitFromIsFocused: Bool
    
    var convertedValue: Double {
        var value: Double = 0
        if unit.from == "C°" && unit.to == "F°" {
            value = unitValueFrom * 9.0 / 5.0 + 32.0
        } else if unit.from == "C°" && unit.to == "K°"{
            value = unitValueFrom + 273.15
        } else if unit.from == "F°" && unit.to == "C°" {
            value = (unitValueFrom - 32.0) * 5.0 / 9.0
        } else if unit.from == "F°" && unit.to == "K°" {
            value =  (unitValueFrom + 459.67) * 5.0 / 9.0
        } else if unit.from == "K°" && unit.to == "C°" {
            value = unitValueFrom - 273.15
        } else if unit.from == "K°" && unit.to == "F°" {
            value = unitValueFrom * 1.8 - 459.67
        }
           return value
        }
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Converted from -\(unit.from)")) {
                    TextField("Unit value", value: $unitValueFrom, formatter: formatter)
                        .keyboardType(.decimalPad)
                        .focused($unitFromIsFocused)
                    Picker("UnitsFrom", selection: $unit.from) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section(header: Text("To-\(unit.to)")){
                    Text("\(convertedValue)")
                    Picker("UnitsTo", selection: $unit.to) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationBarTitle("Converter")
            .navigationBarTitleDisplayMode(.inline)
            .headerProminence(.increased)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { unitFromIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class AutoPickerVM: ObservableObject{
    private var storeFrom: String = "C°"
    var from: String {
        get{
            storeFrom
        }
        set{
            if newValue == to{
                let curTo = to
                storeTo = storeFrom
                storeFrom = curTo
                
            }else{
                storeFrom = newValue
            }
            objectWillChange.send()
        }
    }
    private var storeTo: String = "F°"
    var to: String {
        get{
            storeTo
        }
        set{
            if newValue == from{
                let curFrom = from
                storeFrom = storeTo
                storeTo = curFrom
            }else{
                storeTo = newValue
            }
            
            objectWillChange.send()
        }
    }
    init(){}
}
