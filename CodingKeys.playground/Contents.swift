import Cocoa

// https://swapi.co/api/people/1/

struct Person: Codable {
    let name: String
    let height: Int
    let hairColor: String
    let films: [URL]
    
    enum PersonKeys: String, CodingKey {
        case name
        case height
        case hairColor = "hair_color"
        case films
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PersonKeys.self)
        name = try container.decode(String.self, forKey: .name)
        let heightString = try container.decode(String.self, forKey: .height)
        height = Int(heightString) ?? 0
        hairColor = try container.decode(String.self, forKey: .hairColor)
        
        var filmsContainer = try container.nestedUnkeyedContainer(forKey: .films)
        var filmUrls: [URL] = []
        while filmsContainer.isAtEnd == false {
            let filmString = try filmsContainer.decode(String.self)
            if let url = URL(string: filmString) {
                filmUrls.append(url)
            }
        }
        films = filmUrls
    }
    
}

let baseURL = URL(string: "https://swapi.co/api/people/1/")!
let data = try! Data(contentsOf: baseURL)
let luke = try! JSONDecoder().decode(Person.self, from: data)
print(luke)
