require 'rubygems'
require 'sinatra'
require 'logger'
require 'haml'
require 'sinatra/content_for2'

helpers Sinatra::ContentFor2

get '/' do
  haml :home
end

=begin
require 'dm-core'
require 'dm-migrations'
require 'dm-migrations'
require 'dm-timestamps'
require 'json/pure'

@saltKey = "@codeconf"

helpers do
  def allowed_to_proceed()
    cookieValue = request.cookies["slug"]
    compare = Digest::SHA1.hexdigest("--#{@saltKey}--auth--")
    if cookieValue == compare then
      true
    else
      false
    end
  end

  def set_cookie()
    @authValue = Digest::SHA1.hexdigest("--#{@saltKey}--auth--")
    response.set_cookie('slug', :value => @authValue, :expires => Time.now + (60 * 2))
  end
end

class Seat
  include DataMapper::Resource
  property :id, Serial
  property :loc, String
  property :row, Integer
  property :seat, Integer
  property :twitter, String
  property :taken, Boolean, :default => true
  property :created, DateTime
  property :updated, DateTime
end

configure do
  #DataMapper::Logger.new('tmp/seatr-debug.log', :debug)
  DataMapper::setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/db/development.db")
  DataMapper.finalize
  #DataMapper.auto_migrate!
  DataMapper.auto_upgrade!
end



get "/" do
  set_cookie()
  @seats = Seat.all
  @title = "Open Seats"
  if @seats.count == 0 then
    redirect '/create'
  end
  haml :home
end

get "/create" do
  if allowed_to_proceed() then
    rows = 17
    cols = 21
    for i in 0..rows
      for j in 0..cols
        seatLoc = "seat-#{i}-#{j}"
        existingSeats = Seat.first(:loc => seatLoc)
        if !existingSeats then
          s = Seat.new(
            :loc => seatLoc,
            :row => i,
            :seat => j,
            :taken => true,
            :created => Time.now
          )
          s.save
        end
      end
    end
    redirect '/'
  else
    "hmm... let me about that think"
  end
end

get "/open" do
  @title = "Open Rows"
  @seats = Seat.all(:taken => false)
  haml :open, :layout => :mobile
end

get "/seats.json" do
  data = {}
  if allowed_to_proceed() then
    @seats = Seat.all(:order => [ :loc.asc ])
    @seats.each do |seat|
      data[seat.loc] = {}
      data[seat.loc]["taken"] = seat.taken
      data[seat.loc]["twitter"] = seat.twitter
    end
  else
    data["error"] = 'tsk..tsk!';
  end

  content_type :json
  data.to_json
end

get "/update/:loc/mark/:taken[/]?" do
  if allowed_to_proceed() then
    seat = Seat.first(:loc => params[:loc])
    seat.update(
        :taken => (params[:taken] != 'open'),
        :twitter => params[:taken],
        :updated => Time.now
    )
    if seat.save then
      "#{seat.taken}"
    end
  else
    "really?!"
  end
end
=end