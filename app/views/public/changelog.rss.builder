xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Ruby Mendicant University"
    xml.description "Ruby Mendicant University is a free online training program aimed at helping intermediate Ruby developers improve their software development skills"
    xml.link "http://university.rubymendicant.com"

    @announcements.each do |announcement|
      xml.item do
        xml.title announcement.title
        xml.description announcement.body
        xml.author announcement.author.name
        xml.pubDate announcement.created_at.to_s(:rfc822)
        xml.link "http://university.rubymendicant.com/changelog"
      end
    end
  end
end