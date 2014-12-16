require 'spec_helper'

describe Review do

  it { expect(subject).to belong_to :video }
  it { expect(subject).to belong_to :author }
  it { expect(subject).to validate_presence_of :rating }
  it { expect(subject).to validate_presence_of :body }
  it { expect(subject).to validate_presence_of :author }
  
end