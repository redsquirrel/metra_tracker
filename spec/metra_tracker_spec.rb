require "metra_tracker"

describe MetraTracker do
  before(:each) do
    MetraTracker.should_receive(:store_in_mongo)
  end
  
  context "in Chicagoland" do
    it "reports in bounds" do
      naperville = ["41.845013", "-88.308105"]
      params = {"latitude" => naperville.first, "longitude" => naperville.last}
      MetraTracker.tell_me_what_is_up(params).should be_in_bounds
    end
    
    context "near Track" do
      it "reports on track" do
        football_field = ["41.867394", "-88.095999"]
        params = {"latitude" => football_field.first, "longitude" => football_field.last}
        MetraTracker.tell_me_what_is_up(params).should be_on_track
      end
      
      it "reports which line" do
        football_field = ["41.867394", "-88.095999"]
        params = {"latitude" => football_field.first, "longitude" => football_field.last}
        MetraTracker.tell_me_what_is_up(params).line.should == "Union Pacific West"
      end
    end
    
    context "far from Track" do
      it "reports off track" do
        intersection = ["41.859222", "-88.10252"]
        params = {"latitude" => intersection.first, "longitude" => intersection.last}
        MetraTracker.tell_me_what_is_up(params).should_not be_on_track
      end
    end
  end
  
  context "outside Chicagoland" do
    it "reports out of bounds" do
      gary = ["41.574361", "-87.297363"]
      MetraTracker.tell_me_what_is_up("latitude" => gary.first, "longitude" => gary.last).should_not be_in_bounds
    end
  end
end