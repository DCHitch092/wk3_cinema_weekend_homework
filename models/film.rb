require('pry')
require_relative('../db/SqlRunner')
require_relative('../models/screening')

class Film

  attr_reader :id, :title, :price

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save()
    sql = "INSERT INTO films
    ( title, price)
    VALUES
    ($1, $2)
    RETURNING id"
    values = [@title, @price]
    result = SqlRunner.run(sql, values).first
    @id = result['id'].to_i
  end

  def update()
    sql = "UPDATE films
    SET
    title = $1, price = $2
    WHERE id = $3 "
    values = [@title, @price, @id]
    SqlRunner.run(  sql, runner)
  end

  def delete()
    sql = "DELETE FROM films
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(  sql, values)
  end

  def check_customers()
    sql = "SELECT customers.* FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    WHERE tickets.film_id = $1"
    values = [@id]
    result = SqlRunner.run( sql,  values)
    return result.map { |customer| Customer.new(customer)}
  end

  def most_popular_time()
      #gets an data of screenings for this film
      screening_list = screenings_select()

      #maps screenings data to an array
      array_list = screening_list.map{|screening| Screening.new(screening)}

      #sorts screenings array by seats
      array_list.sort!{|screenings| screenings.seats}

      #returns number of seats that is equivalent to the most booked up screening(s) i.e. the first result
      least_available_seats = array_list[0]

      # most_sales = seats_list.min()

      #creates variable 'results' with data that matches the most tickets sold
      results = screening_by_seats(least_available_seats.seats)

      #returns this list of screenings as an array
      return results.map{ |screening| Screening.new(screening)}
  end

  def screenings_select()
    sql = "SELECT * FROM screenings
    WHERE film_id = $1"
    values = [@id]
    return SqlRunner.run( sql, values)
  end

  def screening_by_seats(num)
    sql = "SELECT * FROM screenings
    WHERE seats = $1 AND film_id = $2"
    values = [num, @id]
    return SqlRunner.run( sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)

  end


end
