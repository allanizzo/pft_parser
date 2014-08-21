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

def link_filterer(url)
	# lot of technical debt here

	# keywords_we_dont_want = ["wp-", "login", "mailto", "twitter", "facebook", "wordpress"]
	# keywords_we_do_want = ["profootballtalk"]
	if  url != nil && url.include?("profootballtalk") == true &&
		url.include?("facebook") == false &&
		url.include?("login") == false &&
		url.include?("mailto") == false &&
		url.include?("twitter") == false &&
		url.include?("archive") == false
		return true
	else
		return false
	end
end

# this method extracts all profootballtalk.com related links from a page
# presumably, we can filter 
def football_link_extractor(url)
	profootball_links = []
	page = Nokogiri::HTML(open(url))
	a_tag_length = (page.css('a').count - 1) # remember .count goes out over the index by +1
	(0..a_tag_length).each do |num|
		link = page.css('a')[num]["href"]
		if link_filterer(link)
		 # here is where it checks type of link
			profootball_links << link
		end
		profootball_links = profootball_links.uniq
	end
	return profootball_links
end

# p football_link_extractor(seed_page)

def link_amasser(seed_url) #AKA crawler
	links_to_parse = []
	links_parsed = []
	links_to_parse = football_link_extractor(seed_url) 
	while links_to_parse.empty? == false
		link_to_crawl = links_to_parse.shift()
		p link_to_crawl
		new_links = football_link_extractor(link_to_crawl)
		for link in new_links
			if links_parsed.include?(link) == false && links_to_parse.include?(link) == false
				links_to_parse << link
			end
		end
		links_parsed << link_to_crawl
	end
	return links_parsed
end

link_amasser(seed_page)




# talk it through
# - need to fill up links_to_parse with the seed page
# - then start with the last link and open up that page
# 	- get all the links on that page, then add to links_to_parse IF they arent in there already
# - then pop that link into the links_parsed
# - move on down the line


