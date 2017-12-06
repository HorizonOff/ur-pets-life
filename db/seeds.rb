# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if PetType.count.zero?
  cat = PetType.create(name: 'Cat')
  dog = PetType.create(name: 'Dog')
  other = PetType.create(name: 'Other', is_additional_type: true)
else
  cat = PetType.find_by(name: 'Cat')
  dog = PetType.find_by(name: 'Dog')
  other = PetType.find_by(is_additional_type: true)
end

dog_breeds = %W[Airedale\ Terrier Affenpinscher,\ Toy Afghan\ Hound,\ Hound Airedale\ Terrier,\ Terrier Akita,\ Working
                Alaskan\ Malamute,\ Working American\ English\ Coonhound,\ Hound
                American\ Eskimo\ Dog\ (Miniature),\ Non-Sporting American\ Eskimo\ Dog\ (Standard),\ Non-Sporting
                American\ Eskimo\ Dog\ (Toy),\ Toy American\ Foxhound,\ Hound American\ Hairless\ Terrier,\ Terrier
                American\ Staffordshire\ Terrier,\ Terrier American\ Water\ Spaniel,\ Sporting
                Anatolian\ Shepherd\ Dog,\ Working Australian\ Cattle\ Dog,\ Herding Australian\ Shepherd,\ Herding
                Australian\ Terrier,\ Terrier Azawakh,\ Sighthound Borzoi Basenji,\ Hound Basset\ Hound,\ Hound
                Beagle,\ Hound Bearded\ Collie,\ Herding Beauceron,\ Herding Bedlington\ Terrier,\ Terrier
                Belgian\ Malinois,\ Herding Belgian\ Sheepdog,\ Herding Belgian\ Tervuren,\ Herding
                Bergamasco,\ Herding Berger\ Picard,\ Herding Bernese\ Mountain\ Dog,\ Working
                Bichon\ Frisé,\ Non-Sporting Black\ and\ Tan\ Coonhound,\ Hound Black\ Russian\ Terrier,\ Working
                Bloodhound,\ Hound Bluetick\ Coonhound,\ Hound Boerboel,\ Working Border\ Collie,\ Herding
                Border\ Terrier,\ Terrier Borzoi,\ Hound Boston\ Terrier,\ Non-Sporting
                Bouvier\ des\ Flandres,\ Herding Boxer,\ Working Boykin\ Spaniel,\ Sporting Briard,\ Herding
                Brittany,\ Sporting Brussels\ Griffon,\ Toy Bull\ Terrier,\ Terrier Bulldog,\ Non-Sporting
                Bullmastiff,\ Working Clumber\ Spaniel Cairn\ Terrier,\ Terrier Canaan\ Dog,\ Working
                Cane\ Corso,\ Working Cardigan\ Welsh\ Corgi,\ Herding Cavalier\ King\ Charles\ Spaniel,\ Toy
                Cesky\ Terrier,\ Terrier Chesapeake\ Bay\ Retriever,\ Sporting Chihuahua,\ Toy
                Chinese\ Crested\ Dog,\ Toy Chinese\ Shar\ Pei,\ Non-Sporting Chinook,\ Working
                Chow\ Chow,\ Non-Sporting Cirneco\ dell'Etna,\ Hound Clumber\ Spaniel,\ Sporting
                Cocker\ Spaniel,\ Sporting Collie,\ Herding Coton\ de\ Tulear,\ Non-Sporting
                Curly-Coated\ Retriever,\ Sporting Dogue\ de\ Bordeaux Dachshunds,\ Hound Dalmatian,\ Non-Sporting
                Dandie\ Dinmont\ Terrier,\ Terrier Doberman\ Pinscher,\ Working Dogue\ de\ Bordeaux,\ Working
                English\ Cocker\ Spaniel,\ Sporting English\ Foxhound,\ Hound English\ Setter,\ Sporting
                English\ Springer\ Spaniel,\ Sporting English\ Toy\ Spaniel,\ Toy Entlebucher\ Mountain\ Dog,\ Herding
                Field\ Spaniel Field\ Spaniel,\ Sporting Finnish\ Lapphund,\ Herding Finnish\ Spitz,\ Non-Sporting
                Flat-Coated\ Retriever,\ Sporting French\ Bulldog,\ Non-Sporting German\ Pinscher,\ Working
                German\ Shepherd\ Dog,\ Herding German\ Shorthaired\ Pointer,\ Sporting
                German\ Wirehaired\ Pointer,\ Sporting Giant\ Schnauzer,\ Working Glen\ of\ Imaal\ Terrier,\ Terrier
                Golden\ Retriever,\ Sporting Gordon\ Setter,\ Sporting Great\ Dane,\ Working Great\ Pyrenees,\ Working
                Greater\ Swiss\ Mountain\ Dog,\ Working Greyhound,\ Hound Harrier,\ Hound Havanese,\ Toy
                Ibizan\ Hound,\ Hound Icelandic\ Sheepdog,\ Herding Irish\ Red\ and\ White\ Setter,\ Sporting
                Irish\ Setter,\ Sporting Irish\ Terrier,\ Terrier Irish\ Water\ Spaniel,\ Sporting
                Irish\ Wolfhound,\ Hound Italian\ Greyhound,\ Toy Japanese\ Chin,\ Toy Keeshond,\ Non-Sporting
                Kerry\ Blue\ Terrier,\ Terrier Komondor,\ Working Kuvasz,\ Working Labrador\ Retriever
                Labrador\ Retriever,\ Sporting Lagotto\ Romagnolo,\ Sporting Lakeland\ Terrier,\ Terrier
                Leonberger,\ Working Lhasa\ Apso,\ Non-Sporting Löwchen,\ Non-Sporting Miniature\ Schnauzer\ puppy
                Maltese,\ Toy Manchester\ Terrier,\ Terrier\ &\ Toy Mastiff,\ Working
                Miniature\ American\ Shepherd,\ Herding Miniature\ Bull\ Terrier,\ Terrier Miniature\ Pinscher,\ Toy
                Miniature\ Schnauzer,\ Terrier Nova\ Scotia\ Duck-Tolling\ Retriever Neapolitan\ Mastiff,\ Working
                Newfoundland,\ Working Norfolk\ Terrier,\ Terrier Norwegian\ Buhund,\ Herding
                Norwegian\ Elkhound,\ Hound Norwegian\ Lundehund,\ Non-Sporting Norwich\ Terrier,\ Terrier
                Nova\ Scotia\ Duck-Tolling\ Retriever,\ Sporting Old\ English\ Sheepdog,\ Herding
                Otterhound,\ Hound Pharaoh\ Hound Papillon,\ Toy Parson\ Russell\ Terrier,\ Terrier Pekingese,\ Toy
                Pembroke\ Welsh\ Corgi,\ Herding Petit\ Basset\ Griffon\ Vendéen,\ Hound Pharaoh\ Hound,\ Hound
                Plott,\ Hound Pointer,\ Sporting Polish\ Lowland\ Sheepdog,\ Herding Pomeranian,\ Toy
                Poodle,\ Non-Sporting\ &\ Toy Portuguese\ Podengo\ Pequeno,\ Hound Portuguese\ Water\ Dog,\ Working
                Pug,\ Toy Puli,\ Herding Pumi,\ Herding Pyrenean\ Shepherd,\ Herding Rat\ Terrier,\ Terrier
                Redbone\ Coonhound,\ Hound Rhodesian\ Ridgeback,\ Hound Rottweiler,\ Working Russell\ Terrier,\ Terrier
                St.\ Bernard,\ Working Saluki,\ Hound Samoyed,\ Working Schipperke,\ Non-Sporting
                Scottish\ Deerhound,\ Hound Scottish\ Terrier,\ Terrier Sealyham\ Terrier,\ Terrier
                Shetland\ Sheepdog,\ Herding Shiba\ Inu,\ Non-Sporting Shih\ Tzu,\ Toy Siberian\ Husky,\ Working
                Silky\ Terrier,\ Toy Skye\ Terrier,\ Terrier Sloughi,\ Hound Smooth\ Fox\ Terrier,\ Terrier
                Soft-Coated\ Wheaten\ Terrier,\ Terrier Spanish\ Water\ Dog,\ Herding Spinone\ Italiano,\ Sporting
                Staffordshire\ Bull\ Terrier,\ Terrier Standard\ Schnauzer,\ Working Sussex\ Spaniel,\ Sporting
                Swedish\ Vallhund,\ Herding Tibetan\ Mastiff,\ Working Tibetan\ Spaniel,\ Non-Sporting
                Tibetan\ Terrier,\ Non-Sporting Toy\ Fox\ Terrier,\ Toy Treeing\ Walker\ Coonhound,\ Hound
                Vizsla,\ Sporting West\ Highland\ White\ Terrier Weimaraner,\ Sporting
                Welsh\ Springer\ Spaniel,\ Sporting Welsh\ Terrier,\ Terrier West\ Highland\ White\ Terrier,\ Terrier
                Whippet,\ Hound Wire\ Fox\ Terrier,\ Terrier Wirehaired\ Pointing\ Griffon,\ Sporting
                Wirehaired\ Vizsla,\ Sporting Xoloitzcuintli,\ Non-Sporting Yorkshire\ Terrier,\ Toy]

cat_breeds = %W[Abyssinian American\ Bobtail American\ Curl American\ Shorthair American\ Wirehair Balinese Bengal\ Cats
                Birman Bombay British\ Shorthair Burmese Burmilla Chartreux Chinese\ Li\ Hua Colorpoint\ Shorthair
                Cornish\ Rex Cymric Devon\ Rex Egyptian\ Mau European\ Burmese Exotic Havana\ Brown Himalayan
                Japanese\ Bobtail Javanese Korat LaPerm Maine\ Coon Manx Nebelung Norwegian\ Forest Ocicat Oriental
                Persian Pixie-Bob Ragamuffin Ragdoll\ Cats Russian\ Blue Savannah Scottish\ Fold Selkirk\ Rex
                Siamese\ Cat Siberian Singapura Snowshoe Somali Sphynx Tonkinese Turkish\ Angora Turkish\ Van]

if Breed.count.zero?
  dog_breeds.each do |breed|
    Breed.create(pet_type: dog, name: breed)
  end
  cat_breeds.each do |breed|
    Breed.create(pet_type: cat, name: breed)
  end
end

if VaccineType.count.zero?
  VaccineType.create(name: 'Neutered / spayed', pet_types: [cat, dog, other])
  VaccineType.create(name: 'DHPPI', pet_types: [dog, other])
  VaccineType.create(name: 'Leptospirosis', pet_types: [dog, other])
  VaccineType.create(name: 'Rhinotracheitis / Tricat', pet_types: [cat])
  VaccineType.create(name: 'Rabies', pet_types: [cat, dog, other])
  VaccineType.create(name: 'Kennel Cough', pet_types: [dog, other])
  VaccineType.create(name: 'Leukemia', pet_types: [cat])
  VaccineType.create(name: 'Deworming', pet_types: [cat, dog, other])
end

if User.count.zero?
  User.create(first_name: 'Bruce', last_name: 'Wayne', email: 'wayne@enterprise.com',
              password: '111111', password_confirmation: '111111', confirmed_at: Time.now)
  User.create(first_name: 'Barry', last_name: 'Allen', email: 'barry@enterprise.com',
              password: '111111', password_confirmation: '111111', confirmed_at: Time.now)
end

specializations = %W[Anesthesia Animal\ Welfare Behavior Dentistry Dermatology Emergency\ and\ Critical\ Care
                     Internal\ Medicine:\ Cardiology,\ Neurology,\ Oncology Laboratory\ Animal\ Medicine Microbiology
                     Nutrition Ophthalmology Pathology Pharmacology Poultry\ Veterinarians Preventive\ Medicine
                     Radiology Sports\ Medicine\ and\ Rehabilitation
                     Surgery:\ e.g.,\ Orthopedics,\ Soft\ Tissue\ surgery Theriogenology Toxicology]

if Specialization.count.zero?
  specializations.each do |s|
    Specialization.create(name: s)
  end
end

schedule_attributes = { monday_start_at: '10:00', monday_end_at: '19:30',
                        tuesday_start_at: '10:00', tuesday_end_at: '19:30',
                        wednesday_start_at: '10:00', wednesday_end_at: '19:30',
                        thursday_start_at: '10:00', thursday_end_at: '19:30',
                        friday_start_at: '10:00', friday_end_at: '19:30',
                        saturday_start_at: '10:00', saturday_end_at: '19:30',
                        sunday_start_at: '10:00', sunday_end_at: '19:30' }
if Clinic.count.zero?
  Clinic.create(name: 'Clininc 1', email: 'clinic1@mail.com', mobile_number: '+805050505050',
                location_attributes: { longitude: 48.6208, latitude: 22.287883, city: 'Somewhere in Afrika' },
                schedule_attributes: schedule_attributes, consultation_fee: [10, 50, 100].sample)
  Clinic.create(name: 'Clininc 2', email: 'clinic2@mail.com', mobile_number: '+805050505051',
                location_attributes: { longitude: 22.711711, latitude: 48.449306, city: 'Mukachevo' },
                schedule_attributes: schedule_attributes, consultation_fee: [10, 50, 100].sample)
end

if Vet.count.zero?
  Clinic.all.each do |c|
    3.times do
      x = c.vets.create(name: Faker::Name.name, email: Faker::Internet.email, consultation_fee: [10, 50, 100].sample,
                    experience: [2, 4, 6, 8].sample)
    end
  end
end

pet_types = [[cat, dog], [cat], [cat, dog, other], [dog], [other]]
specializations = Specialization.all
Vet.all.each do |v|
  if v.qualifications.count.zero?
    [1, 2].sample.times do
      v.qualifications.create(diploma: 'Cardiolog Diploma', university: 'Mumbai Universuty')
    end
  end
  v.pet_types = pet_types.sample if v.pet_types.count.zero?
  next unless v.specializations.count.zero?
  [1, 2].sample.times do
    v.specializations << specializations.sample
  end
end
