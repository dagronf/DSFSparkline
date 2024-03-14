Pod::Spec.new do |s|
  s.name                   = "DSFSparkline"
  s.version                = "6.0.2"
  s.summary                = "Simple Sparkline View for macOS, iOS and tvOS"
  s.description            = <<-DESC
    Simple Sparkline View for macOS, iOS and tvOS. Supports SwiftUI, AppKit and UIKit
  DESC
  
  s.homepage               = "https://github.com/dagronf"
  s.license                = { :type => "MIT", :file => "LICENSE" }
  s.author                 = { "Darren Ford" => "dford_au-reg@yahoo.com" }
  
  s.osx.deployment_target  = "10.11"
  s.ios.deployment_target  = "13"
  s.tvos.deployment_target = "13"
  s.source                 = { :git => "https://github.com/dagronf/DSFSparkline.git", :tag => s.version.to_s }

  s.subspec "Core" do |ss|
    ss.source_files        = "Sources/DSFSparkline/**/*.swift"
  end

  s.ios.framework          = 'UIKit'
  s.osx.framework          = 'AppKit'
  s.tvos.framework         = 'UIKit'

  s.swift_version          = "5.4"
end
