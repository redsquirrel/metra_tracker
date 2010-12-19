$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "../lib"))
require "metra_tracker"


describe MetraTracker do
  before do
    MetraTracker.should_receive(:store_in_mongo)
  end
  
  context "in Chicagoland" do
    naperville = ["41.845013", "-88.308105"]
    it "reports in bounds" do
      MetraTracker.tell_me_what_is_up("latitude" => naperville.first, "longitude" => naperville.last).should be_in_bounds
    end
  end
  
  context "outside Chicagoland" do
    gary = ["41.574361", "-87.297363"]
    it "reports out of bounds" do
      MetraTracker.tell_me_what_is_up("latitude" => gary.first, "longitude" => gary.last).should_not be_in_bounds
    end
  end
end