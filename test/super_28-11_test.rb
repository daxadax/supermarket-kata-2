require 'test_helper'

class SuperTest < SuperSpec

  describe "stuff" do
    
    def setup
      @stuff = MySupermarket::Stuff
      @apple = @stuff.new("apple", 25)
    end

    it "requires a name and price" do
      proc { @stuff.new("no_price") }.must_raise ArgumentError 
    end
   
    it "sets name and price" do
      @apple.name.must_be_instance_of Symbol
      @apple.name.must_equal :apple
      @apple.price.must_equal 25
    end

  end

  describe "special" do
    
    def setup
      @special = MySupermarket::Special.new("apple", 4, 75)
    end

    it "creates new specials" do
      @special.deal.must_be_instance_of Hash
      @special.item.must_equal :apple
      @special.quantity.must_equal 4
      @special.discount.must_equal 75
    end

  end

 describe "checkout" do

    def setup
      # stuff
      @apple = MySupermarket::Stuff.new("apple", 25)
      @baguette = MySupermarket::Stuff.new("baguette", 100)
      @cookie = MySupermarket::Stuff.new("cookie", 15)
      
      # specials
      @special_1 = MySupermarket::Special.new("apple", 4, 25)
      @special_2 = MySupermarket::Special.new("baguette", 2, 50)

      # register
      @register = MySupermarket::Register.new(@special_1, @special_2)
      @register_wo_specials  = MySupermarket::Register.new

        # these orders don't qualify for discounts
        @abc = @register.send :list_items,[ @apple, @baguette, @cookie]
        @aabc = @register.send :list_items, [@apple, @apple, @baguette, @cookie]

        # these order qualify for discounts
        @a5 = @register.send :list_items, [@apple, @apple, @apple, @apple, @apple]
        @abba = @register.send :list_items, [@apple, @baguette, @baguette, @apple]

    end
    
    it "gets items as a hash by quantity" do
      @abc.must_be_instance_of Array
      @abba.size.must_equal 2
    end

    it "totals the items and returns a price" do
      cost_140 = @register.send :get_price, @abc
      cost_165 = @register.send :get_price, @aabc
      cost_125 = @register.send :get_price, @a5

      cost_140.must_equal 140
      cost_165.must_equal 165
      cost_125.must_equal 125
    end

    it "returns a nice receipt" do
      proc { @register.checkout(@baguette, @baguette, @apple) }.
        must_output "Your total is 175 credits.  You have saved 50 credits."
    end

    describe "specials" do

      it "hasn't got special offers by default" do
        @register_wo_specials.specials.must_be_empty
      end

      it "accepts special offers" do
        new_special = @register
        new_special.specials.size.must_equal 2
      end

      it "alphabetizes specials during initialization" do
        reverse_co = MySupermarket::Register.new(@special_2, @special_1)

        reverse_co.specials[0].item.must_equal :apple
      end

      it "determines the amount to discount" do
        no_discount = @register.send :reduce_price, @abc
        discount = @register.send :reduce_price, @abba
        a7b2 = [[:apple, [7, 25]], [:baguette, [2, 100]]]
        mult_discount = @register.send :reduce_price, a7b2

        no_discount.must_equal 0
        discount.must_equal 50
        mult_discount.must_equal 75
      end

    end

   end 

end