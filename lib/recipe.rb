class Recipe
  attr_reader :name, :description, :prep_time, :rating

  def initialize(attributes = {})
    @name = attributes[:name]
    @description = attributes[:description]
    @prep_time = attributes[:prep_time]
    @rating = attributes[:rating]
    @completed = attributes[:completed] || false
  end

  def completed?
    @completed
  end

  def complete!
    @completed = true
  end
end

# EXAMPLE
# pizza = Recipe.new(description: "tasty", name: "Super Pizza", prep_time: 10, rating: 4)
