require('pry')

class Screening

  attr_reader :id
  attr_accessor :seats, :time, :film_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @time = options['time']
    @film_id = options['film_id'].to_i
    @seats = options['seats'].to_i
  end

  def save()
    sql = "INSERT INTO screenings
    ( time, film_id, seats)
    VALUES
    ( $1, $2, $3)
    RETURNING id"
    values = [@time, @film_id, @seats]
    result = SqlRunner.run( sql,  values).first
    @id = result['id'].to_i
  end

  def update()
    sql = "UPDATE screenings SET
    time = $1, film_id = $2, seats = $2
    WHERE id = $4"
    values = [@time, @film_id, @seats, @id]
    SqlRunner.run(  sql, values)
  end

  def delete()
    sql = "DELETE FROM screenings
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(  sql, values)
  end

  def check_seats()
    return true if @seats >= 0
    return false
  end

  def self.return_screening_by_seats(seats)
    sql = "SELECT * FROM screenings
    WHERE seats = $1"
    values = [seats]
    screenings = SqlRunner.run( sql, values)
    # return results
    return screenings.map{ |screening| Screening.new(screening)}
  end

  def self.remove_ticket_from_availability(id, seats)
    new_total = seats - 1
    sql = "UPDATE screenings SET seats = $1
    WHERE id = $2"
    values = [new_total, id]
    SqlRunner.run(  sql, values)
    end

  def self.return_ticket_to_availability(id, seats)
    new_total = seats + 1
    sql = "UPDATE screenings SET seats = $1
    WHERE id = $2"
    values = [new_total, id]
    SqlRunner.run(  sql, values)
  end

  def self.select()
    sql = "SELECT * from screenings"
    SqlRunner.run(sql)
    end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

end
