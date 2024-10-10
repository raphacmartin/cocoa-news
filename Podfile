target 'CocoaNews' do
  use_frameworks!
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxSwiftExt/Core'  
  pod 'RxCombine'
  
  pod 'UnleashProxyClientSwift', :git => 'https://github.com/Unleash/unleash-proxy-client-swift.git', :tag => '1.3.0'
  
  # Makes all pods use the project default value to minimum iOS version
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end
end
