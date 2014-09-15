require 'spec_helper'

describe Monster do
  before do
    @monster = Monster.new(name: "skeleton", flavour_text: "he's got a bone to pick with you")
  end

  subject { @monster }

  it { should respond_to(:name) }
  it { should respond_to(:flavour_text) }

end
