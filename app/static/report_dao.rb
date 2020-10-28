require 'date'
require_relative '../models/report.rb'
require_relative '../models/application_record.rb'

class ReportDao

    def get_DB_connection
        ActiveRecord::Base.establish_connection(
            adapter: 'sqlite3',
            database: 'C:\sundar\app-annie\app-annie-project\db\development.sqlite3'
          )
    end      

    def insert_into_db (response)
       get_DB_connection
        response['connections'].each do |connection|  
            reportData = Report.new
            reportData.date = Date.parse(connection ['date'])
            reportData.country =  connection ['country']
            reportData.platform = connection ['platform']
            reportData.app = connection ['app']
            reportData.connection = connection ['connection']
            reportData.ad_revenue = connection ['ad_revenue'].to_f
            reportData.impressions = connection ['impressions'].to_f
            reportData.save
        end
    end

    def fetch_csv_data (startDate,endDate,value,*dimension)
    get_DB_connection
    reportData = Report.new
    whereClause = "date between '#{startDate}' and '#{endDate}'"
       puts dimension.length  
        case dimension.length   
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
end


