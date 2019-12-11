#
# Be sure to run `pod lib lint Dizzy.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Dizzy'
  s.version          = '0.1.1'
  s.summary          = 'Basic extensions for swift.'
  s.swift_versions   = '5.0'
  s.description      = <<-DESC
    TODO: Add long description of the pod here.
  DESC

  s.homepage         = 'https://github.com/istorry/Dizzy'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'istorry' => 'jatinx.lol@gmail.com' }
  s.source           = { :git => 'https://github.com/istorry/Dizzy.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.source_files = 'Dizzy/Classes/**/*'
  s.resource_bundle = { 'DizzyIcons' => 'Dizzy/Fonts/*.ttf' }
end
