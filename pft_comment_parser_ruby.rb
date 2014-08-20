# pft_comment_parser_ruby.rb

# WRITE OUT HOW THE THING WORKS
# 	- start with seed page, maybe a story or a kind of main page
# 	- amass a list of links that are the kind of links you want to go to
# 		^ stories and posts about football, with comments
# 	- go to the link and return the contents of the page (as HTML?)
# 	- pick out the contents of the page that you want (per comment)
# 		- metric
# 		- comment
# 		- username
# 		- story headline
# 	- store this information (presumably in a hash)
# 	- put the link of the page in the links crawled list
# 	- return the hash sorted and possibly truncated however you want


# MODULAR - what are the modular components of this app? (to be adjusted, for sure)
# 	- link amassing
# 	- crawling, moving through the links
# 	- content extraction / storing
# 	- retriving stored data


# lets start by starting with a seed page amassing links
# crawl the entire PFT website

# will use Nokogiri for basic crawlings
# note that Mechanize appears to be applicable to Ruby

# http://stackoverflow.com/questions/7107642/getting-attributes-value-in-nokogiri-to-extract-link-urls

require 'rubygems'
require 'nokogiri'
require 'open-uri'

seed_page = "http://profootballtalk.nbcsports.com/"

def football_link_extractor(url)
	profootball_links = []
	page = Nokogiri::HTML(open(url))
	a_tag_length = (page.css('a').count - 1) # remember .count goes out over the index by +1
	(0..a_tag_length).each do |num|
		link = page.css('a')[num]["href"]
		if link != nil && link.include?("profootballtalk")
			profootball_links << link
		end
		profootball_links = profootball_links.uniq
	end
	return profootball_links
end

p football_link_extractor(seed_page)


