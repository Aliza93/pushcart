class PeapodScraper < ReceiptScraper

  def process_purchase
    @body_html = Nokogiri::HTML::Document.parse clean_body_html.gsub(/\=3D/,'=')

    build_purchase_object
    parse_items_and_add_to_purchase
    @purchase.raw_message = @email.raw_html

    return @purchase
  end

private

  def build_purchase_object
    @purchase = Purchase.new({
                              vendor:           'Peapod',
                              sender_email:     @email.from.to_s,
                              total_price:      parse_order_total,
                              order_unique_id:  parse_order_number
                            })
  end

  def parse_order_number
    return @email.subject.gsub(/^.*Order\sConfirmation\s/, '')
  end

  def parse_order_total
    @body_html.xpath('//td').each do |td|
      if td.text =~ /Total:/
        unless td.next.nil?
          if matches_element_characteristic?(td.next['align'], 'right') && matches_element_characteristic?(td.next['valign'], 'middle')
            return td.next.text.gsub(/(\$)/, '')
          end
        end
      end
    end
  end

  def parse_items_and_add_to_purchase
    @body_html.xpath('//table').each do |table|
      table.children.each do |tbody|
        if tbody.text =~ /^Item/
          category = nil
          tbody.children.each do |tr|
            if matches_element_characteristic?(tr['bgcolor'], '#EEEEEE')
              # Filter out non-grocery items
              if tr.text =~ /(Laundry|Home|Garden|Paper|Cleaning)/
                category = nil
              else
                category = tr.text
              end
            elsif !category.nil?
              item = Item.new(category: category) unless category.nil?
              tr.children.each_with_index do |td, index|
                case index
                when 0 # Item name
                  item.name = td.text
                when 1 # Description (Size)
                  item.description = td.text
                when 2 # Quantity
                  item.quantity = td.text
                when 3 # Item Price
                  item.price_breakdown = "#{td.text}/ea"
                when 4 # Total Price
                  item.discounted = true if td.text =~ /\=C2\=A0/
                  item.total_price = td.text.gsub(/\=C2\=A/, '')
                end
              end
              if item && !item.name.nil?
                @purchase.items << item
              end
            end
          end
        end
      end
    end
  end

end
