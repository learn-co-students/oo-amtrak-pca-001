
class Ticket
  attr_reader :origin, :destination, :name
  def initialize origin, destination, passenger_name
    @origin = origin
    @destination = destination
    @name = passenger_name
  end
end