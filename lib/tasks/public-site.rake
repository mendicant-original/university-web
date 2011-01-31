# NOTE: This file is a big mess and needs some serious love. 
#       Please don't judge me :)
#       <3 Jordan
#

require 'haml'
require 'pathname'

module Haml::Helpers
  def current_page(name, current)
    'current' if name == current
  end
  
  def markdown(file)
    RDiscount.new(File.read(File.join(Rails.root, 'public-site', 'views', file))).to_html
  end
end

namespace :"public-site" do 
  
  desc 'Generates the static public site'
  task :generate => :environment do
    public_site_root = File.join(Rails.root, 'public-site')
    output_path      = File.join(Rails.root, 'public')
    
    layout = File.read(File.join(public_site_root, 'views', 'layout.haml'))
    
    views  = Pathname.glob(File.join(public_site_root, 'views', '**', '*.haml')).
      reject {|v| v.to_s[/layout.haml/] }
    
    views.each do |view|
      current = current_section(view, public_site_root)
      
      static_html = Haml::Engine.new(layout).to_html(Object.new, :current => current) do
        Haml::Engine.new(File.read(view)).to_html
      end
      
      file_name = view.relative_path_from(Pathname.new(File.join(public_site_root, 'views')))
      
      output = File.join(output_path, file_name.to_s.gsub(/haml/,'html'))
      
      FileUtils.mkdir_p(File.join(output_path, file_name.dirname))
      
      File.open(output, 'w') {|f| f.puts(static_html) }
    end
    
    `compass compile #{File.join(Rails.root, 'public-site')}`
    
    # Copy the latest layout into rails for the public controller
    #
    FileUtils.cp(File.join(public_site_root, 'views', 'layout.haml'),
      File.join(Rails.root, 'app', 'views', 'layouts', 'static.html.haml'))
  end
  
  desc 'Removes all public site generated files'
  task :destroy => :environment do
    public_site_root = File.join(Rails.root, 'public-site')
    output_path      = File.join(Rails.root, 'public')
    
    views  = Pathname.glob(File.join(public_site_root, 'views', '**', '*.haml')).
      reject {|v| v.to_s[/layout.haml/] }
      
    views.each do |view|
      file = view.relative_path_from(Pathname.new(File.join(public_site_root, 'views')))
      file = File.join(output_path, file.to_s.gsub(/haml/,'html'))

      FileUtils.rm(file)
    end
    
    css_file = File.join(output_path, 'stylesheets', 'public.css')
    layout   = File.join(Rails.root, 'app', 'views', 'layouts', 'static.html.haml')
   
    FileUtils.rm(css_file)
    FileUtils.rm(layout)
  end
  
  def current_section(view, public_site_root)
    root = Pathname.new(File.join(public_site_root, 'views'))
    
    if view.relative_path_from(root).to_s.gsub(view.basename.to_s, '')[/\//]
      view.relative_path_from(root).to_s.gsub(view.basename.to_s, '').gsub('/', '')
    else
      view.basename.to_s.gsub('.haml','').downcase
    end
  end
end