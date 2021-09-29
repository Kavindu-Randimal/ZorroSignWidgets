//
//  DashboardWidget.swift
//  DashboardWidget
//
//  Created by Randimal Geeganage on 2021-06-19.
//

import WidgetKit
import SwiftUI

struct Model : TimelineEntry {
    var date : Date
    var widgetData : [JSONModel]
}

struct JSONModel: Decodable,Hashable {

    var date : CGFloat
    var Esign : Int?
    var Pending : Int?
    var Completed : Int?
    var Canceled : Int?

}



struct Provider : TimelineProvider {
    
    
    func getSnapshot(in context: Context, completion: @escaping (Model) -> ()) {
        let loadingData = Model(date: Date(), widgetData: Array(repeating: JSONModel(date: 0, Esign: 0, Pending: 0, Completed: 0, Canceled: 0), count: 0))
        completion(loadingData)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Model>) -> ()) {
        getData{ (modelData) in
            
            let date = Date()
            let data = Model(date: date, widgetData: modelData)
            
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 2 , to: date)
            let timeLine = Timeline(entries: [data], policy: .after(nextUpdate!))
            
            completion(timeLine)
        }
    }
    
    func placeholder(in context: Context) -> Model {
        return Model(date: Date(), widgetData: Array(repeating: JSONModel(date: 0, Esign: 0, Pending: 0, Completed: 0, Canceled: 0), count: 0))
    }
}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct WidgetViewView : View {
    var data : Model
    
    var body: some View {
        VStack {
            if data.widgetData.isEmpty {
                VStack {
                    Text("Dashboard")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                }
                
            }else{
                
                VStack{
                    
                    // MARK -: last updated time we can put here like this
                    // HStack{
                    //    Text("Last updated : ")
                    //        .font(.caption2)
                    //        .foregroundColor(.green)
                        
                    //    Text(Date(),style:.time)
                    //        .font(.caption2)
                    //        .foregroundColor(.green)
                    //}
                    //.padding(4)
                    HStack{
                        
                        
                        VStack{
                            Image("inbox")
                                .resizable()
                                .frame(width: 32, height: 32, alignment: .leading)
                            
                            
                            Text("\(data.widgetData[0].Esign)")
                                .foregroundColor(Color.init(#colorLiteral(red: 0, green: 0.6519529223, blue: 0, alpha: 1)))
                                .font(.system(size: 10).weight(.heavy))
                            
                        }
                        Spacer()
                            .frame(width:30)
                        VStack{
                            Image("inprocess")
                                .resizable()
                                .frame(width: 32, height: 32, alignment: .leading)
//                                .foregroundColor(Color.init(#colorLiteral(red: 0.153, green: 0.671, blue: 0.067, alpha: 1)))
                                
                            
                            Text("\(data.widgetData[1].Pending)")
                                .foregroundColor(Color.init(#colorLiteral(red: 0, green: 0.6519529223, blue: 0, alpha: 1)))
                                .font(.system(size: 10).weight(.heavy))
                        }
                    }
//                    .frame(width: 100, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    HStack{
                        VStack{
                            Image("completed")
                                .resizable()
                                .frame(width: 32, height: 32, alignment: .leading)
                            
                            
                            Text("\(data.widgetData[2].Completed)")
                                .foregroundColor(Color.init(#colorLiteral(red: 0, green: 0.6519529223, blue: 0, alpha: 1)))
                                .font(.system(size: 10).weight(.heavy))
                        }
                        Spacer()
                            .frame(width:30)
                        VStack{
                            Image("rejected")
                                .resizable()
                                .frame(width: 32, height: 32, alignment: .leading)
                            
                            Text("\(data.widgetData[3].Canceled)")
                                .foregroundColor(Color.init(#colorLiteral(red: 0, green: 0.6519529223, blue: 0, alpha: 1)))
                                .font(.system(size: 10).weight(.heavy))
                        }
                    }
                }
            }
        }
//        .background(Color.accentColor)
    }
}

@main
struct DashboardWidget: Widget {
    let kind: String = "DashboardWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "DashboardWidget",provider: Provider()) { data in
            WidgetViewView (data: data)
        }
        .description(Text("Zorrosign Dashboard widget."))
        .configurationDisplayName("Dashboard Widget")
    }
}


// MARK -: fetch data
let token = "bXW8CuRVhxnYkt47lufc6zg7mvOP8DETmJIVb1KFdrOkCD5hmVcdrXlFYUs1tnBWelX9X5sFR06C2b2RoKmYj4xvQIovTJvEOSt2DE5yVsR3GWlJX6Ves9NrSmVpPsBQ"


func getData(completion: @escaping([JSONModel]) -> ()) {
    let url = "https://zswebworkflowqa.entrusttitle.net/api/v1/dashboard/GetCountForCategory?labelId=-1&dashboardCategory=0"
    
       
    let session = URLSession(configuration: .default)
    
    session.dataTask(with: URL(string: url)!) { (data, _, err) in
        
        if err != nil{
            print((err!.localizedDescription))
            return
        }
        do{
            let jsonData = try JSONDecoder().decode([JSONModel].self, from: data!)
            completion(jsonData)
            
        }
        catch{
            print(error.localizedDescription)
        }
    }.resume()
}

