class Model
  include DataMapper::Resource
  property    :id,              Integer,    :serial => true
  property    :name,            Text,       :nullable => false
  property    :created_at,      DateTime
  property    :updated_at,      DateTime
  property    :title,           String
  property    :slug,            String

  before      :save, 
              :generate_slug_from_title

  def generate_slug_from_title
    self.slug = title.downcase.gsub(/[^a-z0-9]/,'-').squeeze('-').gsub(/^\-|\-$/,'')
  end

end

