#!/usr/bin/env nu

def main [] {
    match $nu.os-info.name {
      "macos" => {
        print "MacOS detected 🍎"
        source macos.nu
      },
      "windows" => {
        print "Windows detected 🪟"
      },
      "linux" => {
        print "Linux detected 🐧"
      },
      _ => {
        print "Unknown OS"
      }
    }
}