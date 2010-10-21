module Dnif
  module Version
    MAJOR = 0
    MINOR = 1
    PATCH = 0
    BUILD = nil # "beta.6"

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end
