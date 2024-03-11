import SwiftUI

struct ContentView: View {
    @State private var str = "受信開始前です。"
    @State private var isReceiving = false
    @State private var isSetCallback = false
    @State private var lib = LibCpp()
    
    var body: some View {
        VStack {
            Button("メッセージ送信") {
                if !isSetCallback {
                    lib.setCallback({ (message: String?) in
                        self.debugCallBack(test: message)
                    }, receive: { (message: String?) in
                        self.receiveData(message: message)
                    }, start: { (message: String?) in
                        self.debugCallBack(test: message)
                    })
                }
                lib.sendUDPMessage("10.0.2.81", port: 1234, message: "Swiftから送信しています！")
            }
            Button(isReceiving ? "Stop Receiving" : "Start Receiving") {
                self.isReceiving.toggle()
                
                if self.isReceiving {
                    lib.setCallback({ (message: String?) in
                        self.debugCallBack(test: message)
                    }, receive: { (message: String?) in
                        self.receiveData(message: message)
                    }, start: { (message: String?) in
                        self.debugCallBack(test: message)
                    })
                    isSetCallback = true
                    
                    lib.preReceiveUDPMessage(1234)
                    self.startReceiving()
                    
                } else {
                    stopReceiving()
                }
            }
            Text(str)
        }
        .padding()
        .onDisappear { // このViewが破棄される時に呼ばれる
            print("アプリケーションの停止")
            self.stopReceiving()
        }
    }
    
    func debugCallBack(test: String?) {
        if let test = test {
            print("Callback ... \(test)")
        }
    }
    
    func startReceiving() {
        DispatchQueue.global(qos: .background).async {
            while self.isReceiving {
                // 以下は仮のC++関数呼び出し
                lib.receiveUDPMessage() // 仮の関数名
            }
            print("stop ... while")
        }
    }
    
    func stopReceiving() {
        print("stop ... stopReceiving")
        self.isReceiving = false
        lib.socketClose()
    }
    
    func receiveData(message: String?){
        if let message = message {
            str = message
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
