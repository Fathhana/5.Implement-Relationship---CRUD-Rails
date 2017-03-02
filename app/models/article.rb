class Article < ActiveRecord::Base

  validates :title, presence: true,

                      length: { minimum: 5 }

  validates :content, presence: true,

                      length: { minimum: 10 }

  validates :status, presence: true


  default_scope {where(status: 'active')}

  #name relation must plural
  has_many :comments, dependent: :destroy




def self.to_csv(options = {})
  CSV.generate(options) do |csv|
    csv << column_names
    all.each do |article|
      csv << article.attributes.values_at(*column_names)
    end
  end
end




def self.import(file)
  if file.nil?
  else
  allowed_attributes = [ "id","title","content","created_at","updated_at"]
  spreadsheet = open_spreadsheet(file)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    article = find_by_id(row["id"]) || new
    article.attributes = row.to_hash.select { |k,v| allowed_attributes.include? k }
    article.save!
  end
  end
end

def self.open_spreadsheet(file)
  case File.extname(file.original_filename)
  when ".csv" then Roo::CSV.new(file.path, packed: false, file_warning: :ignore)
  when ".xls" then Roo::Excel.new(file.path, packed: false, file_warning: :ignore)
  when ".xlsx" then Roo::Excelx.new(file.path, packed: false, file_warning: :ignore) 
  else raise "Unknown file type: #{file.original_filename}"
  end
end




end
