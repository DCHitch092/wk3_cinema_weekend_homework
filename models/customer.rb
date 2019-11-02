require('pry')
require_relative('../db/SqlRunner')

class Customer

  attr_reader :id, :name, :funds

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


  #
  # def update()
  # end
  #
  # def delete()
  # end
  #
  # def delete_all()
  # end
end
