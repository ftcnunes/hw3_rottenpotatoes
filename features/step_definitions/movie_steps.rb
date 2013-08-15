# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  webpage = page.body
  webpage.index(e1).should < webpage.index(e2)
end

Then /^I should see movies ordered by: "(.*?)"/ do |order|
  if order == "Title"
    movies = Movie.find(:all, :order => 'title')
    
    for i in 0..movies.length-2
      step "I should see " + "\"" + movies[i][:title] + "\"" + " before " + "\"" + movies[i+1][:title] + "\""
    end
  elsif order == "Release Date"
    movies = Movie.find(:all, :order => 'release_date')

    for i in 0..movies.length-2
      step "I should see " + "\"" + movies[i][:title] + "\"" + " before " + "\"" + movies[i+1][:title] + "\""
    end
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: "(.*)"/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  aux = Array.new
  aux = rating_list.split(%r{,\s*})
  
  if uncheck.nil?
    aux.each do |rating|
      check("ratings_#{rating}")
    end
  else
    aux.each do |rating|
      uncheck("ratings_#{rating}")
    end
  end
end

Given /^I press 'Refresh'$/ do
  click_button("ratings_submit")
end

Then /^I should( not)? see movies with rating: "(.*)"/ do |not_see, rating_list|
  aux = Array.new
  aux = rating_list.split(%r{,\s*})
  
  movies = Movie.find(:all, :conditions => {:rating => aux}).map { |movie| movie.title }
  
  if not_see.nil?
    movies.each do |movie|
      step "I should see " + "\"" + movie + "\""
    end
  else
    movies.each do |movie|
      step "I should not see " + "\"" + movie + "\""
    end
  end
end

Then /^I should see all of the movies$/ do
  Movie.count.should == page.all("#movies tbody tr").size
end

Given /^I check all ratings$/ do
  # Dummy
end
