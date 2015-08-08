require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "product attributes should not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product price should be positive" do
    product = Product.new(title:'Popo larger', description:'Popo description', image_url:'popo.jpg')

    product.price= -1
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price= 0
    assert product.invalid?
    assert_equal ['must be greater than or equal to 0.01'], product.errors[:price]

    product.price= 1
    assert product.valid?
  end

  def new_product(image_url)
    product = Product.new(title: 'Pepito larger', description:'Tis a description', image_url: image_url, price: 1)
  end

  test "image url should be valid" do
    ok = %w{pepe.gif coco.jpg pupu.png mayus.JPG http://www.pepito.com/coco.GIF}
    bad = %w{coco toto.mov kaka.gif/other kuku.png.other}
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} should not be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "yyy",
                          image_url: "ppp.jpg",
                          price: 1)
    assert product.invalid?
    #I18n.translate('errors.messages.taken')
    assert_equal ['debe ser unico'], product.errors[:title]
  end

  test "title should be at least 10 characters long" do
    product = Product.new(description: 'pepe',
                          price: 10,
                          image_url: 'pepe.jpg')
    product.title='Invalid'
    assert product.invalid?
    assert_equal ['is too short (minimum is 10 characters)'], product.errors[:title]

    product.title='Title 10ch'
    assert product.valid?

    product.title='Title more than 10ch'
    assert product.valid?
  end
end
