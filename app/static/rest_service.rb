require 'rest-client'
require 'json'  
require_relative 'report_dao'

class RestService
     #'https://api.libring.com/v2/reporting/get?start_date=#{startDate}&end_date=2018-02-15&group_by=app,connection,platform,country&data_type=adnetwork&allow_mock=true',

    #REPORTSURL= "https://api.libring.com/v2/reporting/get?"
    #REQUESTPARAM = "period=yesterday&group_by=app,connection,platform,country&data_type=adnetwork&allow_mock=true"
    #REQUESTPARAM = "&period=custom_date&group_by=app,connection,platform,country&data_type=adnetwork&allow_mock=true"
    def call_reports_api (startDate,endDate,url)
        #requestUrL = REPORTSURL+ "start_date="+ startDate +"&end_date="+ endDate+ REQUESTPARAM
        #requestUrL = REPORTSURL+ REQUESTPARAM
        #puts requestUrL
        begin
            response = RestClient::Request.new( :method => :get,:url =>  url,       
            :headers => {'Content-Type' => 'application/json','Authorization' => 'Token DHDwhdFXfoGBYLPOZPvTTwJoS'},
            :verify_ssl => true
            ).execute
            results = JSON.parse(response.to_str)
            puts "Data Received from Reporting API. Data being processed into DataBase.. "
            return results
        rescue => e
           puts "Error in Fetching Data from Reporting API. Please try again later.." 
        end
    end  

    def parse_reports_response (response)
       noOfRecord = response['current_page_rows']
       puts "There are #{noOfRecord} records avaliable foe reporting"
       if(response['connections'].empty?) 
        puts "There is no data from reporting api"
        else
           reportDao= ReportDao.new        
           reportDao.insert_into_db (response)
           puts " #{noOfRecord} records inserted into DB" 
        end
      
    end

    def fetch_csv_data startDate, endDate, value ,inputDimension
        report = ReportDao.new  
        dimension= inputDimension.split(',')
        case inputDimension.split(',').length   
        when 1
        val = report.fetch_csv_data startDate, endDate,value,dimension[0]
        when 2
        val = report.fetch_csv_data startDate, endDate,value,dimension[0],dimension[1]
        when 3
        val = report.fetch_csv_data startDate, endDate,value,dimension[0],dimension[1],dimension[2]
        when 4
        val = report.fetch_csv_data startDate, endDate,value,dimension[0],dimension[1],dimension[2],dimension[3]
        when 5
        val = report.fetch_csv_data startDate, endDate,value,dimension[0],dimension[1],dimension[2],dimension[3],dimension[4]
        else
        val = report.fetch_csv_data startDate, endDate,value
        end
        return val
    end

    def parse_csv_response ad_response,ex_response
        csv_array = []
        ad_response.each do |keys, value| 
        csv_data = []
        keys.each do |key|
            csv_data.append(key)
        end
        csv_data.append(value)
        csv_data.append(ex_response[keys])
        csv_array.append(csv_data)
        end
        return csv_array
    end
end
