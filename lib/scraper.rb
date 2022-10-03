require "open-uri"
require "nokogiri"
require_relative "recipe"

# HIGH LEVEL PSEUDOCODE
# 1. Fecth the main search page, interpolating and keyword
# 2. Need to search for indivual links for each card and store the links in an array
# 3. Need to iterate over the array, and make a new request for each individual link
# 4. Once in individual page, I need to scrape the data I need

# get input from the user
ingredient = gets.chomp
# interpolate as a search
url = "https://www.allrecipes.com/search?q=#{ingredient}"

# open and read website
html_file = URI.open(url).read
# parse website into a Nokogiri object
html_doc = Nokogiri::HTML(html_file)

indivual_urls = []

# iterate over search results to fetch href links for each card
html_doc.search(".mntl-card-list-items").each do |element|
  # check if the card is an actual recipe or gallery / article
  if element.attribute("href").value =~ /recipe.\d/
    # add individual hrefs to array
    indivual_urls << element.attribute("href").value
  end
end

results = []

# iterate over each individual url
indivual_urls.first(5).each do |individual_url|
  # open and read website
  html_file = URI.open(individual_url).read
  # interpolate as a search
  html_doc = Nokogiri::HTML(html_file)
  # find name
  name = html_doc.search(".article-heading").text.strip
  # find description
  description = html_doc.search(".article-subheading").text.strip
  # find prep time and convert to integer
  prep_time = html_doc.search(".mntl-recipe-details__value").first.text.strip[0..1].to_i
  # find rating and convert to float
  rating = html_doc.search(".mntl-recipe-review-bar__rating").text.strip[0..2].to_f
  # push hash with proper attributes inside results array
  results << { name: name, description: description, prep_time: prep_time, rating: rating }
end

puts "Here are the results:"

# print the results to the user
results.each_with_index do |result, index|
  puts "#{index + 1}. #{result[:name]}"
end

puts "Which one do you want to add to your cookbook?"
print ">"
user_input = gets.chomp.to_i

# access the array I need to get the info to create a new Recipe and send to cookbook
chosen_hash = results[user_input - 1]

# create new Recipe instance
p Recipe.new(chosen_hash)
