require 'spec_helper'

describe Invitation do
  it { expect(subject).to belong_to :inviter }
  it { expect(subject).to validate_presence_of :email }
end
