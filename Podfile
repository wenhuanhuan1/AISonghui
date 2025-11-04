

source 'https://github.com/CocoaPods/Specs.git'
post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    
    end
  end
end

platform :ios, '13.0'

target 'WHHProject' do
  use_frameworks!
  inhibit_all_warnings!
  ## UI和接口查看
  pod 'LookinServer', :configurations => ['Debug']
  pod 'Kingfisher'
  pod 'SnapKit'
  pod 'MJExtension'
#  pod 'SwiftKeychainWrapper'
  pod 'MJRefresh'
  pod 'JXPhotoBrowser'
  pod 'MBProgressHUD'
  pod 'EmptyDataSet-Swift'
  pod 'IQKeyboardManagerSwift'
  pod 'JXSegmentedView'
  pod 'JXPagingView/Paging'
  pod 'MMKV'
  pod 'GKNavigationBarSwift'
#  pod 'SwiftMessages'
#  pod 'lottie-ios'
#  pod 'FSPagerView'
  pod 'SwiftyStoreKit'
 
  pod 'HXPhotoPicker-Lite'
  pod 'HXPhotoPicker-Lite/Picker'
  pod 'HXPhotoPicker-Lite/Editor'
  pod 'HXPhotoPicker-Lite/Camera'
  pod 'MJExtension'
  pod 'BRPickerView'
  pod 'YYWebImage', '~> 1.0.5'
#  pod 'YYImage/WebP'
  pod 'GPUImage'
end
