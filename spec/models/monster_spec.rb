require 'spec_helper'

describe Monster do
  before do
    @monster = Monster.new(name: "skeleton")
  end

  subject { @monster }

  it { should respond_to(:name) }
  it { should respond_to(:image_path) }

end
