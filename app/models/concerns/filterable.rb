module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_exact(filtering_params)
      results = self.where(nil)
      filtering_params.each do |key, value|
        results = results.where("#{key}": value) if !value.blank?
      end
      results
    end
    def filter_like(filtering_params)
      results = self.where(nil)
      filtering_params.each do |key, value|
        # results = results.where("#{key} LIKE ?", "%#{value}%") if !value.blank? # sqlite3
        results = results.where("#{key} ILIKE ?", "%#{value}%") if !value.blank? # PG
      end
      results
    end
  end
end
