require 'spec_helper'

describe Category do

  it { expect(subject).to have_many :videos }

end
