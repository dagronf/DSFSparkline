Pod::Spec.new do |s|
  s.name         = "DSFInspectorPanes"
  s.version      = "1.1"
  s.summary      = "Mimic the inspector panels in Apple's Pages"
  s.description  = <<-DESC
    Mimic the inspector panels in Apple's Pages
  DESC
  s.homepage     = "https://github.com/dagronf/DSFInspectorPanes"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Darren Ford" => "dford_au-reg@yahoo.com" }
  s.social_media_url   = ""
  s.osx.deployment_target = "10.11"
  s.source       = { :git => ".git", :tag => s.version.to_s }
  s.source_files  = "Sources/DSFInspectorPanes/*.swift",
                    "Sources/DSFInspectorPanes/private/*.swift",
                    "Sources/DSFInspectorPanes/private/3rd-party/*.swift"
  s.frameworks  = "Cocoa"
  s.swift_version = "5.0"
end
