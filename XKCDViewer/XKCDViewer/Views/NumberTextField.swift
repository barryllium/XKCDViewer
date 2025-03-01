//
//  NumberTextField.swift
//  XKCDViewer
//
//  Created by Brett Keck on 3/1/25.
//

import SwiftUI

struct NumberTextField: View {
    var placeholder: LocalizedStringKey = ""
    @Binding var text: String
    var onSubmit: (() -> Void)? = nil
    
    var body: some View {
        TextField(placeholder, text: $text)
            .onChange(of: text) { newValue in
                print("here")
                text = newValue.filter { $0.isNumber }
            }
            .onSubmit {
                onSubmit?()
            }
            .keyboardType(.numberPad)
            .submitLabel(.go)
    }
}

#Preview {
    NumberTextField(text: .constant("100"))
}
