# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  # assert false, "Unimplmemented"
  assert movies_table.hashes.size == Movie.all.size, "Count of movies does not match"

  # p Movie.all
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see (.*) before (.*)/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  # p page.body
  # p 'fjklwelgkaweglka'

  # regex = /.*#{e1}.*#{e1}/

  # matches = page.body =~ regex

  assert page.body.index(e1) < page.body.index(e2), "Expected to see #{e1} before #{e2}"

  # p "match: #{!matches}"

  # assert matches, "Expected to see #{e1} before #{e2}"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Given /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rList = rating_list.split(/,\s*/i)
  if uncheck
    rList.each { |rating|
      uncheck("ratings_#{rating}")
    }
  else
    # p "Ratings: #{rList}"
    rList.each { |rating|
      check("ratings_#{rating}")
    }
  end

  step %{I press ratings_submit}

end

Then /I should see all of the movies/ do
  movieSize = Movie.all.size
  
  rows = page.find(:xpath, '//table[@id="movies"]/tbody').all(:xpath, './/tr')

  # rows.each { |row|
  #   p "#{row.text}"
  # }

  # p "rows = #{rows.size}; movies = #{Movie.all.size}"

  # assert rows.size == 0, "Count of movies does not match"

  assert rows.size == Movie.all.size, "Count of movies does not match"

  p movieSize
end

Then /I should (not )?see the following ratings: (.*)/ do |visible, rating_list|
  rList = rating_list.split(/,\s*/i)
  visBool = (visible != "not ")
  # p "#{visible.class}=#{visBool}"

  # p rList.include?("R")

  page.all(:css, "table#movies tbody tr td[2]").each { |rating| 
    p "#{rating.path}"
    # p "#{rating.text.class} :: #{rList} :: #{rList.include?(rating.text)} :: #{visBool}"
    assert rList.include?(rating.text) == visBool, "Bad movie in list"
  }
end

When /^(?:|I )press (.*)$/ do |button|
  click_button(button)
end

When /I sort movies alphabetically/ do

  step %{I follow "title_header"}
  # assert true
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end
