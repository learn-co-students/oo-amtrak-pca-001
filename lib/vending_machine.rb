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
    destination_stop = route.find{ |stop| stop["station name"] == destination }
    trip_stops = find_stops(@stationed_at, destination, @route)

    if seats_available? trip_stops, num_tickets
      num_tickets.times { @tickets << Ticket.new(@stationed_at, destination, name)}
      update_route_capacity trip_stops << destination_stop, num_tickets

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

  def find_stops(location, destination, route)
    start_index = route.find_index{|stop| stop["station name"] == location}
    end_index = route.find_index{|stop| stop["station name"] == destination}

    start_index, end_index = end_index, start_index if start_index > end_index

    route[start_index..end_index].delete_if { |stop| stop["station name"] == destination }
  end

  def seats_available? stops, num_tickets
    stops.all?{ |stop| stop["remaining seats"] >= num_tickets }
  end
end

##TODO dont check destination but do affect its count.
## I think this is wrong but itll pass test