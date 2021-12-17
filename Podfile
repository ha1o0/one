#解决Multiple commands produce '.../xxx.app/Assets.car':
#install! 'cocoapods', :disable_input_output_paths => true
#source 'https://github.com/CocoaPods/Specs.git'
source 'https://cdn.cocoapods.org/'
platform :ios, '10.0'
use_frameworks!
use_modular_headers!
inhibit_all_warnings!

#post_install do |installer|
# installer.pods_project.targets.each do |target|
#  target.build_configurations.each do |config|
#   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
#  end
# end
#end

target 'one' do
    # pod swift
    pod 'Moya', '~> 15.0.0'
    pod 'SnapKit', '~> 5.0.0'
    pod 'DLRadioButton', '~> 1.4'
    pod 'SDWebImage', '~> 5.0'
    pod 'Toast-Swift', '~> 5.0.1'
    pod 'FreeStreamer'
    pod 'MarqueeLabel'
    pod 'Dplayer', :git =>'https://github.com/weifengsmile/Dplayer.git', :branch => 'master'
    # pod objective-c
    pod 'ZImageCropper'
    pod 'MJRefresh'
    pod 'DoraemonKit/Core', '~> 3.0.4', :configurations => ['Debug'], :modular_headers => true #必选
    pod 'DoraemonKit/WithGPS', '~> 3.0.4', :configurations => ['Debug'] #可选
    pod 'DoraemonKit/WithLoad', '~> 3.0.4', :configurations => ['Debug'] #可选
    pod 'DoraemonKit/WithLogger', '~> 3.0.4', :configurations => ['Debug'] #可选
    pod 'DoraemonKit/WithDatabase', '~> 3.0.4', :configurations => ['Debug'] #可选
    pod 'DoraemonKit/WithMLeaksFinder', '~> 3.0.4', :configurations => ['Debug'] #可选
    pod 'DoraemonKit/WithWeex', '~> 3.0.4', :configurations => ['Debug'] #可选
end
	
