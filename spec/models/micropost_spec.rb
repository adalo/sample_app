require 'spec_helper'

describe Micropost do
  let(:user) { FactoryGirl.create(:user, username: "example") }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { @micropost.user_id = nil }
  	it { should_not be_valid }
  end

  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end


  describe "@replies" do
    let(:sender) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    let(:reply) { Micropost.create(user: sender, content: "@example should see this but other_user should not") }
    before do      
        user.follow!(sender)
        other_user.follow!(sender)
    end

    describe "should appear in recipient's feed" do
      subject { user.feed }
      it { should include(reply) }
    end

    describe "should not appear in other users feeds" do
      subject { other_user.feed }
      it { should_not include(reply) }
    end
  end
end
