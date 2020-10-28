require 'date'

class Common

    def validate_date (date)   
        begin
            return Date.parse(date)
        rescue ArgumentError
            puts "Please Enter valid Date"
            get_inputs
        end
    end

    def compare_date (startDate,endDate)
        if(startDate>endDate) 
            return false 
        else 
            return true
        end
    end

    def get_inputs    
        result = false
        until result do  
            puts "Input needed: Start date and End date"
            puts "Enter the Start Date - Format YYYY-MM-DD"
            startDate = gets.chomp
            startDateV = validate_date (startDate)
            puts "Enter the End Date - Format YYYY-MM-DD"
            endDate = gets.chomp
            endDateV = validate_date (endDate)
            result = compare_date startDateV,endDateV  
            puts "Please Enter valid Date"  unless result
        end
        return Array.[](startDate,endDate)
    end

    def get_dimension
        puts "Please enter the dimension ( values can be : connection, app, platform and country) "
        puts "If you want to generate reports with mlutiple dimension seperate dimension by comma(,)"       
        result =  false   
        until  result do    
         inputDimension = gets.chomp  
         result = validate_dimension (inputDimension)
         puts "Please enter valid dimension" unless  result 
        end 
        return inputDimension
    end

    def validate_dimension inputDimension
    valid = true
    dimensionArray = inputDimension.split(',')
        dimensionArray.each do |dimension|
            if(dimension == "connection" || dimension == "app" || dimension == "platform" || dimension == "country")
                valid = true
            else
                valid =  false
                return valid
            end
        end
    return valid
    end
end