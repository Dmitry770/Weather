
import Foundation

struct ForecastWeather: Codable {
	let message : String
	let cod : String
	let count : Int
	let list : [List]

	enum CodingKeys: String, CodingKey {

		case message = "message"
		case cod = "cod"
		case count = "count"
		case list = "list"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		message = try values.decode(String.self, forKey: .message)
		cod = try values.decode(String.self, forKey: .cod)
		count = try values.decode(Int.self, forKey: .count)
		list = try values.decode([List].self, forKey: .list)
	}

}


