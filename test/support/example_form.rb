# frozen_string_literal: true

class TestModel
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :active, :boolean, default: false
  attribute :name, :string
  attribute :email, :string

  def self.model_name
    ActiveModel::Name.new(self, nil, "TestModel")
  end

  def persisted?
    id.present?
  end

  def to_key
    [id] if persisted?
  end

  def to_param
    id.to_s if persisted?
  end
end

class ExampleForm < TypedForm
  prop :a_string, String, default: ""
  prop :a_number, Integer, default: 0
  prop :an_email, String, default: ""
  prop :a_long_string, String, default: ""
  prop :a_number_between, Integer, default: 5
  prop :a_radio_option, String, default: "option1"
  prop :some_string_from_list_maybe, String, default: "one"
  prop :a_boolean_choice, _Boolean, default: false

  validates :a_string, presence: true, length: {minimum: 3, maximum: 50}
  validates :an_email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :a_number, presence: true, numericality: {greater_than: 0}

  def self.model_name
    ActiveModel::Name.new(self, nil, "ExampleForm")
  end

  def self.factory_one
    new(
      a_string: "test string",
      a_number: 42,
      an_email: "test@example.com"
    )
  end
end
