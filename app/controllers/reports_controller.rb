require 'will_paginate/array'

class ReportsController < ApplicationController
    
    def index
      @reports = Report.all 
    end

    def get_inputs    
        @errorArray = []
    end
    
    def post_inputs
        inputArray = []
        @errorArray =[] 
        @errorArray = vaidate_input params[:startDate]["startDate"] , params[:endDate]["endDate"] 
        if(@errorArray.any?)
            render 'get_inputs'
        else    
            params.each do |key,value|
            inputArray.append(value) if((key == "connection" || key == "app" || key == "platform" || key == "country")&&(value !=" "))                           
            end
            ad_revenue = fetch_dao_data params[:startDate]["startDate"], params[:endDate]["endDate"],"ad_revenue",inputArray
            ex_revenue = fetch_dao_data params[:startDate]["startDate"], params[:endDate]["endDate"],"impressions",inputArray
            @dimensions = []
            @dimensions.append("Date")
                inputArray.each do|input|
                @dimensions.append(input)
                end

            @csv = parse_csv_response ad_revenue, ex_revenue, @dimensions
            if(@csv.empty?)
                @errorArray.append ("No data available for given dates") 
                render 'get_inputs'
            end
            @dimensions.append("Ad Revenue")
            @dimensions.append("Impression")
            @dimensions.append("CPM") 
            puts @dimensions         
          
         end
    end

    def vaidate_input startDate, endDate
        error= []
            unless (startDate =="" && endDate="")
                error.append ("Start date is greater than End date")  if(startDate>endDate)
            else
                error.append ("Start Date cannot be Empty") if( startDate== "" )     
                error.append ("End Date cannot be Empty") if(endDate == "" )
            end
        return error;
    end

    def fetch_dao_data (startDate,endDate,value,dimension)
        whereClause = "date between '#{startDate}' and '#{endDate}'"
            case dimension.size
            when 1
            val= Report.where(whereClause).order(date: :asc).group('date',dimension[0]).sum(value)
            when 2
            val= Report.where(whereClause).order(date: :asc).group('date',dimension[0],dimension[1]).sum(value)
            when 3
            val= Report.where(whereClause).order(date: :asc).group('date',dimension[0],dimension[1],dimension[2]).sum(value)
            when 4
            val= Report.where(whereClause).order(date: :asc).group('date',dimension[0],dimension[1],dimension[2],dimension[3]).sum(value)
            when 5
            val= Report.where(whereClause).order(date: :asc).group('date',dimension[0],dimension[1],dimension[2],dimension[3],dimension[4]).sum(value)
            else
            val= Report.where(whereClause).order(date: :asc).group('date').sum(value)
            end
            return val
    end

    def calulcate_cpm adRevenue, impression
        cpm = (adRevenue/(impression.to_d/1000))
    end

    def parse_csv_response ad_response,ex_response, dimension
        csv_array = []
        ad_response.each do |keys, value| 
            report = Report.new
            reportHash = Hash[dimension.zip(keys)] 
            reportHash.each  do |key, val|
                case key
                when "Date" 
                     report.date = val
                when "app" 
                     report.app = val
                when "country" 
                     report.country = val
                when "connection" 
                     report.connection = val
                when "platform" 
                     report.platform = val
                else
                    puts "" 
                end
            end
        report.ad_revenue= value
        report.impressions= ex_response[keys]
        cpm = calulcate_cpm value,ex_response[keys]
        report.cpm= cpm
        csv_array.append(report)
        end
        return csv_array
    end
end
