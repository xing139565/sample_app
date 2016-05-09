require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe Relationship do
    let(:follower) { FactoryGirl.create(:user) }
    let(:followed) { FactoryGirl.create(:user) }
    let(:relationship) { follower.relationships.build(followed_id: followed.id) }
    subject { relationship }
    it { should be_valid }
  end
end
