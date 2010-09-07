module Dnif

  module Search

    def search(query)
      Dnif.search(query, :classes => self.name)
    end
  end
end