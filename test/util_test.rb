require File.join(File.dirname(__FILE__), 'test_helper')

describe "Util" do
  it "#to_query generates correct string" do
    Wolfram::Util.to_query('moo', 'sound').should == 'sound=moo'
  end

  it "#to_param generates correct_string" do
    Wolfram::Util.to_param(:appid => 'xxx', :input => 'from ny to boston').should ==
      "appid=xxx&input=from+ny+to+boston"
  end

  describe "#module_get" do
    before_all { eval %[module Blah; end] }

    it "creates a new module if it doesn't exist" do
      Wolfram::Util.module_get(Blah, 'One').should == Blah::One
    end

    it "returns existing module" do
      Wolfram::Util.module_get(Blah, 'Two')
      Wolfram::Util.module_get(Blah, 'Two').should == Blah::Two
    end
  end
end
