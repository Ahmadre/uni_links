#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint unilinks.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'uni_links'
  s.version          = '0.4.0'
  s.summary          = 'Uni_Links Plugin for macOS.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://ahmadre.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Rebar A.' => 'rebar.ahmad@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
