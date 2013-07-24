Telegram = class()

function Telegram:init(sender, receiver, msg, dispatchTime, extraInfo)
    self.sender = sender
    self.receiver = receiver
    self.msg = msg
    self.dispatchTime = dispatchTime
    self.extraInfo = extraInfo
end