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

afrika = { longitude: 48.6208, latitude: 22.287883, city: 'Somewhere in Afrika' }
mukachevo = { longitude: 22.711711, latitude: 48.449306, city: 'Mukachevo' }
uzhgorod = { longitude: 22.287883, latitude: 48.6208, city: 'Uzhgorod' }

if User.count.zero?
  user = User.create(first_name: 'Bruce', last_name: 'Wayne', email: 'user1@mail.com',
                     password: '111111', password_confirmation: '111111', confirmed_at: Time.now,
                     location_attributes: uzhgorod)
  User.create(first_name: 'Tony', last_name: 'Stark', email: 'user2@mail.com',
              password: '111111', password_confirmation: '111111', confirmed_at: Time.now,
              location_attributes: mukachevo)
else
  user = User.first
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

schedule_attributes = { monday_open_at: '11:00 AM', monday_close_at: '7:30 PM',
                        tuesday_open_at: '12:00 PM', tuesday_close_at: '7:30 PM',
                        wednesday_open_at: '1:00 PM', wednesday_close_at: '7:30 PM',
                        thursday_open_at: '2:00 PM', thursday_close_at: '7:30 PM',
                        friday_open_at: '3:00 PM', friday_close_at: '7:30 PM',
                        saturday_open_at: '4:00 PM', saturday_close_at: '7:30 PM',
                        sunday_open_at: '5:00 PM', sunday_close_at: '7:30 PM' }

clinics = [{ name: 'ABVC', email: 'info@abvc.ae', location_attributes: { city: 'Al Barsha' } },
           { name: 'Blue Oasis', mobile_number: '04-8848580', email: 'office@blueoasispetcare.com',
             location_attributes: { city: 'Dubai Investment Park (Green Community)' } },
           { name: 'British Vet Hospital', mobile_number: '04-3218556',
             location_attributes: { city: 'Villa 742, Al Wasl Rd, Jumeirah 3' } },
           { name: 'Desert Veterinary Clinic', mobile_number: '04-3389520',
             location_attributes: { city: 'Al Quoz Industrial Area 1, Street 8' } },
           { name: 'DKC', mobile_number: '04-2114800', email: 'boardingdaycare@dkc.ae',
             location_attributes: { city: 'Um Ramool Street 34' } },
           { name: 'Dr Matt Vet Clinic', mobile_number: '04-3499549', location_attributes: { city: 'Jumeirah 2' } },
           { name: 'Emirates Vet Center', mobile_number: '04-3361351',
             location_attributes: { city: 'Al Meydan Road' } },
           { name: 'Energetic Panacea', mobile_number: '04-3347812', email: 'info@energetic-panacea.com',
             location_attributes: { city: 'Jumeirah 2, Al Wasl Road,Villa 444, Dubai' } },
           { name: 'European Vet Center', mobile_number: '04-3804415', email: 'info@evc.ae',
             location_attributes: { city: 'Jumeirah 3, Umm Al Sheif Street,Villa 63' } },
           { name: 'Nad Al Shiba Vet Hospital', mobile_number: '056-2760434', email: 'info@nadalshibavet.com',
             location_attributes: { city: 'Off Street 34 - Nad Al Shiba 1' } },
           { name: 'Noble Veterinary Clinic ', mobile_number: '04-8859800',
             location_attributes: { city: 'Green Community-Dubai Investment Park 1' } },
           { name: 'Pet Connection', mobile_number: '04-4475307', email: 'info@petconnection.ae',
             location_attributes: { city: '1 Summer Land Building' } },
           { name: 'Pet Lover Vet Clinic', mobile_number: '04-4472289',
             location_attributes: { city: 'International City - Russia V2' } },
           { name: 'PetZone Vet Clinic', mobile_number: '04-3467870', email: 'info@petzonevet.com',
             location_attributes: { city: 'Al Wasl, Dubai,Near Mazaya Centre' } },
           { name: 'Proffesional Vet Clinic', mobile_number: '04-2980330', email: 'info@profvetsdubai.com',
             location_attributes: { city: 'Al Garhoud,Behind RTA Bdlg. Opp. Al Khaleej National School' } },
           { name: 'Provet Vet Clinic  ', mobile_number: '04-2662554', email: 'info@provetdubai.com',
             location_attributes: { city: 'Ground Floor, Al Noura Building, Hor Al Anz, Deira' } },
           { name: 'The veterinary Hospital', mobile_number: '04-3387726', website: 'vet-hosp.com',
             location_attributes: { city: 'Al Quoz 1, Street 8' } },
           { name: 'Umm Suqueim Vet Center', mobile_number: '04-3483799', email: 'info@usvetcentre.com',
             location_attributes: { city: 'Villa 1140 Al Wasl Road,Umm Suqeim 2' } },
           { name: 'Vienna Veterinary Clinic', mobile_number: '04-3883827', email: 'info@viennavet.com',
             location_attributes: { city: 'Villa 59, Al Thanya Street,Umm Suquiem 2' } },
           { name: 'Zaabel Vet Center', mobile_number: '04-3340011', email: 'info@zabeelvet.ae',
             location_attributes: { city: 'Za’abeel 2, Near Sheikh Zayed Rd, Trade Centre' } },
           { name: 'The City Vet Clinic', mobile_number: '04-3883990', email: 'alwasl@thecityvetclinic.com',
             location_attributes: { city: 'Mirdiff & Wasel' } },
           { name: 'American Veterinary Clinic', mobile_number: '02-6655044', email: 'info@americanvet.ae',
             location_attributes: { city: 'Khalidiya on Al Falah' } },
           { name: 'German Vet Clinic', mobile_number: '02-5562024', email: 'info@germanvet.ae',
             location_attributes: { city: '39th St - Abu Dhabi' } },
           { name: 'AUH Falcon Hospital', mobile_number: '02-5755155', email: 'info@falconhospital.com',
             location_attributes: { city: 'near the Abu Dhabi International Airport' } },
           { name: 'The City Vet Clinic', mobile_number: '02-4481448', email: 'abudhabi@thecityvetclinic.com',
             location_attributes: { city: '12th Street, Al Forsan village, Khalifa City A' } },
           { name: 'British Vet Center', mobile_number: '02-6650085', email: 'info@britvet.ae',
             location_attributes: { city: 'Khaleej Al Arabi St' } },
           { name: 'Healthline Med Center', mobile_number: '02-5668600', email: 'healthline@healthlineuae.com',
             location_attributes: { city: '26th Street, East 11 - Baniyas East, Abu Dhabi' } },
           { name: 'Canadian Vet Clinic', mobile_number: '02-6777631', location_attributes: { city: 'AUH' } },
           { name: 'New Vet Clinic', mobile_number: '02-6725955', email: 'drfaisal@newvet-clinic.com',
             location_attributes: { city: 'Mezzanine Floor, Al Rafideen Laundry building' } },
           { name: 'Australian Vet Hospital', mobile_number: '02-5562990', email: 'kcareception@australianvet.com',
             location_attributes: { city: 'Khalifa City A' } },
           { name: 'National Vet Hospital', mobile_number: '02-4461628', email: 'vetyhosp@emirates.net.ae',
             location_attributes: { city: 'Opposite Shaikh Mohammad Bin Zayed Mosque' } },
           { name: 'Veterinary Hospital Al Wathba', mobile_number: '02-5832300',
             location_attributes: { city: 'Opposite Banyas Public Park' } },
           { name: 'Canary Vet Clinic ', mobile_number: '06-5680803', email: 'info@canary-vet.com',
             location_attributes: { city: 'Al Jubail, Animal Market, Sharjah' } },
           { name: 'Europets Clinic', mobile_number: '050-8606857', email: 'info@epc.vet',
             location_attributes: { city: 'Al Quadsia area, Mirgab street villa Nr. 341' } },
           { name: 'Al Maha Vet Clinic', mobile_number: '06-5690091',
             location_attributes: { city: 'Al Mareija Street - Sharjah' } },
           { name: 'Vet Plus Center', mobile_number: '06-5554558', email: 'info@vetpluscenter.com',
             location_attributes: { city: 'University City Road- Muwaliah - Sharjah' } },
           { name: 'Pet Oasis Ajman', mobile_number: '06-7402280', email: 'info@petsoasisuae.com',
             location_attributes: { city: 'Sharjah' } },
           { name: 'Pet Oasis UAQ', mobile_number: '06-7662397', email: 'info@petsoasisuae.com',
             location_attributes: { city: 'Sharjah' } },
           { name: 'Pet Oasis RAK', mobile_number: '07-2445767', email: 'info@petsoasisuae.com',
             location_attributes: { city: 'Sharjah' } },
           { name: 'Salamat Vet Clinic', mobile_number: '050-4231267', website: 'salamatvet.com',
             location_attributes: { city: 'UAQ' } },
           { name: 'UAIRPORT PET CLINIC',
             location_attributes: { city: 'Fizkulturna St, 23, Storozhnytsya',
                                    latitude: 48.60388, longitude: 22.245752 },
             picture: File.open(File.join(Rails.root, 'public', 'images', 'clinic_1.png')) },
           { name: 'UUVCA Bay Area Veterinary Specialists & Emergency Hospital',
             location_attributes: { city: 'Haharina St, 74, Storozhnytsya',
                                    latitude: 48.606581, longitude: 22.245384 },
             picture: File.open(File.join(Rails.root, 'public', 'images', 'clinic_2.png')) },
           { name: 'UThe Country Vet',
             location_attributes: { city: 'Radyshcheva St, 11А, Uzhhorod',
                                    latitude: 48.615713, longitude: 22.275289 },
             picture: File.open(File.join(Rails.root, 'public', 'images', 'clinic_3.png')) },
           { name: 'UNewport Harbor Animal Hospital',
             location_attributes: { city: 'Secheni St, 48, Uzhhorod',
                                    latitude: 48.613534, longitude: 22.275289 },
             picture: File.open(File.join(Rails.root, 'public', 'images', 'clinic_4.png')) },
           { name: 'URose City Veterinary Hospital',
             location_attributes: { city: 'Lermontova St, 9А, Uzhhorod',
                                    latitude: 48.616932, longitude: 22.298259 },
             picture: File.open(File.join(Rails.root, 'public', 'images', 'clinic_5.png')) },
           { name: 'UCityVet',
             location_attributes: { city: 'Druhetiv St, 81-83, Uzhhorod',
                                    latitude: 48.627637, longitude: 22.307166 },
             picture: File.open(File.join(Rails.root, 'public', 'images', 'clinic_6.png')) },
           { name: 'URed Hill Animal Health Center',
             location_attributes: { city: 'Brodlakovycha St, 1, Uzhhorod',
                                    latitude: 48.636042, longitude: 22.308182 },
             picture: File.open(File.join(Rails.root, 'public', 'images', 'clinic_7.png')) },
           { name: 'USpayToday Neuter Now',
             location_attributes: { city: 'Strilnychna St, 100, Uzhhorod',
                                    latitude: 48.63843, longitude: 22.302099 },
             picture: File.open(File.join(Rails.root, 'public', 'images', 'clinic_8.png')) },
           { name: 'UCanton Animal Hospital',
             location_attributes: { city: 'Tekhnichna St, 16/1, Uzhhorod',
                                    latitude: 48.639441, longitude: 22.335957 },
             picture: File.open(File.join(Rails.root, 'public', 'images', 'clinic_9.png')) },
           { name: 'UGold Coast Mobile veterinary Service',
             location_attributes: { city: 'Hranitna St, 67, Uzhhorod',
                                    latitude: 48.620932, longitude: 22.331519 },
             picture: File.open(File.join(Rails.root, 'public', 'images', 'clinic_10.png')) },
           { name: 'URippowam Animal Hospital',
             location_attributes: { city: 'Dokuchajeva St, 1-6, Uzhhorod',
                                    latitude: 48.633977, longitude: 22.279548 },
             picture: File.open(File.join(Rails.root, 'public', 'images', 'clinic_11.png')) }]

if Clinic.count.zero?
  if Rails.env.development?
    Clinic.create(name: 'Clinic 1', email: Faker::Internet.email, mobile_number: '+805050505050',
                  is_emergency: [true, false].sample, location_attributes: afrika,
                  schedule_attributes: schedule_attributes, consultation_fee: rand(500))
    Clinic.create(name: 'Clinic 2', email: Faker::Internet.email, mobile_number: '+805050505051',
                  is_emergency: [true, false].sample, location_attributes: mukachevo,
                  schedule_attributes: schedule_attributes, consultation_fee: rand(500))
    Clinic.create(name: 'Clinic 3', email: Faker::Internet.email, mobile_number: '+805050505052',
                  is_emergency: [true, false].sample, location_attributes: uzhgorod,
                  schedule_attributes: schedule_attributes, consultation_fee: rand(500))
  else
    clinics.each do |c|
      Clinic.create(name: c[:name], email: c[:email], mobile_number: c[:mobile_number],
                    is_emergency: [true, false].sample, picture: c[:picture],
                    location_attributes: c[:location_attributes],
                    schedule_attributes: schedule_attributes, consultation_fee: rand(500))
    end
  end
end

if Vet.count.zero?
  Clinic.joins(:location).where.not(locations: {latitude: nil }).all.each do |c|
    rand(1..3).times do |i|
      v = c.vets.new(name: Faker::Name.name, email: Faker::Internet.email, consultation_fee: rand(500),
                    is_emergency: [true, false].sample,
                    avatar: File.open(File.join(Rails.root, 'public', 'images', 'vet_' + rand(1..6).to_s + '.jpg')),
                    experience: [2, 4, 6, 8].sample, session_duration: rand(20..120)
                    )
      v.use_clinic_location = true if v.is_emergency
      v.save
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

if Admin.count.zero?
  Admin.create(email: 'ur.pets.life.project@gmail.com', password: '111111', password_confirmation: '111111',
               is_super_admin: true)
  Admin.create(email: 'admin@example.com', password: '111111', password_confirmation: '111111',
               is_super_admin: true)
end

if ServiceOption.count.zero?
  pick_up = ServiceOption.create(name: 'Pick Up')
  drop_off = ServiceOption.create(name: 'Drop Off')
else
  pick_up = ServiceOption.find_by(name: 'Pick Up')
  drop_off = ServiceOption.find_by(name: 'Drop Off')
end

service_options = [[pick_up], [drop_off], [pick_up, drop_off]]
pet_types = [[dog], [cat], [cat, dog]]

if GroomingCentre.count.zero?
  GroomingCentre.create(name: 'GroomingCentre 1', email: Faker::Internet.email, mobile_number: '+805050505050',
                        location_attributes: afrika,
                        schedule_attributes: schedule_attributes)
  GroomingCentre.create(name: 'GroomingCentre 2', email: Faker::Internet.email, mobile_number: '+805050505051',
                        location_attributes: mukachevo,
                        schedule_attributes: schedule_attributes)
  GroomingCentre.create(name: 'GroomingCentre 3', email: Faker::Internet.email, mobile_number: '+805050505052',
                        location_attributes: uzhgorod,
                        schedule_attributes: schedule_attributes)
  GroomingCentre.all.each do |gs|
    gs.service_options = service_options.sample
    gs.pet_types = pet_types.sample
  end
end

if DayCareCentre.count.zero?
  DayCareCentre.create(name: 'DayCareCentre 1', email: Faker::Internet.email, mobile_number: '+805050505050',
                       location_attributes: afrika,
                       schedule_attributes: schedule_attributes)
  DayCareCentre.create(name: 'DayCareCentre 2', email: Faker::Internet.email, mobile_number: '+805050505051',
                       location_attributes: mukachevo,
                       schedule_attributes: schedule_attributes)
  DayCareCentre.create(name: 'DayCareCentre 3', email: Faker::Internet.email, mobile_number: '+805050505052',
                       location_attributes: uzhgorod,
                       schedule_attributes: schedule_attributes)
  DayCareCentre.all.each do |dcs|
    dcs.service_options = service_options.sample
    dcs.pet_types = pet_types.sample
  end
end

description = 'A beauty salon is an establishment that offers a variety of cosmetic treatments and cosmetic services for men and women. Beauty salons may offer a variety of services including professional hair cutting and styling, manicures and pedicures, and often cosmetics, makeup and makeovers.'

if ServiceType.count.zero?
  GroomingCentre.all.each do |gc|
    gc.service_types.create(name: 'Cleaning', description: description)
    gc.service_types.create(name: 'Hair Color', description: description)
    gc.service_types.create(name: 'Grooming', description: description)
  end
  DayCareCentre.all.each do |gc|
    gc.service_types.create(name: 'Care service 1', description: description)
    gc.service_types.create(name: 'Care service 2', description: description)
    gc.service_types.create(name: 'Care service 3', description: description)
  end
end


if ServiceDetail.count.zero?
  ServiceType.all.each do |st|
    # pet_types.sample.each do |t|
    #   st.service_details.create(pet_type: t, price: rand(500))
    # end
    st.service_details.create(pet_type: cat, price: rand(500))
    st.service_details.create(pet_type: dog, price: rand(500))
  end
end

if Trainer.count.zero?
  Trainer.create(name: 'Trainer 1', email: Faker::Internet.email, mobile_number: '+805050505050',
                 experience: [2, 4, 6, 8].sample, location_attributes: afrika,
                 picture: File.open(File.join(Rails.root, 'public', 'images', 'trainer_1.jpg')))
  Trainer.create(name: 'Trainer 2', email: Faker::Internet.email, mobile_number: '+805050505051',
                 experience: [2, 4, 6, 8].sample, location_attributes: mukachevo,
                 picture: File.open(File.join(Rails.root, 'public', 'images', 'trainer_2.jpg')))
  Trainer.create(name: 'Trainer 3', email: Faker::Internet.email, mobile_number: '+805050505052',
                 experience: [2, 4, 6, 8].sample, location_attributes: uzhgorod,
                 picture: File.open(File.join(Rails.root, 'public', 'images', 'trainer_3.jpg')))
  specialiation = Specialization.create(name: 'Dog trainer', is_for_trainer: true)
  Trainer.all.each do |t|
    t.pet_types = pet_types.sample
    t.specializations << specialiation
    [1, 2].sample.times do
      t.qualifications.create(diploma: 'Animals Care Diploma', university: 'Mumbai Universuty')
    end
    t.service_types.create(name: 'Half Day training', description: description)
    t.service_types.create(name: 'Full day training', description: description)
  end
end

pets_pictures = %w[cat_1.jpg cat_2.png dog_1.jpg dog_2.png other_1.jpg other_2.png]

if Pet.count.zero?
  user.pets.create(name: 'Tom', sex: 1, birthday: '2017-01-01T14:36:44.000Z', pet_type_id: 1, breed_id: 205,
                   is_for_adoption: true,
                   avatar: File.open(File.join(Rails.root, 'public', 'images', 'cat_1.jpg')))
  user.pets.create(name: 'Pluto', sex: 1, birthday: '2017-01-01T14:36:44.000Z', pet_type_id: 2, breed_id: 3,
                   lost_at: 1516217199, description: 'My favorite dog', additional_comment: 'Help me',
                   mobile_number: '+2342342343343', location_attributes: uzhgorod,
                   avatar: File.open(File.join(Rails.root, 'public', 'images', 'dog_1.jpg')))
  user.pets.create(description: 'Little mouse Jerry', pet_type_id: 3, additional_comment: 'Somebody, Take it away',
                   additional_type: 'Bird', found_at: 1516217199, mobile_number: '+2342342343343',
                   location_attributes: mukachevo,
                   avatar: File.open(File.join(Rails.root, 'public', 'images', 'other_1.jpg')))
end

pet = Pet.first

if Picture.count.zero?
  Pet.all.each do |p|
    rand(1..6).times do
      p.pictures.create(attachment: File.open(File.join(Rails.root, 'public', 'images', pets_pictures.sample)))
    end
  end
end

if Appointment.count.zero?
  Clinic.all.each do |c|
    3.times do
      user.appointments.create(bookable: c, vet_id: c.vet_ids.sample, start_at: rand(1.month.ago..1.month.since),
                               pet: pet)
    end
  end
  DayCareCentre.all.each do |c|
    3.times do
      a = user.appointments.new(bookable: c, start_at: rand(1.month.ago..1.month.since), pet: pet,
                               service_detail_ids: [c.service_details.where(pet_type_id: pet.id).first.try(:id)])
      puts a.errors.messages unless a.save
    end
  end
  GroomingCentre.all.each do |c|
    3.times do
      a = user.appointments.new(bookable: c, start_at: rand(1.month.ago..1.month.since), pet: pet,
                               service_detail_ids: c.service_details.where(pet_type_id: pet.id).pluck(:id))
      puts a.errors.messages unless a.save

    end
  end
end

if Diagnosis.count.zero?
  past_clinic_appointments = Appointment.for_clinic.past
  past_clinic_appointments.each do |a|
    a.create_diagnosis(condition: 'norm condition',
                       message: "sdfds ef ewf ewfo kewpofkopwekfpo kpowekfpwekf pweokrpwk pwerkewpkr
                                 pewkrpewkr pewkpewkrpwekr pwkerpewkr pwekr pekrpewkrpewkpwkr pwekrpwekr
                                 pwekr pwerkpewkrpw kpwerpwekr",
                       next_appointment_id: past_clinic_appointments.pluck(:id).sample)
  end
end

if Recipe.count.zero?
  first_instruction = 'ssdas dwewqe qwe wqe wqe qwe qwe eqe qweqweawdas qwe'
  second_instruction = 'kfldgdfkl fkdlgmklfdmg dgdfkmg 234v erkgmferlk m'
  resipes = [[first_instruction], [second_instruction], [first_instruction, second_instruction]]
  Diagnosis.all.each do |d|
    resipes.sample.each do |instr|
      d.recipes.create(instruction: instr)
    end
  end
end
