require 'spec_helper'

describe User do
  it {expect(subject).to have_many :reviews}
  it {expect(subject).to have_many(:queue_items).order :position}
  it {expect(subject).to validate_presence_of :email}
  it {expect(subject).to validate_presence_of :password}
  it {expect(subject).to validate_presence_of :full_name}
  it {expect(subject).to validate_uniqueness_of :email}
end