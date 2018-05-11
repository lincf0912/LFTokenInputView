Pod::Spec.new do |s|
s.name         = 'LFTokenInputView'
s.version      = '1.0.3'
s.summary      = 'iOS\'s native contact bubbles UI, it look like email input view'
s.homepage     = 'https://github.com/lincf0912/LFTokenInputView'
s.license      = 'MIT'
s.author       = { 'lincf0912' => 'dayflyking@163.com' }
s.platform     = :ios
s.ios.deployment_target = '7.0'
s.source       = { :git => 'https://github.com/lincf0912/LFTokenInputView.git', :tag => s.version, :submodules => true }
s.requires_arc = true
##s.resources    = ''
s.source_files = 'LFTokenInputView/class/*.{h,m}','LFTokenInputView/class/**/*.{h,m}'
s.public_header_files = 'LFTokenInputView/class/*.h','LFTokenInputView/class/model/*.h','LFTokenInputView/class/define/LFTokenInputType.h'

end
