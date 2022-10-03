class View
  def display_list(recipes)
    # 1. brownie
    recipes.each_with_index do |recipe, index|
      p recipe
      status = recipe.completed? ? "X" : " "
      puts "#{index + 1}. [#{status}] - #{recipe.name}"
      puts "         PrepTime: #{recipe.prep_time}m - Rating #{recipe.rating}"
      puts "         Description:  #{recipe.description}"
      puts " "
    end
  end

  def display_and_ask_for_input(results)
    puts "Here are the results:"
    results.each_with_index do |result, index|
      puts "#{index + 1}. #{result[:name]}"
    end
    puts "Which one do you want to add to your cookbook?"
    print ">"
    gets.chomp.to_i
  end

  def ask_for(stuff)
    puts "What is the #{stuff}"
    print ">"
    gets.chomp
  end

  def ask_for_index(stuff)
    puts "Which index do you want to #{stuff}?"
    gets.chomp.to_i
  end
end
