class Seat
  include DataMapper::Resource

  property :id, Serial
  property :row, Integer
  property :col, Integer
  property :taken, Boolean, :default => true
  property :created, DateTime
  property :updated, DateTime

end