# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(:title => movie[:title], :release_date => movie[:release_date], :rating => movie[:rating])
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
# on the same page
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  # ensure that that e1 occurs before e2 and that there is no case 
  # where an e2 occurs before e1 (if there were multiple instances of e1 and e2)
  expect(/.*#{e1}.*#{e2}.*/m.match?(page.body) && !/.*#{e2}.*#{e1}.*/m.match?(page.body)).to be true
end

Then /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  action = uncheck ? "uncheck" : "check"
  rating_list.split(' ').each { |rating|
    steps %Q{Then I #{action} "ratings_#{rating}"}
  }
end

Then /I should see the following movies: "(.*)"/ do |movies|
  movies.split(', ').each { |movie|
    steps %Q{Then I should see "#{movie}"}
  }
end

Then /I should not see the following movies: "(.*)"/ do |movies|
  movies.split(', ').each { |movie|
    steps %Q{Then I should not see "#{movie}"}
  }
end

# Make sure that all the movies in the app are visible in the table 
# by comparing the number of rows in the table to the number of movies in the db
Then /I should see all the movies/ do
  all('table#movies tbody tr').count.should == Movie.all.count
end
