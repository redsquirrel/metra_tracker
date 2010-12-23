require "metra_tracker"
require "time"

describe MetraTracker do
  before(:each) do
    MetraTracker::Mongo.should_receive(:store)
  end
  
  context "in Chicagoland" do
    it "reports in bounds" do
      naperville = ["41.845013", "-88.308105"]
      params = {"latitude" => naperville.first, "longitude" => naperville.last}
      MetraTracker.tell_me_what_is_up(params).should be_in_bounds
    end
    
    context "near Track" do
      it "reports on track in Wheaton" do
        football_field = ["41.867394", "-88.095999"]
        params = {"latitude" => football_field.first, "longitude" => football_field.last}
        MetraTracker.tell_me_what_is_up(params).should be_on_track
      end
      
      it "reports on track in Lombard" do
        prairie_ave = ["41.89220082", "-88.00266736"]
        params = {"latitude" => prairie_ave.first, "longitude" => prairie_ave.last}
        MetraTracker.tell_me_what_is_up(params).should be_on_track
      end
      
      it "reports which line" do
        football_field = ["41.867394", "-88.095999"]
        params = {"latitude" => football_field.first, "longitude" => football_field.last}
        MetraTracker.tell_me_what_is_up(params).line.should == "Union Pacific West"
      end

      it "reports which edge" do
        quarry = [41.898508, -87.958281]
        params = {"latitude" => quarry.first, "longitude" => quarry.last}
        stops = MetraTracker.tell_me_what_is_up(params).between
        stops.should include(:elmhurst)
        stops.should include(:villa_park)
      end      
      
      context "on Train" do
        it "reports on train" do
          Date.stub!(:today).and_return(Date.parse("Dec 20, 2010"))
          Time.stub!(:now).and_return(Time.parse("Dec 20, 2010 8:25am"))
          quarry = [41.898508, -87.958281]
          params = {"latitude" => quarry.first, "longitude" => quarry.last}
          MetraTracker.tell_me_what_is_up(params).should be_on_train
        end
        
        it "reports which train" do
          Date.stub!(:today).and_return(Date.parse("Dec 20, 2010"))
          Time.stub!(:now).and_return(Time.parse("Dec 20, 2010 8:25am"))
          quarry = [41.898508, -87.958281]
          params = {"latitude" => quarry.first, "longitude" => quarry.last}
          MetraTracker.tell_me_what_is_up(params).train.should == 36
        end
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