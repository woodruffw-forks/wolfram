require File.join(File.dirname(__FILE__), 'test_helper')

describe "Wolfram" do
  def wolfram(input)
    Wolfram.run input.split(/\s+/)
  end

  describe "#run" do
    it "with no query returns usage" do
      capture_stdout { wolfram('') }.should =~ /^Usage: wolfram/
    end

    it "with normal query returns output" do
      mock(Wolfram::Query).fetch(anything) { 
        File.read(File.expand_path(File.dirname(__FILE__) + '/fixtures/boston.xml'))
      }
      capture_stdout { wolfram 'boston' }.should =~ /boston/i
    end

    it "with invalid response prints error" do
      mock(Wolfram::Query).fetch(anything) { ' ' }
      capture_stderr { wolfram 'boston' }.should =~ /^Wolfram Error:.*queryresult/
    end
  end
end
