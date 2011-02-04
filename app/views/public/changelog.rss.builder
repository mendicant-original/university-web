xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0",  'xmlns:atom' => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title "Ruby Mendicant University"
    xml.description "Ruby Mendicant University is a free online training program aimed at helping intermediate Ruby developers improve their software development skills"
    xml.link "http://university.rubymendicant.com"
    xml.send('atom:link', :href => "http://university.rubymendicant.com/changelog.rss", :rel => "self", :type => "application/rss+xml")
    @announcements.each do |announcement|
      xml.item do
        xml.title announcement.title
        xml.description md(announcement.body)
        xml.author "#{announcement.author.email} (#{announcement.author.name})"
        xml.pubDate announcement.created_at.to_s(:rfc822)
        xml.link "http://university.rubymendicant.com/changelog"
        xml.guid "http://university.rubymendicant.com/changelog##{announcement.id}"
      end
    end
  end
end