Pod::Spec.new do |s|
    s.name         = "opus"
    s.version      = "1.0.0.0-dev-pod"
    s.summary      = "NativeVoice software development kit"
    s.description  = <<-DESC
    An extended description of opus project.
    DESC
    s.homepage     = "http://www.nativevoice.ai"
    s.license = { :type => 'Copyright', :text => <<-LICENSE
                   Copyright 2018
                   Permission is granted to...
                  LICENSE
                }
    s.author             = { "$(git config user.name)" => "$(git config user.email)" }
    s.source       = { :path => '.' }
    s.source_files = 'opus/**/*.{swift,h}'
    s.resources = "opus/**/*.{mp3,snsr,json}"
    s.public_header_files = "opus.framework/Headers/*.h"
    s.vendored_frameworks = "opus.framework"
    s.platform = :ios
    s.swift_version = '5.0'
    s.ios.deployment_target  = '13.6'
    s.static_framework = true

end
