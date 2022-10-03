require "csv"
require_relative "recipe"

class Cookbook
  def initialize(csv_file_path)
    @csv_file_path = csv_file_path
    @recipes = [] # instances of the Class Recipe
    # a method that will load all the date into my CSV
    load_csv
  end

  def load_csv
    CSV.foreach(@csv_file_path) do |row|
      # row = ["Crumpets", "Crumpets description", "10", "5", "true"]
      @recipes << Recipe.new(name: row[0], description: row[1],
                          prep_time: row[2].to_i, rating: row[3].to_f,
                          completed: row[4].strip == "true")
    end
  end

  def save_csv
    CSV.open(@csv_file_path, "wb") do |csv|
      # csv << ["First Name", "Last Name", "Instrument"]
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description, recipe.prep_time,
                recipe.rating, recipe.completed?]
      end
    end
  end

  def mark_as_completed(index)
    recipe = @recipes[index - 1]
    recipe.complete!
  end

  def all
    @recipes
  end

  def add_recipe(new_recipe)
    @recipes << new_recipe
    # a method that will save the CSV file
    save_csv
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    # a method that will save the CSV file
    save_csv
  end
end
