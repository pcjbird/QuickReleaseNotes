Pod::Spec.new do |s|
    s.name             = "QuickReleaseNotes"
    s.version          = "1.0.0"
    s.summary          = "Quick integrate release note check with your App. 一行代码让你的App快速集成应用商店版本更新检测功能。"
    s.description      = <<-DESC
    Quick integrate release note check with your App. 一行代码让你的App快速集成应用商店版本更新检测功能, 支持扩展。
    DESC
    s.homepage         = "https://github.com/pcjbird/QuickReleaseNotes"
    s.license          = 'MIT'
    s.author           = {"pcjbird" => "pcjbird@hotmail.com"}
    s.source           = {:git => "https://github.com/pcjbird/QuickReleaseNotes.git", :tag => s.version.to_s}
    s.social_media_url = 'http://www.lessney.com'
    s.requires_arc     = true
    s.documentation_url = 'https://github.com/pcjbird/QuickReleaseNotes/blob/master/README.md'
    s.screenshot       = 'https://github.com/pcjbird/QuickReleaseNotes/blob/master/logo.png'

    s.platform         = :ios, '8.0'
    s.frameworks       = 'Foundation', 'UIKit', 'SystemConfiguration'
#s.preserve_paths   = ''
    s.source_files     = 'QuickReleaseNotes/*.{h,m}'
    s.public_header_files = 'QuickReleaseNotes/QuickReleaseNotes.h', 'QuickReleaseNotes/QuickReleaseCheckProtocol.h'

    s.default_subspec = 'QuickAppStoreReleaseNotesAlert'

    s.resource_bundles = {
    'QuickReleaseNotes' => ['QuickReleaseNotesBundle/*.*'],
    }

    s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }


    s.subspec 'QuickReleaseCheckAppStore' do |ss|
        ss.source_files = 'QuickReleaseNotes/QuickReleaseCheckAppStore/*.{h,m}', 'QuickReleaseNotes/QuickReleaseNotesDefine.h', 'QuickReleaseNotes/QuickReleaseCheckProtocol.h'
        ss.public_header_files = 'QuickReleaseNotes/QuickReleaseCheckAppStore/QuickReleaseCheckAppStore.h', 'QuickReleaseNotes/QuickReleaseCheckProtocol.h'
    end

    s.subspec 'QuickAppStoreReleaseNotesAlert' do |ss|
        ss.source_files = 'QuickReleaseNotes/QuickAppStoreReleaseNotesAlert/*.{h,m}', 'QuickReleaseNotes/QRNAlertViewController/*.{h,m}', 'QuickReleaseNotes/QuickReleaseNotesDefine.h'
        ss.public_header_files = 'QuickReleaseNotes/QuickAppStoreReleaseNotesAlert/QuickAppStoreReleaseNotesAlert.h'
        ss.dependency 'QuickReleaseNotes/QuickReleaseCheckAppStore'
    end

end
