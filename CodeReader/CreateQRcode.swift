import Foundation
import UIKit
struct JsonCode: Codable {
    var name:String = ""
    var number:Int = 0
}
var nameData:String = ""
var numberData:Int = 0
class CreateQRcode: UIImage{
    func createQR(from code: String) -> UIImage? {
        let data = code.data(using: String.Encoding.utf8)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 3, y: 3)
        guard let output = filter?.outputImage?.transformed(by: transform) else{
            return nil
        }
        return UIImage(ciImage: output)
    }
}
let createQRcode = CreateQRcode()
class JsonParse {
    func Parse(){
        if Code[Code.startIndex] != "[" {
            Code = "["+Code+"]"
        }
        let data: Data = Code.data(using: String.Encoding.utf8)!
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            let array = json as! NSArray
            for roop in array {
                let allData = roop as! NSDictionary
                nameData = allData["name"] as! String
                numberData = allData["number"] as! Int
                print(nameData)
                print(numberData)
            }
        }catch{
            print("error")
        }
    }
/*    func chengeData(){
        guard let hospitalCode = allHospitalCode[nameData] else {
            print("error")
            return
        }
        numberData = Int(String(numberData) + String(hospitalCode))!
        self.createJson()
        print(Code)
    }
 */
    func chengeData(){
        
    }
    func createJson(){
        let jsonCode = JsonCode(name: nameData, number: numberData)
        if let data =  try? JSONEncoder().encode(jsonCode){
            if let code = String(data: data, encoding: .utf8) {
                Code = code
            } else{
                print("error")
            }
        }else{
            print("error")
        }
    }
}
let jsonParse = JsonParse()
//let allHospitalCode:Dictionary<String, Int> = ["A病院":100, "B病院":200, "C病院":300]
let allHospitalCode:Dictionary<String,String> = ["A病院":"111","B病院":"222","C病院":"333","D病院":"444","E病院":"555","F病院":"555"]
