# to work on:
#
# more descriptive method names
# more readable methods
# only test public methods/prime functionality


module Supermarket
  
  class Stock
    attr_reader :name, :price

    def initialize(name, price)
      @name = name.delete(' ').to_sym
      @price = price
    end

  end  

  class WeeklySpecials
    attr_reader :sale_item, :discount, :quantity

    def initialize(stock_object, discount, quantity = 1)
      @sale_item = stock_object.name
      @discount = discount
      @quantity = quantity
    end

  end  
  
  class Register
    attr_reader :specials, :items

    def initialize(*specials)
      @specials = sorted_specials(specials.dup) || []
    end

    def sorted_specials(specials)
      specials.sort_by { |special| special.sale_item }
    end

  end  

end