class Main
  get "/" do
    @seats = Seat.all
    @title = "GitHub CodeConf 2011 Open Seats"
    if @seats.count == 0 then
      redirect '/create'
    end
    haml :home
  end

  get "/create" do
    rows = 17
    cols = 21

    for i in 0..rows
      for j in 0..cols

        s = Seat.new(
          :row => i,
          :col => j,
          :taken => true,
          :created => Time.now
        )

        s.save

      end
    end

    redirect '/'

  end

  get "/seats.json" do
    @seats = Seat.all(:order => [ :row.asc, :col.asc  ])
    data = {}

    currentRow = nil
    temp = nil
    @seats.each do |seat|
      if seat.row != currentRow then
        data[seat.row] = {}
        currentRow = seat.row
      end

      data[seat.row][seat.col] = seat.taken ? (seat.twitter ? seat.twitter : "x") : nil

    end

    content_type :json
    data.to_json
  end

  get "/update/row/:row/col/:col/mark/:taken[/]?" do
    seat = Seat.first(:row => params[:row], :col => params[:col])
    seat.update(:taken => (params[:taken] != 'open'), :twitter => params[:taken], :updated => Time.now)
    if seat.save then
      #redirect '/'
      "#{seat.taken}"
    end
  end
end