class Post < ActiveRecord::Base

  define_index do
    field :title
    attribute :published_at, :type => :datetime
    attribute :draft, :type => :boolean
  end
end

class Comment < ActiveRecord::Base

  define_index do
    field :full_author
  end

  def full_author
    "full author name"
  end
end