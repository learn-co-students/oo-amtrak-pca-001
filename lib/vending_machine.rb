require "json"
require "pry"

class VendingMachine

  attr_reader :stationed_at, :tickets
  attr_accessor :route

  @@sorry = "Tickets can't be purchased because there are not enough seats. We aplogize for the inconvenience."

  def initialize(path, stationed_at)
    @path = path
    @stationed_at = stationed_at
    @tickets = []
    @route = load_json_file(path)
  end

  def load_json_file(path)
    file = File.read(path)
    JSON.parse(file)
  end

  def purchase_tickets(destination, tix, names)
    return @@sorry if enough_tickets?(destination, tix) == false

    @route.each do |hash|
      if hash["station name"] == destination
        tix.times { @tickets << Ticket.new(@stationed_at, destination, names) }
      end
    end
    index_array(destination).each { |i| @route[i]["remaining seats"] -= tix }
    "Transaction completed, thank you for choosing Amtrak."
  end

  # returns index of destination station
  def destination_index(destination)
    @route.each_with_index do |hash, i|
      return i if hash.value?(destination)
    end
  end

  # returns index of origin station
  def origin_index
    @route.each_with_index do |hash, i|
      return i if hash.value?(@stationed_at)
    end
  end

  # returns an array of indexs for origin through destination
  # regardless of north/south
  def index_array(destination)
    index_array = (destination_index(destination)..origin_index).to_a
    if index_array == []
      index_array = (origin_index..destination_index(destination)).to_a
    end
    index_array
  end

  # checks whether there are enough tickets or not
  def enough_tickets?(destination, tix)
    indexed_array = index_array(destination)
    indexed_array.pop
    indexed_array.each do |i|
      return false if @route[i]["remaining seats"] < tix
    end
  end
end