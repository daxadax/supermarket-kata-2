module MySupermarket

  # regular prices:      apple..........25
  #                      baguette.......100
  #                      cookie.........15

  # this weeks specials: 4 apples for 75            *save 25*
  #                      2 baguettes for 150        *save 50*

  class Stuff

    attr_accessor :name
    attr_accessor :price

    def initialize(name, price)
      @name = name.to_sym
      @price = price
    end
      
  end  

  class Special
    attr_accessor :item, :quantity, :discount, :deal

    def initialize(item, quantity, discount)
      @item = item.to_sym
      @quantity = quantity
      @discount = discount
      format
    end

    def format 
      @deal = Hash[
        @item, [@quantity, @discount]
      ]
    end

  end

  class Register
    attr_accessor :specials, :item, :quantity, :discount, :deal

    def initialize(*specials)
      @specials = specials if specials
      # sort by item name to normalize array
      @specials = @specials.sort_by {|x| x.item}
    end

    def checkout(*items)
      list = list_items(items.dup)
      total = get_price(list)
      discount = reduce_price(list)

      print "Your total is #{total - discount} credits.  You have saved #{discount} credits."
    end

    private

    def list_items(items)
      list = items.group_by { |item| item.name }.
            map { |name, stuff| [name, [stuff.size, stuff[0].price]] }
      # sort by item name to normalize array      
      list = list.sort      
    end

    def get_price(list)
      list.map { |name, stuff| stuff[0]*stuff[1] }.inject(:+)
    end

    # FLAG more efficient way to write this?
    def reduce_price(list)
      discounts = []
      list.each do |item|
        @specials.each do |special|
          #if quantities match *see EoF
          while item[1][0] >= special.quantity && 
                item[0] == special.item
            discounts << special.discount
            item[1][0] = item[1][0] - special.quantity
          end 
        end  
      end
      if discounts.empty? 
        0 
      else
        return discounts.inject(:+)
      end
    end

  end

end

# NOTE: 
# item[0] = name
# item[1][0] = quantity
# item[1][1] = price

