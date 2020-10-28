require_relative('application_record')
class Report < ApplicationRecord
    validates :date, presence: true 
    validates :country, presence: true
    validates :platform, presence: true
    validates :app, presence: true
    validates :connection, presence: true
    validates :ad_revenue, presence: true
    validates :impressions, presence: true
end
