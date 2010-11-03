require 'haml'
require 'pathname'

namespace :"public-site" do 
  
  desc 'Generates the static public site'
  task :generate do
    public_site_root = File.join(Rails.root, 'public-site')
    output_path      = File.join(Rails.root, 'public')
    
    layout = File.read(File.join(public_site_root, 'views', 'layout.haml'))
    
    views  = Pathname.glob(File.join(public_site_root, 'views', '*.haml')).
      reject {|v| v.to_s[/layout.haml/] }
    
    views.each do |view|
      static_html = Haml::Engine.new(layout).to_html do
        File.read(view)
      end
      output = File.join(output_path, view.basename.to_s.gsub(/haml/,'html'))
      
      File.open(output, 'w') {|f| f.puts(static_html) }
    end
    
    sass = File.read(File.join(Rails.root, 'public-site', 'stylesheets', 'public.sass'))
    
    css      = Sass::Engine.new(sass).to_css
    css_file = File.join(output_path, 'stylesheets', 'public.css')
    
    File.open(css_file, 'w') { |f| f.puts(css) }
  end
end