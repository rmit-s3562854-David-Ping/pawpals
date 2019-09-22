json.extract! pet, :id, :name, :pet_type, :breed, :picture, :birth_date, :gender, :created_at, :updated_at
json.url pet_url(pet, format: :json)
