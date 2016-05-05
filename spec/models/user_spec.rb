require 'rails_helper'

RSpec.describe User, type: :model do
  
  before { @user = User.new(name:"Example User",email:"user@example.com",
                            password:"foobar",
                            password_confirmation:"foobar"
                                                      ) }

  # 模型测试
  
  subject{ @user }

  it { should respond_to(:name) }
  # 还可以写成
  # it "should respond to 'name'" do
  #   expect(@user).to respond_to(:name)
  # end
  # 但因为这里已经指定了subject{ @user }

  it { should respond_to(:email) }

  # 验证加密
  it { should respond_to(:password_digest) }

  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }


  # 验证name属性的失败测试

  it { should be_valid }
  #同上
  # it "should be valid" do
  #   expect(@user).to be_valid
  # end

  describe "when name is not present"do
    before { @user.name = "" }
    it { should_not be_valid }
  end

  describe "when email is not present"do
    before { @user.email = "" }
    it { should_not be_valid }
  end

  # 长度验证测试
  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  # 验证email
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end 
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  #验证唯一性
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  # 加密
  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  # 验证密码
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it { should_not eq user_for_invalid_password }
      # specify { expect(user_for_invalid_password).to be_false }
    end
  end


end