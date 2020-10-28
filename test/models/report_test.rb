require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup 

    @reportData = Report.new
    @reportData.app ="2.0"
    @reportData.date = "2020-11-10"
    @reportData.country = "Netherlands"
    @reportData.platform = "ios" 
    @reportData.connection = "Mock Connection"
    @reportData.ad_revenue = 100.1
    @reportData.impressions =  1000
    @reportData.save

  end
  
  test "data should be present"  do
    @reportData.app =""
    @reportData.date = ""
    @reportData.country = ""
    @reportData.platform = "" 
    @reportData.connection = ""
    @reportData.ad_revenue = ""
    @reportData.impressions = ""
    assert_not @reportData.valid?
  end

  test "check if data is inserted" do
    @reportData.app ="2.0"
    @reportData.date = "2020-11-10"
    @reportData.country = "Netherlands"
    @reportData.platform = "ios" 
    @reportData.connection = "Mock Connection"
    @reportData.ad_revenue = 502.3
    @reportData.impressions =  80874.0
    assert @reportData.save
  end

  test "check if group by is working" do
    startDate = "2020-11-10"
    endDate = "2020-11-13"
    @group=Report.where("date between #{startDate} and #{endDate}").order(date: :asc).group('date','app').sum(:ad_revenue)
    assert @group.value?
  end

end
 