require('pry')
require_relative('../db/SqlRunner')
require_relative('../models/film')

class Customer

  attr_accessor :name, :funds
  attr_reader :id

  def initialize (options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save()
    sql= "INSERT INTO customers
    ( name, funds  )
    VALUES
    (   $1, $2    )
    RETURNING id"
    values = [@name, @funds]
    result = SqlRunner.run(sql, values).first
    @id = result['id'].to_i
  end

  def update()
    sql = "UPDATE customers
    SET name = $1, funds = $2
    WHERE
    id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  # def check_films()
  #   sql = "SELECT films.* FROM films
  #   INNER JOIN tickets
  #   ON tickets.film_id = films.id
  #   WHERE tickets.customer_id = $1"
  #   values = [@id]
  #   results = SqlRunner.run(sql, values).first
  #   return results.map{ |film| Film.new(film)}
  # end

  #
  # def buy_ticket()
  # end


  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

end
