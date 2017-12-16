require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'fileutils'
require 'ruby-progressbar'


args = {}

ARGV.each do |arg|
  match = /--(?<key>.*?)=(?<value>.*)/.match(arg)
  args[match[:key]] = match[:value]
end

destination = './Wallpapers'

if args.has_key? 'folder' then destination = args['folder'] end

maller_page = "http://justinmaller.com"
global_wallpaper = "wallpapers/"
first_page_css_selector = 'div.project-container > div:nth-child(1) > div:nth-child(3) > a:nth-child(1)'
second_page_css_selector = '#wallwindow > img:nth-child(1)'

page = Nokogiri::HTML(open("#{maller_page}/#{global_wallpaper}"))
downloadsArray = page.css(first_page_css_selector)

FileUtils.mkdir_p destination

prog = ProgressBar.create(:title => "Downloading Maller Wallpapers", :total => downloadsArray.length, :progress_mark => '#', :remainder_mark => '-')

downloadsArray.each do |node|
  currentImgHref = "#{maller_page}#{node["href"]}"
  currentPage = Nokogiri::HTML(open(currentImgHref))
  currentImg = currentPage.css(second_page_css_selector).attr('src')
  currentTitle = currentPage.css('#title').text.gsub(/\s+/, '_')
  prog.title = "Downloading #{currentTitle}.jpg"
  open("#{destination}/#{currentTitle}.jpg", 'wb') do |file|
    file << open(currentImg).read
    prog.increment
  end
end

puts "This is the end, enjoy :)"
