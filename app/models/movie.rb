class Movie < ActiveRecord::Base


  def self.possible_ratings
    %w[G PG PG-13 R]
  end
end
