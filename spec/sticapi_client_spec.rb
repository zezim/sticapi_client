require "spec_helper"

RSpec.describe SticapiClient do
  it "has a version number" do
    expect(SticapiClient::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
