require 'test_helper'

class SuperTest < SuperSpec

  let(:cookies)  { Supermarket::Stock.new("cookies", 100) }
  let(:dogfood)  { Supermarket::Stock.new("dog food", 500) }
  let(:eggs)     { Supermarket::Stock.new("eggs", 250) }

  # 100 credits off dogfood!
  let(:dogfood_deal)     { Supermarket::WeeklySpecials.new(dogfood, 100) }
  # buy one carton of eggs, get one free!
  let(:egg_extravaganza) { Supermarket::WeeklySpecials.new(eggs, 250, 2) }

  let(:no_sale_register) { Supermarket::Register.new }
  let(:register)         { Supermarket::Register.new(egg_extravaganza, dogfood_deal) }

  describe "stock" do

    it "creates stock items" do
      cookies.name.must_be_kind_of Symbol
      dogfood.name.must_equal :dogfood
      eggs.price.must_equal 250      
    end

  end

  describe "weekly_specials" do
    
    it "creates weekly specials" do
      dogfood_deal.sale_item.must_equal :dogfood
      dogfood_deal.discount.must_equal 100
      dogfood_deal.quantity.must_equal 1
      
      egg_extravaganza.sale_item.must_equal :eggs
      egg_extravaganza.discount.must_equal 250
      egg_extravaganza.quantity.must_equal 2
    end

  end

  describe "register" do
    
    it "creates a register" do
      no_sale_register.specials.wont_be_nil
      register.specials.size.must_equal 2
    end

    it "sorts the specials by sale_item" do
      register.specials.first.sale_item.must_equal :dogfood
    end

  end

end