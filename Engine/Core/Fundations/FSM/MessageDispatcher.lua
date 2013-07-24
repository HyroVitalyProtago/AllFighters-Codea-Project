-- MessageDispatcher

MessageDispatcher = class()

MessageDispatcher.SEND_MSG_IMMEDIATELY = .0
MessageDispatcher.NO_ADDITIONAL_INFO = 0

function MessageDispatcher:init()

	-- a std::set is used as the container for the delayed messages
	-- because of the benefit of automatic sorting and avoidance
	-- of duplicates. Messages are sorted by their dispatch time.
	self.priorityQ = {}

	if MessageDispatcher.instance then
        assert(false, "Pattern Singleton")
    end

end

-- this method is utilized by DispatchMessage or DispatchDelayedMessages.
-- This method calls the message handling member function of the receiving
-- entity, pReceiver, with the newly created telegram
function MessageDispatcher:_discharge(receiver, telegram)
	if (not receiver:handleMessage(telegram)) then
    	-- telegram could not be handled
    	print("Message not handled")
	end
end

--  given a message, a receiver, a sender and any time delay , this function
--  routes the message to the correct agent (if no delay) or stores
--  in the message queue to be dispatched at the correct time
function MessageDispatcher:dispatchMessage(delay, sender, receiver, msg, extraInfo) -- double, int, int, int, {}
	-- get pointers to the sender and receiver
	pSender = EntityManager.instance:getEntityFromID(sender)
	pReceiver = EntityManager.instance:getEntityFromID(receiver)

	-- make sure the receiver is valid
	if (receiver == nil) then
		print("Warning! No Receiver with ID of " .. receiver .. " found")
		return
	end

	-- create the telegram
	telegram = Telegram(0, sender, receiver, msg, extraInfo);

	-- if there is no delay, route telegram immediately                       
	if (delay <= .0) then

		print("Instant telegram dispatched at time: " .. os.clock()
	     .. " by " .. EntityManager.instance:getNameOfEntity(pSender:ID()) .. " for "
	     .. EntityManager.instance:getNameOfEntity(pReceiver:ID())
	     .. ". Msg is ".. msg)

		-- send the telegram to the recipient
		self:_discharge(pReceiver, telegram)

	else -- else calculate the time when the telegram should be dispatched
		currentTime = os.clock()

		telegram.dispatchTime = currentTime + delay

		-- and put it in the queue
		self.priorityQ[#self.priorityQ+1] = telegram
		table.sort(self.priorityQ, function (e1, e2)
		 	return e1.dispatchTime > e2.dispatchTime
		end)

		print("Delayed telegram from " .. EntityManager.instance:getNameOfEntity(pSender:ID())
			.. " recorded at time " .. os.clock() .. " for "
			.. EntityManager.instance:getNameOfEntity(pReceiver:ID())
		    .. ". Msg is ".. msg)

	end
end

--  This function dispatches any telegrams with a timestamp that has
--  expired. Any dispatched telegrams are removed from the queue
function MessageDispatcher:dispatchDelayedMessages()
	-- get current time
	currentTime = os.clock()

	-- now peek at the queue to see if any telegrams need dispatching.
	-- remove all telegrams from the front of the queue that have gone
	-- past their sell by date
	while ( not #self.priorityQ == 0 and
	     (self.priorityQ[1].dispatchTime < currentTime) and
	     (self.priorityQ[1].dispatchTime > 0) ) do
		
		-- read the telegram from the front of the queue
		telegram = self.priorityQ[1]

		-- find the recipient
		pReceiver = EntityManager.instance:getEntityFromID(telegram.receiver)

		print("Queued telegram ready for dispatch: Sent to " 
		     .. EntityManager.instance:getNameOfEntity(pReceiver:ID())
		     .. ". Msg is " .. telegram.msg)

		-- send the telegram to the recipient
		self:_discharge(pReceiver, telegram)

		-- remove it from the queue
		table.remove(self.priorityQ, 1)
	end
end

MessageDispatcher.instance = MessageDispatcher()