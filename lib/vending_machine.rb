require "json"
require "ticket.rb"
require "pry"
class VendingMachine
  attr_reader :stationed_at, :tickets
  attr_accessor :route

  def initialize(path, location)
    @path = path
    @stationed_at = location
    @tickets = []
    @route = load_json_file path
  end

  def load_json_file(path)
    file = File.read path
    JSON.parse file
  end

  def purchase_tickets(destination, num_tickets, name)
    trip_stops = find_stops(@stationed_at, destination, @route)

    if trip_stops.all? { |stop| stop["remaining seats"] >= num_tickets }
      num_tickets.times { @tickets << Ticket.new(@stationed_at, destination, name)}
      update_route_capacity trip_stops, num_tickets

      "Transaction completed, thank you for choosing Amtrak."
    else
      "Tickets can't be purchased because there are not enough seats. We apologize for the inconvenience."
    end
  end

  def update_route_capacity(stops, num_tickets)
    stops.each do |stop|
      stop["remaining seats"] -= num_tickets
    end
  end

  # Returns stops that need to have available seats
  # Currently leaves off the destination, since the passenger is getting off there
  # Some tests seem to want this destination to also have its seating reduced
  # need to investigate
  def find_stops(location, destination, route)
    start_index = route.find_index{|stop| stop["station name"] == location}
    end_index = route.find_index{|stop| stop["station name"] == destination}

    # Account for going the opposite directoin
    if start_index < end_index
      trip_length = end_index - start_index
    else
      # binding.pry
      trip_length = start_index - end_index
      start_index = end_index
    end
    # binding.pry
    route.slice(start_index, trip_length)
  end
end
