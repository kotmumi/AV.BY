//
//  CarModel.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 19.11.25.
//

struct CarModel {
    
    static let models: [String: [String]] = [
        "Audi": ["A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "Q2", "Q3", "Q5", "Q7", "Q8", "TT", "R8", "e-tron", "RS3", "RS4", "RS5", "RS6", "RS7", "S3", "S4", "S5", "S6", "S7", "S8"],
        "BMW": ["1 Series", "2 Series", "3 Series", "4 Series", "5 Series", "6 Series", "7 Series", "8 Series", "X1", "X2", "X3", "X4", "X5", "X6", "X7", "Z4", "i3", "i4", "i8", "iX", "M2", "M3", "M4", "M5", "M6", "M8", "X3 M", "X5 M", "X6 M"],
        "Mercedes-Benz": ["A-Class", "B-Class", "C-Class", "E-Class", "S-Class", "CLA", "CLS", "GLA", "GLB", "GLC", "GLE", "GLS", "G-Class", "V-Class", "AMG GT", "EQC", "EQS", "SL", "Maybach S-Class", "AMG A 45", "AMG C 63", "AMG E 63", "AMG GT 63"],
        "Toyota": ["Camry", "Corolla", "RAV4", "Land Cruiser", "Highlander", "Hilux", "Prius", "Yaris", "Avensis", "Auris", "C-HR", "FJ Cruiser", "GT86", "Harrier", "Prado", "Tacoma", "Tundra", "Venza", "4Runner", "Alphard", "Aygo", "Crown", "Fortuner", "IQ", "Mark II", "Sequoia", "Sienna", "Supra", "Urban Cruiser", "Vellfire"],
        "Honda": ["Civic", "Accord", "CR-V", "HR-V", "Pilot", "Odyssey", "Fit", "Jazz", "City", "Stream", "Stepwgn", "Shuttle", "FR-V", "Legend", "NSX", "S2000", "Integra", "Prelude", "Ridgeline", "Passport", "BR-V", "Mobilio", "Brio", "Amaze", "WR-V"],
        "Ford": ["Focus", "Fiesta", "Mondeo", "Kuga", "Explorer", "Escape", "Mustang", "F-150", "Ranger", "Transit", "S-Max", "Galaxy", "Edge", "EcoSport", "Bronco", "Maverick", "Expedition", "Fusion", "C-Max", "Puma", "Ka", "Figo", "Aspire", "Endeavour", "Everest", "Territory", "Tourneo"],
        "Volkswagen": ["Golf", "Passat", "Tiguan", "Polo", "Jetta", "Arteon", "T-Roc", "T-Cross", "Taos", "Atlas", "ID.3", "ID.4", "ID.6", "Touareg", "Touran", "Sharan", "Caddy", "Transporter", "Amarok", "Caravelle", "California", "Multivan", "Beetle", "Scirocco", "Up", "Lavida", "Santana", "Vento", "Virtus", "Nivus"],
        "Hyundai": ["Solaris", "Elantra", "Tucson", "Santa Fe", "Creta", "Sonata", "i10", "i20", "i30", "i40", "Kona", "Palisade", "Staria", "Stargazer", "Veloster", "Genesis", "Equus", "Aslan", "Grandeur", "Avante", "Accent", "Verna", "Xcent", "Aura", "Alcazar", "Venue", "Ioniq 5", "Ioniq 6"],
        "Kia": ["Rio", "Optima", "Sportage", "Sorento", "Ceed", "Picanto", "Stinger", "Carnival", "Niro", "Soul", "EV6", "Seltos", "Sonet", "Cerato", "K5", "K7", "K8", "K9", "Mohave", "Borrego", "Cadenza", "Forte", "Quoris", "Ray", "Xceed", "XCeed"],
        "Nissan": ["Qashqai", "X-Trail", "Juke", "Murano", "Pathfinder", "Patrol", "Almera", "Note", "Micra", "Leaf", "GT-R", "370Z", "Navara", "Terrano", "Tiida", "Sentra", "Sunny", "Versa", "Maxima", "Altima", "Rogue", "Armada", "Kicks", "Ariya", "Cube", "Elgrand", "Fairlady", "Fuga", "Latio", "March", "Pulsar", "Skyline", "Teana", "Wingroad"],
        "Skoda": ["Octavia", "Superb", "Kodiaq", "Karoq", "Fabia", "Rapid", "Kamiq", "Enyaq", "Scala", "Yeti", "Roomster", "Citigo", "Praktik", "Felicia", "Forman", "Favorit"],
        "Renault": ["Logan", "Sandero", "Duster", "Kaptur", "Arkana", "Megane", "Clio", "Talisman", "Koleos", "Fluence", "Laguna", "Scenic", "Kangoo", "Trafic", "Master", "Symbol", "Twingo", "Wind", "Zoe", "Captur", "Kadjar", "Alaskan", "Avantime", "Espace", "Fuego", "Kiger", "Lutecia", "Modus", "Rafale", "Rodeo", "Safrane", "Thalia", "Torino", "Triber", "Vel Satis"],
        "Chevrolet": ["Aveo", "Cruze", "Malibu", "Impala", "Camaro", "Corvette", "Trailblazer", "Equinox", "Tahoe", "Suburban", "Silverado", "Orlando", "Spark", "Cobalt", "Lacetti", "Epica", "Niva", "Trax", "Blazer", "Captiva", "Tracker", "Onix", "Prisma", "S10", "Spin", "Vectra", "Astra", "Zafira", "Rezzo", "Tosca", "Vivant"],
        "Mazda": ["2", "3", "6", "CX-3", "CX-5", "CX-7", "CX-9", "CX-30", "CX-50", "CX-60", "CX-80", "MX-5", "RX-8", "BT-50", "MPV", "Premacy", "Atenza", "Axela", "Demio", "Familia", "Verisa", "Xedos", "Biante", "Carol", "Cosmo", "Eunos", "Flair", "Lantis", "Laputa", "Levante", "Millenia", "Persona", "Proceed", "Revue", "Roadster", "Scrum", "Sentia", "Spiano", "Tribute"],
        "Mitsubishi": ["Lancer", "Outlander", "Pajero", "Pajero Sport", "ASX", "Eclipse Cross", "Mirage", "Attrage", "Colt", "Galant", "Space Star", "Delica", "i-MiEV", "Minica", "RVR", "Sigma", "Strada", "Toppo", "Town Box", "Airtrek", "Carisma", "Challenger", "Chariot", "Cordia", "Debonair", "Diamante", "Dignity", "Dion", "Emeraude", "Endeavor", "Eterna", "FTO", "Galan", "Grandis", "GTO", "L200", "L300", "L400", "Legnum", "Libero", "Minicab", "Montero", "Nativa", "Pajero Mini", "Pajero iO", "Pistachio", "Proudia", "Raider", "Rosa", "Savrin", "Signo", "Starion", "Tredia", "Xpander"],
        "Subaru": ["Impreza", "Forester", "Outback", "Legacy", "XV", "BRZ", "WRX", "Levorg", "Tribeca", "Baja", "Domingo", "Exiga", "Justy", "Leone", "Pleo", "R1", "R2", "Sambar", "Stella", "SVX", "Traviq", "Vivio"],
        "Lexus": ["ES", "IS", "GS", "LS", "RX", "NX", "UX", "GX", "LX", "RC", "LC", "CT", "HS", "SC"],
        "Volvo": ["S60", "S80", "S90", "V40", "V60", "V70", "V90", "XC40", "XC60", "XC70", "XC90", "C30", "C70", "S40", "V50", "240", "740", "850", "940", "960"],
        "Peugeot": ["206", "207", "208", "306", "307", "308", "406", "407", "408", "508", "2008", "3008", "4008", "5008", "Partner", "Expert", "Boxer", "RCZ", "1007", "107", "108", "205", "309", "405", "504", "505", "604", "605", "806", "807", "Bipper", "Hoggar", "iOn", "Nautilus", "P4", "Ranch", "Rifter", "Traveller"],
        "Citroen": ["C3", "C4", "C5", "C6", "Berlingo", "Jumper", "DS3", "DS4", "DS5", "C-Elysee", "C1", "C2", "C3 Aircross", "C4 Cactus", "C4 Picasso", "C5 Aircross", "C8", "DS7", "Jumpy", "Nemo", "Saxo", "Spacetourer", "Xsara", "ZX", "AX", "BX", "CX", "Dyane", "Evasion", "GS", "GSA", "LN", "LNA", "Méhari", "SM", "Visa", "Xantia", "XM", "Xsara Picasso", "2CV", "Ami", "C15", "C25", "C35", "Fafnir", "Rosalie", "Traction Avant", "Type H"],
        "Opel": ["Astra", "Corsa", "Insignia", "Mokka", "Crossland", "Grandland", "Zafira", "Vectra", "Omega", "Kadett", "Ascona", "Rekord", "Combo", "Vivaro", "Movano", "Adam", "Agila", "Antara", "Calibra", "Campo", "Commodore", "Frontera", "GT", "Meriva", "Monterey", "Monza", "Senator", "Signum", "Sintra", "Speedster", "Tigra", "Vita"],
        "Land Rover": ["Defender", "Discovery", "Range Rover", "Range Rover Sport", "Range Rover Evoque", "Range Rover Velar", "Freelander", "Discovery Sport"],
        "Jeep": ["Grand Cherokee", "Cherokee", "Wrangler", "Compass", "Renegade", "Patriot", "Commander", "Liberty", "Wagoneer"],
        "Porsche": ["911", "Panamera", "Cayenne", "Macan", "Boxster", "Cayman", "Taycan", "918 Spyder", "Carrera GT", "944", "928", "968"],
        "Infiniti": ["Q50", "Q60", "Q70", "QX50", "QX55", "QX60", "QX70", "QX80", "FX", "G", "M", "EX", "JX", "Q30", "QX30"],
        "Acura": ["MDX", "RDX", "TLX", "ILX", "RLX", "NSX", "Integra", "Legend", "Vigor", "CL", "CSX", "EL", "RSX", "SLX", "TSX", "ZDX"],
        "Cadillac": ["Escalade", "XT5", "XT6", "CT5", "CT6", "CTS", "ATS", "SRX", "XTS", "DeVille", "Fleetwood", "Seville", "Eldorado", "Brougham", "Cimarron", "Catera", "DTS", "STS", "XLR"],
        "Chrysler": ["300C", "Pacifica", "Voyager", "Grand Voyager", "PT Cruiser", "Sebring", "Crossfire", "Aspen", "Concorde", "LeBaron", "LHS", "Neon", "New Yorker", "Prowler", "Saratoga", "Stratus", "Town & Country", "Vision"],
        "Dodge": ["Challenger", "Charger", "Durango", "Journey", "Caliber", "Avenger", "Nitro", "Dart", "Magnum", "Neon", "Intrepid", "Stratus", "Viper", "Caravan", "Dakota", "Ram"],
        "Fiat": ["500", "Panda", "Punto", "Tipo", "Bravo", "Linea", "Palio", "Siena", "Stilo", "Uno", "Albea", "Croma", "Doblo", "Ducato", "Fiorino", "Freemont", "Fullback", "Idea", "Marea", "Multipla", "Qubo", "Scudo", "Sedici", "Strada", "Talento", "Tempra", "Ulysse"],
        "Alfa Romeo": ["Giulia", "Stelvio", "Giulietta", "4C", "8C", "Brera", "GT", "GTV", "MiTo", "Spider", "145", "146", "147", "155", "156", "159", "164", "166", "33", "75", "90", "Alfasud", "Alfetta", "Arna", "Berlina", "Giulietta", "Montreal", "RZ", "SZ", "Tonale"],
        "Suzuki": ["Swift", "Vitara", "SX4", "Jimny", "Ignis", "Baleno", "Celerio", "Alto", "Liana", "Grand Vitara", "Kizashi", "Splash", "Wagon R", "X-90", "Cappuccino", "Cervo", "Equator", "Esteem", "Forenza", "Kei", "Landy", "MR Wagon", "Palette", "Reno", "Sidekick", "Solio", "Spacia", "Twin", "Verona", "XL7"],
        "Daewoo": ["Lanos", "Nexia", "Matiz", "Leganza", "Nubira", "Tico", "Espero", "Prince", "Racer", "Super Salon", "Tacuma", "Evanda", "Kalos", "Lacetti", "Magnus", "Matiz Creative", "Musso", "Rezzo", "Tosca", "Winstorm"],
        "Lada": ["Granta", "Vesta", "Niva", "Largus", "XRAY", "4x4", "Kalina", "Priora", "Samara", "2101", "2102", "2103", "2104", "2105", "2106", "2107", "2108", "2109", "2110", "2111", "2112", "2113", "2114", "2115", "2121", "2123", "2129", "2131", "2328", "2329"],
        "UAZ": ["Patriot", "Hunter", "Pickup", "Cargo", "Bukhanka", "Profi", "452", "469", "3151", "3160", "3162", "3303", "3741", "3909", "3962", "2206", "3308", "3909", "39625"],
        "Geely": ["Atlas", "Coolray", "Tugella", "Emgrand", "Boyue", "MK", "Vision", "GC6", "GC9", "GS", "LC", "MK Cross", "SC7", "SL", "SX11", "TX4", "Panda", "Haoqing", "Merrie", "UL", "CK", "CK1", "CK2", "CK3", "FC", "FE", "FL", "FS", "FY", "GX5", "GX7", "GX9", "JL", "LC", "LE", "LG", "LH", "LK", "LM", "LN", "LP", "LS", "LT", "LU", "LV", "LW", "LX", "LY", "LZ", "MA", "MB", "MC", "MD", "ME", "MF", "MG", "MH", "MI", "MJ", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ"]
    ]
    
    static func models(for brand: String) -> [String] {
        return models[brand] ?? []
    }
    
    static func hasModel(_ model: String, for brand: String) -> Bool {
        return models[brand]?.contains(model) ?? false
    }

    static var availableBrands: [String] {
        return models.keys.sorted()
    }
}
