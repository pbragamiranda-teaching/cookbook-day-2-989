require "open-uri"
require "nokogiri"
require_relative "view"
require_relative "recipe"

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
  end

  def mark_as_completed
    list
    user_index = @view.ask_for_index("mark as completed")
    @cookbook.mark_as_completed(user_index)
  end

  def list
    # fetch all recipes from cookbook (repository)
    recipes = @cookbook.all
    # display all the recipes (view)
    @view.display_list(recipes)
  end

  def create
    # ask the user name of recipe (view)
    new_name = @view.ask_for("name")
    # ask user for description (view)\
    new_description = @view.ask_for("description")
    new_prep_time = @view.ask_for("prep time")
    new_rating = @view.ask_for("rating")
    # create a new recipe
    new_recipe = Recipe.new(name: new_name, description: new_description,
                          prep_time: new_prep_time, rating: new_rating)
    # send it to my repo to store it (repository / cookbook)
    @cookbook.add_recipe(new_recipe)
  end

  def destroy
    # display all recipes
    list
    # ask user which one to delete by the index (view)
    user_index = @view.ask_for_index("delete")
    # ask repo to delete it (repository / cookbook)
    @cookbook.remove_recipe(user_index - 1)
  end

  def search
    keyword = @view.ask_for("keyword to be searched.")
    url = "https://www.allrecipes.com/search?q=#{keyword}"
    individual_urls = fetch_all_individual_urls(url)
    results = fetch_top_recipes(individual_urls)
    user_input = @view.display_and_ask_for_input(results)
    chosen_hash = results[user_input - 1]
    @cookbook.add_recipe(Recipe.new(chosen_hash))
  end

  def fetch_top_recipes(individual_urls)
    results = []
    individual_urls.first(5).each do |url|
      html_file = URI.open(url).read
      html_doc = Nokogiri::HTML(html_file)
      name = html_doc.search(".article-heading").text.strip
      description = html_doc.search(".article-subheading").text.strip
      prep_time = html_doc.search(".mntl-recipe-details__value").first.text.strip[0..1].to_i
      rating = html_doc.search(".mntl-recipe-review-bar__rating").text.strip[0..2].to_f
      results << { name: name, description: description, prep_time: prep_time, rating: rating }
    end
    results
  end

  def fetch_all_individual_urls(url)
    html_file = URI.open(url).read
    html_doc = Nokogiri::HTML(html_file)
    individual_urls = html_doc.search(".mntl-card-list-items").map do |element|
      element.attribute("href").value if element.attribute("href").value =~ /recipe.\d/
    end
    # remove nil ocurrances
    individual_urls.compact
  end
end
