require_relative 'common'
require_relative 'rest_service'

class FetchData

    REPORTSURL= "https://api.libring.com/v2/reporting/get?"
    REQUESTPARAM = "&period=custom_date&group_by=app,connection,platform,country&data_type=adnetwork&allow_mock=true"
    def fetch_reporting_data (startDate,endDate)
        requestUrL = REPORTSURL+ "start_date="+ startDate +"&end_date="+ endDate+ REQUESTPARAM
        reportsAPi= RestService.new
        response = reportsAPi.call_reports_api startDate, endDate, requestUrL
        reportsAPi.parse_reports_response(response)  
        if(response['total_pages'] !=response['current_page'] && response["next_page_url"] !="")
           puts "Processing next page response..."
           response = reportsAPi.call_reports_api startDate, endDate, response["next_page_url"]
           reportsAPi.parse_reports_response(response)
        end

    end

    def getInputForReports
        puts "Welcome to Reporting Application"
        common=Common.new
        validation=common.get_inputs
        fetch_reporting_data validation.at(0),validation.at(1)
    end

end

fetchData = FetchData.new
fetchData.getInputForReports
puts "You can now generete the reporting csv file or view reports in Reporting Application"
