class Item < ActiveRecord::Base
  belongs_to :purchase
  belongs_to :swap
  has_one :user, through: :purchase

  # before_create :set_json_default_fields
  before_create :retrieve_nutritionix_api_data

  after_update :send_swap_mailer, if: proc { |item| item.swap_id_changed? }

  validates :swap_feedback, inclusion: { in: ['like', 'dislike'],
                                          message: "{%value} is not valid." },
                            allow_blank: true

  def self.nutritionix_api_fields
    %W(calcium_dv calories calories_from_fat cholesterol dietary_fiber ingredient_statement iron_dv monounsaturated_fat polyunsaturated_fat protein refuse_pct saturated_fat serving_size_qty serving_size_unit serving_weight serving_weight_grams serving_weight_uom servings_per_container sodium sugars total_carbohydrate total_fat trans_fatty_acid vitamin_a_dv vitamin_c_dv water_grams)
  end

  nutritionix_api_fields.each do |nutrition_field|
    define_method(nutrition_field) do
      ntx_api_nutrition_data && ntx_api_nutrition_data["nf_#{nutrition_field}"]
    end
  end

  def filtered_category
    CategoryDigester.chew(category, name)
  end

  # def upc
  #   ntx_api_nutrition_data['upc']
  # end

private

  # def set_json_default_fields
  #   self.
  # end

  def retrieve_nutritionix_api_data
    unless name.nil?
      api_data = NUTRITIONIX_API.search(name)
      p api_data
      if api_data.blank? || api_data == 'Connection error.'
        return false 
      else
        self.ntx_api_nutrition_data = api_data.delete 'fields'
        self.ntx_api_metadata       = api_data

        if api_data['_score'].to_f < 0.5
          return false 
        else
          return true
        end
      end
    end
  end

  def send_swap_mailer
    UserMailer.replacement_suggestion(self).deliver
  end

end
