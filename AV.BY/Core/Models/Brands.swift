//
//  Brands.swift
//  AV.BY
//
//  Created by Кирилл Котыло on 19.11.25.
//

struct Brands {
    
    static let brandsByLetter: [String: [String]] = [
        "A": ["Abarth", "Acura", "Adler", "Alfa Romeo", "Alpina", "Alpine", "Aro", "Asia", "Aston Martin", "Audi", "Austin", "Autobianchi"],
        "B": ["BAIC", "Bajaj", "Bentley", "BMW", "Borgward", "Brilliance", "Bugatti", "Buick", "BYD"],
        "C": ["Cadillac", "Caterham", "Changan", "Chery", "Chevrolet", "Chrysler", "Citroen", "Cupra"],
        "D": ["Dacia", "Daewoo", "Daihatsu", "Datsun", "Denza", "Derways", "DFSK", "Dodge", "Dongfeng", "DS"],
        "E": ["Eagle", "Exeed"],
        "F": ["FAW", "Ferrari", "Fiat", "Ford", "Foton", "FSO"],
        "G": ["GAC", "Geely", "Genesis", "GMC", "Gonow", "Great Wall"],
        "H": ["Haval", "Honda", "Hongqi", "Hummer", "Hyundai"],
        "I": ["Infiniti", "Iran Khodro", "Isuzu", "IVECO"],
        "J": ["JAC", "Jaguar", "Jeep", "Jetta"],
        "K": ["Kia", "Koenigsegg"],
        "L": ["Lada", "Lamborghini", "Lancia", "Land Rover", "Lexus", "Lifan", "Lincoln", "Lotus", "LTI", "Luxgen"],
        "M": ["Mahindra", "Maserati", "Maybach", "Mazda", "McLaren", "Mercedes-Benz", "Mercury", "MG", "Micro", "Mini", "Mitsubishi", "Mitsuoka", "Morgan", "Morris"],
        "N": ["Nissan", "Nysa"],
        "O": ["Oldsmobile", "Opel", "Osca"],
        "P": ["Pagani", "Peugeot", "Plymouth", "Pontiac", "Porsche", "Proton", "PUCH"],
        "R": ["Ravon", "Renault", "Riley", "Rolls-Royce", "Rover"],
        "S": ["Saab", "Saleen", "Saturn", "Scion", "Seat", "Shuanghuan", "Skoda", "Smart", "Soueast", "SsangYong", "Subaru", "Suzuki"],
        "T": ["Talbot", "Tata", "Tatra", "Tesla", "Think", "Tianma", "Tofas", "Toyota", "Trabant", "Triumph"],
        "U": ["UAZ", "Ultima"],
        "V": ["Vauxhall", "Volga", "Volvo", "Volkswagen", "Vortex", "Voyah"],
        "W": ["Wartburg", "Westfield", "Wiesmann", "Wuling"],
        "X": ["Xin Kai"],
        "Z": ["Zastava", "Zotye", "ZX", "ЛуАЗ", "Москвич", "ТагАЗ", "УАЗ"]
    ]
    
    static var allBrands: [String] {
        return brandsByLetter.values.flatMap { $0 }.sorted()
    }
    
    static func brands(for letter: String) -> [String] {
        return brandsByLetter[letter] ?? []
    }
    
    static var availableLetters: [String] {
        return brandsByLetter.keys.sorted()
    }
}
