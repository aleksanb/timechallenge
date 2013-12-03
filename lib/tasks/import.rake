namespace :import do
  desc 'Import NTNU buildings'
  task buildings_json: :environment do
    location = Rails.root.join('app/assets/json/ime_buildings.json')
    buildings = JSON.parse( IO.read(location))
    buildings.each do |building|
      puts building
      building['built_year'] = building.delete('builtYear')
      building['campus_id'] = building.delete('campusId')
      Building.create(building)
    end
  end
end
