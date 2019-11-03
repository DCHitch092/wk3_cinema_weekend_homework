require('pry')
require_relative('../db/SqlRunner')
require_relative('../models/film')
require_relative('../models/ticket')
require_relative('../models/screening')

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

  def check_films()
    sql = "SELECT films.* FROM films
    INNER JOIN tickets
    ON tickets.film_id = films.id
    WHERE tickets.customer_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map{ |film| Film.new(film)}
  end

  def buy_ticket(film_title, screening_time)
    #finds film and screening entries
    film = find_film_id_by_title(film_title)
    screening = find_screening_id_by_time(screening_time)

    #checks ticket availability in screening
    return "no tickets available" if check_seats(screening) == false

    #creates a new ticket entry in tickets table
    created_ticket = reserve_ticket(film, screening)

    # remove_ticket_from_availability()
    Screening.remove_ticket_from_availability(screening['id'].to_i, screening['seats'].to_i)

    #saves ticket entry
    created_ticket.save()

    # finds the film price
    film_price = film['price'].to_i

    # checks customer can afford
    return "insufficient funds" if @funds < film_price

    #reduces customers funds
    self.reduce_customer_funds(film_price)

    #defines ticket as bought
    # Ticket.status_bought(created_ticket['id'])
    created_ticket.status = "bought"

    #  = {'status' => 'bought'}
    # # # created_ticket['status'] = "bought"
    created_ticket.update()

    return "Ticket bought for #{film_title} for £#{film_price}"
  end

  def reserve_ticket(film, screening)
    created_ticket = Ticket.new('customer_id' => self.id, 'film_id' => film['id'], 'screening_id' => screening['id'], 'status' => "reserved")
  end


  def check_seats(screening)
      return true if screening['seats'].to_i >= 0
      return false
  end

  def find_screening_id_by_time(screen_time)
    sql = "SELECT screenings.* FROM screenings
    WHERE time = $1"
    values = [screen_time]
    return SqlRunner.run( sql, values).first
  end

  def find_film_id_by_title(film_title)
    sql = "SELECT films.* FROM films
    WHERE title = $1"
    values = [film_title]
    return SqlRunner.run(  sql,  values).first
  end

  def reduce_customer_funds(amount)
    self.funds -= amount
    self.update()
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

end
