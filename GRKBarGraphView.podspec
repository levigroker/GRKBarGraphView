Pod::Spec.new do |s|
  s.name         = "GRKBarGraphView"
  s.version      = "2.0.1"
  s.summary      = "Renders a one-item bar graph with an animatable percentage property and configurable orientation, colors, etc."
  s.description  = <<-DESC
		A UIView subclass which renders a one-item bar graph with an animatable percentage
		property and configurable orientation, colors, etc. CALayers are used for drawing
		efficiency and implicit animation.
    DESC
  s.homepage     = "https://github.com/levigroker/GRKBarGraphView"
  s.license      = 'Creative Commons Attribution 4.0 International License'
  s.author       = { "Levi Brown" => "levigroker@gmail.com" }
  s.social_media_url = 'https://twitter.com/levigroker'
  s.source       = { :git => "https://github.com/levigroker/GRKBarGraphView.git", :tag => s.version.to_s }
  s.platform     = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.source_files = 'GRKBarGraphView/**/*.{h,m}'
  s.requires_arc = true
end
