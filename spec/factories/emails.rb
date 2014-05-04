FactoryGirl.define do
  factory :email, class: OpenStruct do
    to ["my-pushcart-address@#{EMAIL_URI}"]
    from 'notices@some_grocery_email.com'
    subject 'email subject'
    body 'Hello!'
    attachments {[]}

    trait :fresh_direct_receipt_one do
      from 'receipt@freshdirect.com'
      subject 'Your order for Sunday, Jan 26 2014'
      # raw_html File.read(Rails.root.to_s + '/lib/sample_emails/fresh_direct/receipt_one.eml')
      # raw_text File.read(Rails.root.to_s + '/lib/sample_emails/fresh_direct/receipt_one.eml')
    end

    trait :fresh_direct_receipt_two do
      from 'receipt@freshdirect.com'
      subject 'Your order for Sunday, Jan 26 2014'
      # raw_html File.read(Rails.root.to_s + '/lib/sample_emails/fresh_direct/receipt_two.eml')
      # raw_text File.read(Rails.root.to_s + '/lib/sample_emails/fresh_direct/receipt_two.eml')
    end

    trait :instacart_receipt do
      from 'orders@instacart.com'
      subject 'Fwd: Your Order with Instacart'
      # raw_html File.read(Rails.root.to_s + '/lib/sample_emails/instacart/instacart_receipt.eml')
    end
  end

  factory :inbound_email do
    user
    to ["my-pushcart-address@#{EMAIL_URI}"]
    from 'notices@some_grocery_email.com'
    subject 'email subject'
    raw_html ''
    raw_text ''

    trait :fresh_direct_receipt_one do
      from 'receipt@freshdirect.com'
      subject 'Your order for Sunday, Jan 26 2014'
      # raw_html File.read(Rails.root.to_s + '/lib/sample_emails/fresh_direct/receipt_one.eml')
      # raw_text File.read(Rails.root.to_s + '/lib/sample_emails/fresh_direct/receipt_one.eml')
    end

    trait :fresh_direct_receipt_two do
      from 'receipt@freshdirect.com'
      subject 'Your order for Sunday, Jan 26 2014'
      # raw_html File.read(Rails.root.to_s + '/lib/sample_emails/fresh_direct/receipt_two.eml')
      # raw_text File.read(Rails.root.to_s + '/lib/sample_emails/fresh_direct/receipt_two.eml')
    end

    trait :instacart_receipt do
      from 'orders@instacart.com'
      subject 'Fwd: Your Order with Instacart'
      # raw_html File.read(Rails.root.to_s + '/lib/sample_emails/instacart/instacart_receipt.eml')
    end
  end
end
