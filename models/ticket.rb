require('pry')
require_relative('../db/SqlRunner')

class Ticket

  attr_reader :id, :customer_id, :film_id, :screening_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
    @screening_id = options['screening_id'].to_i
  end

  def save()
    sql = "INSERT INTO tickets
    ( customer_id, film_id, screening_id)
    VALUES
    ( $1, $2, $3)
    RETURNING id"
    values = [ @customer_id, @film_id, @screening_id]
    result = SqlRunner.run(sql, values).first
    @id = result['id'].to_i
  end

  def update()
    sql = "UPDATE tickets
    SET customer_id = $1,
    film_id = $2
    WHERE id = $3"
    values = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets
    where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.check_film_ticket_total(film_title)
    film = self.find_film_by_title(film_title)
    self.film_total(film['id'])
  end

  def self.find_film_by_title(film_title)
    sql = "SELECT * from films
    WHERE title = $1"
    values = [film_title]
    result = SqlRunner.run(  sql,  values).first
    return result
  end

  def self.film_total(film_id)
    sql = "SELECT * FROM tickets
    WHERE film_id = $1"
    values = [film_id]
    results = SqlRunner.run(  sql,  values)
    array = results.map{ |result| Film.new(result)}
    return array.length
  end


  def self.check_customer_ticket_total(customer_name)
    customer = self.find_customer_by_name(customer_name)
    self.customer_total(customer['id'])
  end

  def self.find_customer_by_name(customer_name)
    sql = "SELECT * from customers
    WHERE name = $1"
    values = [customer_name]
    result = SqlRunner.run(  sql,  values).first
    return result
  end

  def self.customer_total(customer_id)
    sql = "SELECT * FROM tickets
    WHERE customer_id = $1"
    values = [customer_id]
    results = SqlRunner.run(  sql,  values)
    # binding.pry
    array = results.map{ |result| Customer.new(result)}
    return array.length
  end

  def self.delete_all
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end


end
