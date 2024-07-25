require 'nokogiri'

module RedmineCkeditor
  module CsvExportPatch

        def <<(row)
          row = row.map do |field|
            case field
            when String
              # Strip HTML tags
              field = Nokogiri::HTML(field).text
              Redmine::CodesetUtil.from_utf8(field, self.encoding.name)
            when Float
              @decimal_separator ||= l(:general_csv_decimal_separator)
              ("%.2f" % field).gsub('.', @decimal_separator)
            else
              field
            end
          end
          super(row)
        end
  end
end

Redmine::Export::CSV::Base.include RedmineCkeditor::CsvExportPatch
