import Foundation
import KeyRun_core
import CoreGraphics

let ke = KeyEvent()
ke.handler = { type, event, flags -> Unmanaged<CGEvent>? in
//    let op = KeyOp(type, event)
    Unmanaged.passUnretained(event)
}
ke.start()
RunLoop.main.run()
