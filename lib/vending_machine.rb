# code the vending machine class here
require 'pry'
require 'json'
class VendingMachine
  attr_reader :stationed_at, :route, :tickets
  def initialize(path, location)
    @path = path
    @stationed_at = location
    @tickets = []
    @route = self.load_json_file(path)
  end
  def load_json_file(path)
    json = File.read(path)
    JSON.parse(json)
  end
  def route=(update)
    @route
  end
  def tickets=(ticket)
    @tickets
  end

  def purchase_tickets(destination, number_tickets, name)
    no_conflicts_flag = true
    index_of_destination = 0
    index_of_source  = 0
    
    @route.each_with_index do |station,i|
      index_of_destination = i if station["station name"] == destination 
      index_of_source = i if station["station name"] == @stationed_at
    end
    if index_of_destination < index_of_source 
      index_of_source, index_of_destination = index_of_destination, index_of_source
    end
    for i in (index_of_source..index_of_destination)
      if i != index_of_destination && @route[i]["remaining seats"] - number_tickets < 0 
	no_conflicts_flag = false
      end
    end
    if no_conflicts_flag
      for i in (index_of_source..index_of_destination + 1)
          @route[i]["remaining seats"] -= number_tickets
      end
      number_tickets.times{ |i| @tickets << Ticket.new(@stationed_at, destination, name) }
      "Transaction completed, thank you for choosing Amtrak."
    else
      "Tickets can't be purchased because there are not enough seats. We aplogize for the inconvenience."
    end
  end
  
end
