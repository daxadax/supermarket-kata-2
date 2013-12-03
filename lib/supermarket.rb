# THIS WEEKS SPECIALS! #
# 
#   100 credits off dogfood!
#   buy one carton of eggs, get one free!

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
    attr_reader :specials, :items, :subtotal, :total, :name, :price

    def initialize(*specials)
      @specials = sorted_specials(specials.dup) || []
      @items = {}
    end

    def scan(*items)
      grouped_items = grouped_items_by_name(*items)
      
      format_items(grouped_items)  # sets `@items`
      cost_before_discounts        # sets `@subtotal`
      get_total

      print_receipt
    end

    private

    def sorted_specials(specials)
      specials.sort_by { |special| special.sale_item }
    end

    def grouped_items_by_name(*items)
      items.group_by {|item| item.name}
    end

    def format_items(items)
      items.each do |item|
        @items[item[0]] = {
          :quantity => item[1].size, 
          :cost     => item[1].first.price * item[1].size 
        } 
      end
      return @items 
    end

    def cost_before_discounts
      @subtotal = @items.map { |name, info| info[:cost] }.inject(:+)
    end

    # http://codereview.stackexchange.com/a/36595/28844
    def get_discounts
      discount = 0
      @specials.each do |special|
        if item = @items[special.sale_item]
          multiples = (item[:quantity] / special.quantity).floor
          discount += multiples * special.discount
        end
      end
      return discount
    end

    def get_total
      @total = @subtotal - get_discounts
    end

    def print_receipt
      puts "Thank you for shopping at FlaxMart"
      puts "Purchases"
      @items.each do |item, info|
        puts "#{item}...#{info[:quantity]}"
      end  
      puts "Subtotal....#{@subtotal}"
      puts "Discounts...#{get_discounts}"
      puts "       -------       "
      puts "Total...#{@total}"
    end

  end  

end