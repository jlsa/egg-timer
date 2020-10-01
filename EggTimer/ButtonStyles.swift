//
//  ButtonStyles.swift
//  EggTimer
//
//  Created by Joel Hoekstra on 01/10/2020.
//

import SwiftUI

struct BlueButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .font(.headline)
        .frame(maxWidth: .infinity, maxHeight: 200, alignment: .center)
        .contentShape(Rectangle())
        .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
        .background(configuration.isPressed ? Color.blue.opacity(0.5) : Color.blue)
  }
}

struct GreenButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .font(.headline)
        .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
        .contentShape(Rectangle())
        .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
        .background(configuration.isPressed ? Color.green.opacity(0.5) : Color.green)
  }
}

struct RedButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .font(.headline)
        .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
        .contentShape(Rectangle())
        .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
        .background(configuration.isPressed ? Color.red.opacity(0.5) : Color.red)
  }
}
