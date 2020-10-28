require_relative 'common'
require_relative 'rest_service'
require 'csv'

class GenerateCsv

    def get_inputs
     common=Common.new
     validation=common.get_inputs
     puts "Do you want to generate reports with other dimensions? If Yes Please press 1 or Please press any other key"
            input = gets.chomp 
                if input == "1"  
                    inputDimension = common.get_dimension
                    puts inputDimension
                    validation.append(inputDimension)
                else
                    puts "Report will be generated in the defined date range " 
                end       
    return validation
    end

    def validate_dimension inputDimension
        valid = true
        dimensionArray = inputDimension.split(',')
        dimensionArray.each do |dimension|
            if(dimension == "connection" || dimension == "app" || dimension == "platform" || dimension == "country")
                puts "#{dimension} is valid dimension"
            else
                puts "Please enter the dimension (values can be : connection, app, platform and country) "
               valid = false
            end
        end
        return valid
    end

    def fetch_csv_data startDate, endDate, dimension
        puts "Into fetch data"
        reportsAPi= RestService.new
        ad_revenue =reportsAPi.fetch_csv_data startDate,endDate,"ad_revenue" ,dimension
        ex_revenue =reportsAPi.fetch_csv_data startDate,endDate,"impressions", dimension
        csv_response = reportsAPi.parse_csv_response ad_revenue, ex_revenue
        puts ad_revenue.size
        puts ex_revenue.size
        generate_csv_file(csv_response)
    end

    def generate_csv_file csv_response
        time = Time.new
        file_name = "report-csv-#{time.day}-#{time.month}-#{time.day}-#{time.min}.csv"
        CSV.open(file_name, "wb") do |csv|
            csv_response.each do |data|
            csv << data
            end
        end
    end
end

puts "Welcome to CSV File Generator Application"
generateCsv = GenerateCsv.new
inputData = generateCsv.get_inputs
generateCsv.fetch_csv_data inputData.at(0),inputData.at(1), inputData.at(2)
