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
	# lot of technical debt here, should figure out much better way to add terms
	# the current filtering below is TERRIBLY written, but does seem to work for now

	# or we could do it where it had the link_stub and then date format
	# http://profootballtalk.nbcsports.com/YYYY/MM/DD and then the headline

	if  url != nil && url.include?("profootballtalk") == true &&
		url.include?("facebook") == false &&
		url.include?("login") == false &&
		url.include?("mailto") == false &&
		url.include?("twitter") == false &&
		url.include?("archive") == false &&
		url.include?("pft-live") == false &&
		url.include?("rumor") == false &&
		url.include?("home") == false &&
		url.include?("features") == false &&
		url.include?("top-stories") == false &&
		url.include?("videos") == false  # has all PFT videos
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
			profootball_links << link
		end
		profootball_links = profootball_links.uniq
	end
	return profootball_links
end

# p football_link_extractor(seed_page)

# need to be able to handle 404 errors, trying with begin, rescue, end block
	# ^ got it

# think about BREADTH V. DEPTH

	# some thoughts
	# - if were doing a full on crawl, of all PFT ever, sorting may be a little less
	# 	important
	# - we could develop a method to sort URL's by their date, which would prioritize
		# crawling links by recent-ness
		# ^ if we are constantly sorting the links_to_parse list, this may help accomplish it.

testarr = ["http://profootballtalk.nbcsports.com/2014/08/22/report-johnny-manziel-fined-12000-for-flashing-middle-finger/",
			"http://profootballtalk.nbcsports.com/2014/08/19/nfl-wants-super-bowl-halftime-performers-to-pay-for-the-privilege/",
			"http://profootballtalk.nbcsports.com/2014/08/20/mike-ditka-wants-anti-redskins-liberals-to-get-off-his-lawn/"
			]		

# def links_to_parse_sorter(arr)
# 	# best idea is to create a hash with the url as the key
# 	# date can be a value on the hash

# 	# each url is a NEW hash within the overall hash

# 	p arr.sort

# 	for url in arr
# 		link_date = url[37..46]
# 		p link_date
# 	end

# 	# link_stub = "http://profootballtalk.nbcsports.com/"
	
# 	# need index 37-46 for length
# 	# p 

# 	# p link_stub.length

# end

# links_to_parse_sorter(testarr)


def link_amasser(seed_url) #AKA crawler
	links_to_parse = []
	links_parsed = []
	links_to_parse = football_link_extractor(seed_url) 
	while links_to_parse.empty? == false
		p "there are #{links_to_parse.count} links in the links_to_parse array"
		links_to_parse = links_to_parse.sort.reverse
		begin
			link_to_crawl = links_to_parse.shift()
			p link_to_crawl
			new_links = football_link_extractor(link_to_crawl)
			for link in new_links
				if links_parsed.include?(link) == false && links_to_parse.include?(link) == false
					links_to_parse << link
				end
			end
			links_parsed << link_to_crawl
		rescue
			next	
		end
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


