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

        
        let data: Data = Code.data(using: String.Encoding.utf8)!
        do{ if let jsonCode = try? JSONDecoder().decode(JsonCode.self, from: data){
            nameData=jsonCode.name
            numberData=jsonCode.number}else{
                print("error")
            }
                print(nameData)
                print(numberData)
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
let allHospitalCode:Dictionary<String,String> = ["A病院":"111","B病院":"222","C病院":"333","D病院":"444","E病院":"555","F病院":"666"]
