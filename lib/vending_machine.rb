class VendingMachine

  attr_reader :stationed_at
  attr_accessor :tickets, :route

  def initialize(data_file_path, stationed_at)
    @route = load_json_file(data_file_path)
    @stationed_at = stationed_at
    @tickets = []
  end

  def station_index
    find_index(self.stationed_at)
  end

  def load_json_file(file_path)
    JSON.load(File.read(file_path))
  end

  def find_index(station_name)
    route.each_with_index do |station, i|
      return i if station["station name"] == station_name
    end
  end

  def seats_available?(origin_index, destination_index, qty_of_tickets)
    route[origin_index...destination_index].each do |station|
      return false if station["remaining seats"] < qty_of_tickets
    end
    true
  end

  def purchase_tickets(this_destination, qty_of_tickets, name)
    this_origin = self.stationed_at
    origin_index = find_index(this_origin)
    destination_index = find_index(this_destination)

    flipped = false
    if destination_index < origin_index
       origin_index, destination_index = destination_index, origin_index
       flipped = true
    end

    if seats_available?(origin_index, destination_index, qty_of_tickets)
      adjust_num_of_remaining_seats(origin_index, destination_index, qty_of_tickets)
      if flipped
        origin_index, destination_index = destination_index, origin_index
      end
      get_tickets(this_origin, this_destination, name, qty_of_tickets)
      "Transaction completed, thank you for choosing Amtrak."
    else
      "Tickets can't be purchased because there are not enough seats. We aplogize for the inconvenience."
    end
  end

  def adjust_num_of_remaining_seats(origin_index, destination_index, qty_of_tickets)
    self.route.each_with_index do |station, i|
      if origin_index <= i && i <= destination_index
        station["remaining seats"] -= qty_of_tickets
      end
    end
  end

  def get_tickets(origin, destination, name, qty_of_tickets)
    qty_of_tickets.times do
      self.tickets << Ticket.new(origin, destination, name)
    end
  end

end