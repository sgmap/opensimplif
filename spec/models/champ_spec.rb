require 'rails_helper'

describe Champ do
  require 'models/champ_shared_example.rb'

  it_behaves_like 'champ_spec'
end
