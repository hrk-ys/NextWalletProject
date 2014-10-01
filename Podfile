platform :ios, 7.0
pod 'AFNetworking',  '2.1.0'
pod 'SVProgressHUD', '1.0'
#pod 'SDWebImage'
pod 'SDWebImage', '~>3.6'
pod 'MagicalRecord/Shorthand', '2.2'
pod 'LXReorderableCollectionViewFlowLayout', '0.1.1'
pod 'ZXingObjC', '2.2.2'
pod 'ZBarSDK'
pod 'Mixpanel', '2.3.5'
pod 'GoogleAnalytics-iOS-SDK', '3.0.3'
pod 'Google-Mobile-Ads-SDK', '6.12.0'
pod 'CocoaLumberjack', '1.8.1'

pod 'JDStatusBarNotification', '~> 1.4.7'
pod 'BlocksKit', '2.2.2'

pod 'THPinViewController', '~> 1.1.2'

pod 'HYUtils', :git => 'https://github.com/hrk-ys/HYUtils.git', :commit => '60665d2334116f223e7d2418b8f06d655341eda8'

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 'NextWalletProject/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
